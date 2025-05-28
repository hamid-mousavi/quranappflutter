import 'package:flutter/material.dart';
import 'package:quran/models/quran_name.dart';

class SuraCard extends StatelessWidget {
  final QuranName sura;
  final VoidCallback onTap;

  const SuraCard({required this.sura, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          sura.sura,
          style: const TextStyle(fontSize: 18, fontFamily: 'Amiri'),
          textDirection: TextDirection.rtl,
        ),
        subtitle: Text('صفحه: ${sura.page}'),
        onTap: onTap,
      ),
    );
  }
}
