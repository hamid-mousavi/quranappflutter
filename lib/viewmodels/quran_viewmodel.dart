import 'package:flutter/material.dart';
import 'package:quran/service/json_quran_service.dart';
import '../data/database/quran_database_service.dart';
import '../models/quran_ayah.dart';

class QuranViewModel extends ChangeNotifier {
  final JsonQuranService _dbService = JsonQuranService();
  List<QuranAyah> _ayat = [];
  bool _loading = false;

  List<QuranAyah> get ayat => _ayat;
  bool get isLoading => _loading;

  Future<void> loadAyatBySura(int suraId) async {
    _loading = true;
    notifyListeners();

    _ayat = await _dbService.getAyatBySura(suraId);

    _loading = false;
    notifyListeners();
  }
}
