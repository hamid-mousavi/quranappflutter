import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/viewmodels/quran_view_model.dart';
import 'package:quran/views/latest_page_screen.dart';
import 'package:quran/views/sura_page.dart';
import 'package:quran/views/widgets/sura_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فهرست سوره‌ها'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LatestPageScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<QuranViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.errorMessage != null) {
            return Center(
                child: Text(viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red)));
          }
          if (viewModel.quranNameList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: viewModel.quranNameList.length,
            itemBuilder: (context, index) {
              final sura = viewModel.quranNameList[index];
              return SuraCard(
                sura: sura,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuraPage(suraId: sura.id),
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
