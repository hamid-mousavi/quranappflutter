import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/quran_ayah.dart';
import '../../models/quran_translation.dart';

class QuranDatabaseService {
  static final QuranDatabaseService _instance =
      QuranDatabaseService._internal();
  static Database? _db;

  factory QuranDatabaseService() => _instance;

  QuranDatabaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, "quran.db");

    if (!await File(path).exists()) {
      ByteData data = await rootBundle.load("assets/quran.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  Future<List<QuranAyah>> getAyatBySura(int suraId) async {
    final db = await database;
    final result = await db.query(
      'quran_text',
      where: 'sura = ?',
      whereArgs: [suraId],
      orderBy: 'aya ASC',
    );
    return result.map((e) => QuranAyah.fromMap(e)).toList();
  }

  Future<QuranTranslation?> getTranslation(
      int sura, int aya, String table) async {
    final db = await database;
    final result = await db.query(
      table,
      where: 'sura = ? AND aya = ?',
      whereArgs: [sura, aya],
    );
    if (result.isNotEmpty) {
      return QuranTranslation.fromMap(result.first);
    }
    return null;
  }
}
