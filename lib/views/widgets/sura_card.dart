import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/function/convert_to_arabic.dart';
import 'package:quran/models/quran_name.dart';
import 'package:quran/viewmodels/quran_view_model.dart';

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
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              convertToArabicNumber(sura.id),
              style: TextStyle(
                fontSize: 18,
                fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12, // اندازه تصویر دایره‌ای
              backgroundImage: AssetImage(
                sura.revelationType == "Meccan"
                    ? 'assets/images/mecca.png'
                    : 'assets/images/medina.png',
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        title: Text(
          sura.sura,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'amiri', // فونت فارسی
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        subtitle: Text(
          convertToArabicNumber(viewModel.getAyahCountBySura(sura.id)) + ' آیه',
          style: TextStyle(
            fontSize: 12,
            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
          ),
          textDirection: TextDirection.rtl,
        ),
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
