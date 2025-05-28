import 'package:flutter/material.dart';
import 'package:quran/service/sura_service.dart';
import '../models/sura_model.dart';
import 'sura_detail_screen.dart';

class SuraListScreen extends StatelessWidget {
  const SuraListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فهرست سوره‌ها')),
      body: FutureBuilder<List<Sura>>(
        future: SuraService().getAllSuras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('❌ خطا: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('⚠️ داده‌ای یافت نشد'));
          }

          final suras = snapshot.data!;
          return ListView.builder(
            itemCount: suras.length,
            itemBuilder: (context, index) {
              final sura = suras[index];
              return ListTile(
                title: Text(
                  '${sura.id}. ${sura.name}',
                  textDirection: TextDirection.rtl,
                ),
                subtitle: Text('صفحه ${sura.startPage}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SuraDetailScreen(suraId: sura.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
