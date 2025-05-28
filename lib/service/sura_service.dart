import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/sura_model.dart';

class SuraService {
  static final SuraService _instance = SuraService._internal();
  factory SuraService() => _instance;
  SuraService._internal();

  List<Sura> _suras = [];

  Future<List<Sura>> getAllSuras() async {
    if (_suras.isNotEmpty) return _suras;

    final jsonString =
        await rootBundle.loadString('assets/json/quranNameList.json');
    final data = json.decode(jsonString) as List;
    print("🔎 داده خام JSON: $data");

    _suras = data.map((e) => Sura.fromJson(e)).toList();
    return _suras;
  }
}
