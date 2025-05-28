import 'package:flutter/material.dart';
import '../../models/quran_ayah.dart';

class AyahCard extends StatelessWidget {
  final QuranAyah ayah;

  const AyahCard({super.key, required this.ayah});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ayah.text,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Text(
              ayah.translation,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Colors.teal, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'آیه ${ayah.aya} - صفحه ${ayah.pageNo}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
