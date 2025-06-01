import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/models/quran_translation.dart';
import 'package:quran/viewmodels/quran_view_model.dart';
import 'package:quran/viewmodels/settings_view_model.dart';
import 'package:quran/views/widgets/ayah_widget.dart';

class LatestPageScreen extends StatelessWidget {
  const LatestPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranViewModel>(context);
    final setting = Provider.of<SettingsViewModel>(context);
    if (viewModel.latestPageList.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final latestPage = viewModel.latestPageList.first;
    final ayahs = viewModel.quranTextList
        .where((ayah) => ayah.pageNo == int.parse(latestPage.pageNo))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('آخرین صفحه')),
      body: ListView.builder(
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          final ayah = ayahs[index];
          final translation = viewModel.quranTranslationList.firstWhere(
            (trans) => trans.sura == ayah.sura && trans.aya == ayah.aya,
            orElse: () => QuranTranslation(index: 0, sura: 0, aya: 0, text: ''),
          );
          return AyahWidget(
            ayah: ayah,
            translation: translation.text.isNotEmpty ? translation : null,
            settings: setting,
          );
        },
      ),
    );
  }
}
