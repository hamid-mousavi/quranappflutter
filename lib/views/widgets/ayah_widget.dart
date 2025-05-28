import 'package:flutter/material.dart';
import 'package:quran/models/quran_text.dart';
import 'package:quran/models/quran_translation.dart';

class AyahWidget extends StatelessWidget {
  final QuranText ayah;
  final QuranTranslation? translation;

  const AyahWidget({required this.ayah, this.translation, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${ayah.text} (${ayah.aya})',
            style: const TextStyle(fontSize: 22, fontFamily: 'Amiri'),
            textDirection: TextDirection.rtl,
          ),
          if (translation != null)
            Text(
              translation!.text,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textDirection: TextDirection.rtl,
            ),
          const Divider(),
        ],
      ),
    );
  }
}
