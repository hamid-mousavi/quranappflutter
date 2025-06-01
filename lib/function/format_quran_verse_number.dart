import 'package:flutter/src/widgets/framework.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:quran/viewmodels/quran_view_model.dart';
import 'package:quran/viewmodels/settings_view_model.dart';

String formatQuranicVerseNumber(int number) {
  //  final settings = Provider.of<SettingsViewModel>(context as BuildContext, listen: false);
  const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  final numStr =
      number.toString().split('').map((d) => arabicDigits[int.parse(d)]).join();

  // return '﴿$numStr﴾';
  return '$numStr';
}
