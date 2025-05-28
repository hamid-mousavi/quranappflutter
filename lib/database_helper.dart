import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuranDatabaseHelper {
  static final QuranDatabaseHelper _instance = QuranDatabaseHelper._internal();
  static Database? _database;

  factory QuranDatabaseHelper() => _instance;

  QuranDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "quran.db");

    // فقط اگر فایل وجود نداشت کپی کن
    if (!await File(path).exists()) {
      ByteData data = await rootBundle.load("assets/quran.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getSuraById(int id) async {
    final db = await database;
    return await db.query('sura', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllSuras() async {
    final db = await database;
    return await db.query('sura');
  }

  Future<void> insertBookmark(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('bookmark', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateAyah(Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db.update('ayah', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBookmark(int id) async {
    final db = await database;
    return await db.delete('bookmark', where: 'id = ?', whereArgs: [id]);
  }
}
