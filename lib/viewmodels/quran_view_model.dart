import 'package:flutter/material.dart';
import 'package:quran/models/latest_page.dart';
import 'package:quran/models/quran_joz.dart';
import 'package:quran/models/quran_name.dart';
import 'package:quran/models/quran_text.dart';
import 'package:quran/models/quran_translation.dart';
import 'package:quran/service/quran_service.dart';

class QuranViewModel extends ChangeNotifier {
  final QuranService _service = QuranService();
  List<QuranJoz> quranJozList = [];
  List<LatestPage> latestPageList = [];
  List<QuranText> quranTextList = [];
  List<QuranName> quranNameList = [];
  List<QuranTranslation> quranTranslationList = [];
  String? errorMessage;
  List<int> favoriteSuraIds = [];
  List<QuranName> filteredSuraList = [];
  Map<int, List<QuranText>> matchingAyahs = {}; // آیات مطابق برای هر سوره

  QuranViewModel() {
    filteredSuraList = quranNameList;
  }

  // تابع نرمال‌سازی متن عربی برای حذف اعراب و علائم خاص
  String normalizeArabic(String text) {
    final arabicDiacritics = RegExp(
        r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]');
    return text
        .replaceAll(arabicDiacritics, '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<void> loadData(BuildContext context) async {
    try {
      quranJozList = await _service.loadQuranJoz(context);
      latestPageList = await _service.loadLatestPage(context);
      quranTextList = await _service.loadQuranText(context);
      quranNameList = await _service.loadQuranNames(context);
      quranTranslationList = await _service.loadQuranTranslations(context);
      filteredSuraList = quranNameList;
      errorMessage = null;
    } catch (e) {
      errorMessage = 'خطا در بارگذاری داده‌ها: $e';
      print(errorMessage);
    }
    notifyListeners();
  }

  void filterSuras(String query) {
    matchingAyahs.clear(); // پاک کردن آیات قبلی
    if (query.isEmpty) {
      filteredSuraList = quranNameList;
      print('Query is empty, showing all suras: ${filteredSuraList.length}');
    } else {
      final normalizedQuery = normalizeArabic(query).toLowerCase();
      final suraNameMatches = <QuranName>[]; // تطبیق نام سوره
      final ayahContentMatches = <QuranName>[]; // تطبیق محتوای آیات
      final matchingSuraIds = <int>{}; // برای جلوگیری از تکرار

      // جستجو در نام سوره‌ها
      for (var sura in quranNameList) {
        final normalizedSuraName = normalizeArabic(sura.sura).toLowerCase();
        if (normalizedSuraName.contains(normalizedQuery) ||
            sura.id.toString().contains(query)) {
          suraNameMatches.add(sura);
          matchingSuraIds.add(sura.id);
        }
      }

      // جستجو در محتوای آیات
      for (var ayah in quranTextList) {
        final normalizedAyahText = normalizeArabic(ayah.text).toLowerCase();
        if (normalizedAyahText.contains(normalizedQuery)) {
          if (!matchingSuraIds.contains(ayah.sura)) {
            final sura = quranNameList.firstWhere((s) => s.id == ayah.sura);
            ayahContentMatches.add(sura);
            matchingSuraIds.add(ayah.sura);
          }
          matchingAyahs.putIfAbsent(ayah.sura, () => []).add(ayah);
        }
      }

      // ترکیب لیست‌ها: ابتدا تطبیق نام، سپس تطبیق آیات
      filteredSuraList = [...suraNameMatches, ...ayahContentMatches];

      print(
          'Query: "$query", Normalized: "$normalizedQuery", Found ${filteredSuraList.length} suras '
          '(${suraNameMatches.length} name matches, ${ayahContentMatches.length} ayah matches)');
    }
    notifyListeners();
  }

  void filterFavorites() {
    filteredSuraList = quranNameList
        .where((sura) => favoriteSuraIds.contains(sura.id))
        .toList();
    notifyListeners();
  }

  void resetFilter() {
    filteredSuraList = quranNameList;
    matchingAyahs.clear();
    notifyListeners();
  }

  bool isFavorite(int suraId) {
    return favoriteSuraIds.contains(suraId);
  }

  void toggleFavorite(int suraId) {
    if (favoriteSuraIds.contains(suraId)) {
      favoriteSuraIds.remove(suraId);
    } else {
      favoriteSuraIds.add(suraId);
    }
    notifyListeners();
  }

  List<QuranText> getAyahsBySura(int sura) {
    return quranTextList.where((ayah) => ayah.sura == sura).toList();
  }

  List<QuranTranslation> getTranslationsBySura(int sura) {
    return quranTranslationList.where((trans) => trans.sura == sura).toList();
  }

  QuranText? getAyahByPage(int pageNo) {
    try {
      final ayah = quranTextList.firstWhere(
        (ayah) => ayah.pageNo == pageNo,
        orElse: () => QuranText(
            index: 0,
            sura: 0,
            aya: 0,
            text: '',
            pageNo: 0,
            joz: 0,
            textClean: ''),
      );
      return ayah.sura != 0 ? ayah : null;
    } catch (e) {
      print('Error in getAyahByPage: $e');
      return null;
    }
  }

  QuranText? getFirstAyahOfJoz(int jozId) {
    try {
      final joz = quranJozList.firstWhere(
        (j) => j.id == jozId,
        orElse: () => QuranJoz(id: 0, joz: '', pageNoSt: 0),
      );
      if (joz.id != 0) {
        return getAyahByPage(joz.pageNoSt);
      }
      return null;
    } catch (e) {
      print('Error in getFirstAyahOfJoz: $e');
      return null;
    }
  }

  List<int> getAllPages() {
    return quranTextList.map((ayah) => ayah.pageNo).toSet().toList()..sort();
  }

  List<QuranJoz> getAllJoz() {
    return quranJozList;
  }

  int getSuraIndexById(int suraId) {
    return quranNameList.indexWhere((name) => name.id == suraId);
  }

  int getAyahCountBySura(int suraId) {
    if (!quranNameList.any((sura) => sura.id == suraId)) {
      print('سوره با شناسه $suraId یافت نشد');
      return 0;
    }
    return quranTextList.where((ayah) => ayah.sura == suraId).length;
  }
}
