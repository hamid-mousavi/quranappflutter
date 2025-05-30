import 'package:flutter/material.dart';
import 'package:quran/models/quran_name.dart';

class SuraCard extends StatelessWidget {
  final QuranName sura;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const SuraCard({
    Key? key,
    required this.sura,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  }) : super(key: key);

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
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: onFavoriteTap,
        ),
        onTap: onTap,
      ),
    );
  }
}