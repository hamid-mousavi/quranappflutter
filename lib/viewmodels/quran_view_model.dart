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

  Future<void> loadData(BuildContext context) async {
    try {
      quranJozList = await _service.loadQuranJoz(context);
      latestPageList = await _service.loadLatestPage(context);
      quranTextList = await _service.loadQuranText(context);
      quranNameList = await _service.loadQuranNames(context);
      quranTranslationList = await _service.loadQuranTranslations(context);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'خطا در بارگذاری داده‌ها: $e';
    }
    notifyListeners();
  }

  List<QuranText> getAyahsBySura(int sura) {
    return quranTextList.where((ayah) => ayah.sura == sura).toList();
  }

  List<QuranTranslation> getTranslationsBySura(int sura) {
    return quranTranslationList.where((trans) => trans.sura == sura).toList();
  }
  // گرفتن اولین آیه‌ای که در صفحه خاصی قرار دارد
QuranText? getAyahByPage(int pageNo) {
  return quranTextList.firstWhere(
    (ayah) => ayah.pageNo == pageNo,
    // orElse: () => null,
  );
}

// گرفتن اولین آیه‌ای که در جزء خاصی قرار دارد
QuranText? getFirstAyahOfJoz(int jozId) {
  final joz = quranJozList.firstWhere((j) => j.id == jozId,
  //  orElse: () => null
   );
  if (joz != null) {
    return getAyahByPage(joz.pageNoSt);
  }
  return null;
}

// گرفتن لیست صفحات موجود
List<int> getAllPages() {
  return quranTextList.map((ayah) => ayah.pageNo).toSet().toList()..sort();
}

// گرفتن لیست اجزاء
List<QuranJoz> getAllJoz() {
  return quranJozList;
}

// گرفتن ایندکس سوره با توجه به شماره سوره (برای pageView)
int getSuraIndexById(int suraId) {
  return quranNameList.indexWhere((name) => name.id == suraId);
}

}
