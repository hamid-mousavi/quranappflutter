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
  List<int> favoriteSuraIds = []; // لیست آیدی‌های سوره‌های علاقه‌مندی
  List<QuranName> filteredSuraList = []; // لیست فیلترشده برای نمایش

  QuranViewModel() {
    filteredSuraList = quranNameList; // در ابتدا لیست کامل
  }

  Future<void> loadData(BuildContext context) async {
    try {
      quranJozList = await _service.loadQuranJoz(context);
      latestPageList = await _service.loadLatestPage(context);
      quranTextList = await _service.loadQuranText(context);
      quranNameList = await _service.loadQuranNames(context);
      quranTranslationList = await _service.loadQuranTranslations(context);
      filteredSuraList = quranNameList; // مقداردهی اولیه لیست فیلترشده
      errorMessage = null;
    } catch (e) {
      errorMessage = 'خطا در بارگذاری داده‌ها: $e';
    }
    notifyListeners();
  }

  // جستجوی سوره‌ها
  void filterSuras(String query) {
    if (query.isEmpty) {
      filteredSuraList = quranNameList;
    } else {
      filteredSuraList = quranNameList
          .where((sura) =>
              sura.sura.toLowerCase().contains(query.toLowerCase()) ||
              sura.id.toString().contains(query))
          .toList();
    }
    notifyListeners();
  }

  // فیلتر بر اساس جزء
  void filterByJuz() {
    // برای سادگی، فرض می‌کنیم همه سوره‌ها نمایش داده شوند، اما می‌توانید منطق خاصی برای جزء اضافه کنید
    filteredSuraList = quranNameList;
    notifyListeners();
  }

  // فیلتر بر اساس علاقه‌مندی‌ها
  void filterFavorites() {
    filteredSuraList = quranNameList
        .where((sura) => favoriteSuraIds.contains(sura.id))
        .toList();
    notifyListeners();
  }

  // بازگرداندن به حالت اولیه
  void resetFilter() {
    filteredSuraList = quranNameList;
    notifyListeners();
  }

  // بررسی وضعیت علاقه‌مندی
  bool isFavorite(int suraId) {
    return favoriteSuraIds.contains(suraId);
  }

  // تغییر وضعیت علاقه‌مندی
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
    return quranTextList.firstWhere(
      (ayah) => ayah.pageNo == pageNo,
      orElse: () => null as QuranText, // اصلاح برای سازگاری با نوع بازگشتی
    );
  }

  QuranText? getFirstAyahOfJoz(int jozId) {
    final joz = quranJozList.firstWhere(
      (j) => j.id == jozId,
      orElse: () => null as QuranJoz, // اصلاح برای سازگاری
    );
    if (joz != null) {
      return getAyahByPage(joz.pageNoSt);
    }
    return null;
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
}