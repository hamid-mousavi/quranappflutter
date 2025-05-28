import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quran/models/latest_page.dart';
import 'package:quran/models/quran_joz.dart';
import 'package:quran/models/quran_name.dart';
import 'package:quran/models/quran_text.dart';
import 'package:quran/models/quran_translation.dart';

class QuranService {
  Future<List<QuranJoz>> loadQuranJoz(BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/quranJOZ.json');

      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => QuranJoz.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LatestPage>> loadLatestPage(BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/latest_page.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => LatestPage.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuranText>> loadQuranText(BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/quran_text.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => QuranText.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuranName>> loadQuranNames(BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/quranNameList.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => QuranName.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuranTranslation>> loadQuranTranslations(
      BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/fa_makarem.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => QuranTranslation.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
