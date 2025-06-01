import 'package:flutter/material.dart';
import 'package:quran/function/format_quran_verse_number.dart';
import 'package:quran/models/quran_text.dart';
import 'package:quran/models/quran_translation.dart';
import 'package:quran/viewmodels/settings_view_model.dart';

class AyahWidget extends StatelessWidget {
  final QuranText ayah;
  final QuranTranslation? translation;
  final SettingsViewModel settings;
  final bool isHighlighted;

  const AyahWidget({
    Key? key,
    required this.ayah,
    this.translation,
    required this.settings,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.yellow.withOpacity(0.3) : null,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _DisplayMode(),
            const SizedBox(height: 10),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class _DisplayMode extends StatelessWidget {
  const _DisplayMode();

  @override
  Widget build(BuildContext context) {
    final widget = context.findAncestorWidgetOfExactType<AyahWidget>()!;
    final ayah = widget.ayah;
    final translation = widget.translation;
    final settings = widget.settings;

    if (settings.displayMode == 'text_and_translation' && translation != null) {
      return RichText(
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: '${ayah.text} ${formatQuranicVerseNumber(ayah.aya)}\n',
              style: TextStyle(
                fontSize: settings.fontSize,
                fontWeight: FontWeight.bold,
                color: settings.textColor,
                fontFamily: settings.font,
                height: settings.lineSpacing,
              ),
            ),
            TextSpan(
              text: translation.text,
              style: TextStyle(
                fontSize: settings.translateFontSize,
                fontFamily: settings.translationFont,
                color: settings.translationColor,
                height: settings.lineSpacing,
              ),
            ),
          ],
        ),
      );
    } else if (settings.displayMode == 'text_only') {
      return RichText(
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          text: '${ayah.text} ${formatQuranicVerseNumber(ayah.aya)}\n',
          style: TextStyle(
            fontSize: settings.fontSize,
            fontWeight: FontWeight.bold,
            color: settings.textColor,
            fontFamily: settings.font,
            height: settings.lineSpacing,
          ),
        ),
      );
    } else {
      return translation != null
          ? Text(
              translation.text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: settings.translateFontSize,
                fontFamily: settings.translationFont,
                color: settings.translationColor,
                height: settings.lineSpacing,
              ),
              textDirection: TextDirection.rtl,
            )
          : const SizedBox.shrink();
    }
  }
}
