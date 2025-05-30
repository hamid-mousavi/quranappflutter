import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/models/quran_text.dart';
import 'package:quran/models/quran_translation.dart';
import 'package:quran/viewmodels/settings_view_model.dart';

class AyahWidget extends StatelessWidget {
  final QuranText ayah;
  final QuranTranslation? translation;

  const AyahWidget({required this.ayah, this.translation, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsViewModel>(context);

    return Padding(
      
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          DisplayMode(
            ayah: ayah,
            settings: settings,
            translation: translation!,
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }
}

class DisplayMode extends StatelessWidget {
  const DisplayMode({
    Key? key,
    required this.ayah,
    required this.translation,
    required this.settings,
  }) : super(key: key);

  final QuranText ayah;
  final SettingsViewModel settings;
  final QuranTranslation translation;

  @override
  Widget build(BuildContext context) {
    if (settings.displayMode == 'text_and_translation') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${ayah.text} (${ayah.aya})',
            textAlign: settings.alignment ? TextAlign.justify : TextAlign.right,
            style: TextStyle(
              fontSize: settings.fontSize,
              color: settings.textColor,
              fontFamily: settings.font,
              height: 2.5,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 10),
          Text(
            translation!.text,
            textAlign: settings.alignment ? TextAlign.justify : TextAlign.right,
            style: TextStyle(
              fontSize: settings.fontSize,
              fontFamily: settings.translationFont,
              color: settings.translationColor,
              height: 2.5,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      );
    } else if (settings.displayMode == 'text_only') {
      return Text(
        '${ayah.text} (${ayah.aya})',
        textAlign: settings.alignment ? TextAlign.justify : TextAlign.right,
        style: TextStyle(
          fontSize: settings.fontSize,
          fontFamily: settings.font,
          color: settings.textColor,
          height: 2.5,
        ),
        textDirection: TextDirection.rtl,
      );
    } else {
      return Text(
        translation!.text,
        textAlign: settings.alignment ? TextAlign.justify : TextAlign.right,
        style: TextStyle(
          fontSize: settings.fontSize,
          fontFamily: settings.translationFont,
          color: settings.translationColor,
          height: 2.5,
        ),
        textDirection: TextDirection.rtl,
      );
    }
  }
}
