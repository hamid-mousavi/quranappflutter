import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quran_ayah.dart';

class JsonQuranService {
  static final JsonQuranService _instance = JsonQuranService._internal();
  factory JsonQuranService() => _instance;
  JsonQuranService._internal();

  List<QuranAyah> _allAyat = [];

  Future<void> loadQuran() async {
    if (_allAyat.isNotEmpty) return;

    final arabicData =
        await rootBundle.loadString('assets/json/quran_text.json');
    final translationData =
        await rootBundle.loadString('assets/json/fa_makarem.json');

    final arabicList = json.decode(arabicData) as List;
    final translationList = json.decode(translationData) as List;

    _allAyat = List.generate(arabicList.length, (index) {
      final a = arabicList[index];
      final t = translationList[index];
      return QuranAyah(
        id: index + 1,
        sura: a['sura'],
        aya: a['aya'],
        text: a['text'],
        pageNo: a['page'],
        translation: t['text'],
      );
    });
  }

  Future<List<QuranAyah>> getAyatBySura(int suraId) async {
    await loadQuran();
    return _allAyat.where((a) => a.sura == suraId).toList();
  }

  Future<QuranAyah?> getAyah(int suraId, int ayaId) async {
    await loadQuran();
    try {
      return _allAyat.firstWhere(
        (a) => a.sura == suraId && a.aya == ayaId,
      );
    } catch (e) {
      return null;
    }
  }
}
