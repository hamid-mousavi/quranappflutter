import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/models/quran_text.dart';
import 'package:quran/viewmodels/quran_view_model.dart';
import 'package:quran/views/latest_page_screen.dart';
import 'package:quran/views/sura_page.dart';
import 'package:quran/views/widgets/sura_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    viewModel.loadData(context);
  }

  void _onSearchChanged() {
    if (_selectedTabIndex == 0) {
      final viewModel = Provider.of<QuranViewModel>(context, listen: false);
      viewModel.filterSuras(_searchController.text);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'فهرست قرآن',
            style: TextStyle(fontFamily: 'vazirmatn', fontSize: 16),
          ),
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
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
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
            if (viewModel.quranNameList.isEmpty ||
                viewModel.quranJozList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                if (_selectedTabIndex == 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(
                          fontFamily: 'vazirmatn', fontSize: 14),
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'جستجوی نام سوره یا متن آیه...',
                        hintStyle: const TextStyle(
                            fontFamily: 'vazirmatn', fontSize: 14),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.search, size: 20, color: Colors.grey),
                            SizedBox(width: 8),
                            Icon(Icons.mic, size: 20, color: Colors.grey),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          onTap: (index) {
                            setState(() {
                              _selectedTabIndex = index;
                            });
                            final viewModel = Provider.of<QuranViewModel>(
                                context,
                                listen: false);
                            if (index == 2) {
                              viewModel.filterFavorites();
                            } else if (index == 0) {
                              viewModel.filterSuras(_searchController.text);
                            }
                          },
                          tabs: const [
                            Tab(text: 'سوره'),
                            Tab(text: 'جزء'),
                            Tab(text: 'علاقه‌مندی‌ها'),
                          ],
                        ),
                        Expanded(
                          child: _buildTabContent(context, viewModel),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, QuranViewModel viewModel) {
    if (_selectedTabIndex == 1) {
      if (viewModel.quranJozList.isEmpty) {
        return const Center(child: Text('جزء‌ها در دسترس نیست'));
      }
      return ListView.builder(
        itemCount: viewModel.quranJozList.length,
        itemBuilder: (context, index) {
          final juz = viewModel.quranJozList[index];
          return ListTile(
            title: Text(juz.joz, textDirection: TextDirection.rtl),
            onTap: () {
              final firstAyah = viewModel.getFirstAyahOfJoz(juz.id);
              if (firstAyah != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuraPage(
                      suraId: firstAyah.sura,
                      initialJuz: juz.id,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('آیه‌ای برای این جزء یافت نشد')),
                );
              }
            },
          );
        },
      );
    } else if (_selectedTabIndex == 2) {
      if (viewModel.filteredSuraList.isEmpty) {
        return const Center(child: Text('هیچ سوره‌ای در علاقه‌مندی‌ها نیست'));
      }
      return ListView.builder(
        itemCount: viewModel.filteredSuraList.length,
        itemBuilder: (context, index) {
          final sura = viewModel.filteredSuraList[index];
          return SuraCard(
            sura: sura,
            isFavorite: viewModel.isFavorite(sura.id),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SuraPage(suraId: sura.id),
                ),
              );
            },
            onFavoriteTap: () {
              viewModel.toggleFavorite(sura.id);
            },
          );
        },
      );
    } else {
      if (viewModel.filteredSuraList.isEmpty &&
          _searchController.text.isNotEmpty) {
        return const Center(child: Text('نتیجه‌ای یافت نشد'));
      }
      return ListView.builder(
        itemCount: viewModel.filteredSuraList.length,
        itemBuilder: (context, index) {
          final sura = viewModel.filteredSuraList[index];
          final ayahs = viewModel.matchingAyahs[sura.id] ?? [];

          // اگر چیزی جستجو نشده، مستقیماً SuraCard نشان داده شود
          if (_searchController.text.isEmpty) {
            return SuraCard(
              sura: sura,
              isFavorite: viewModel.isFavorite(sura.id),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuraPage(suraId: sura.id),
                  ),
                );
              },
              onFavoriteTap: () {
                viewModel.toggleFavorite(sura.id);
              },
            );
          }

          // اگر جستجو انجام شده، از ExpansionTile استفاده شود
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ExpansionTile(
              title: ListTile(
                title: Text(sura.sura, textDirection: TextDirection.rtl),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuraPage(suraId: sura.id),
                    ),
                  );
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (ayahs.isNotEmpty)
                    Text(
                      '(${ayahs.length})',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  IconButton(
                    icon: Icon(
                      viewModel.isFavorite(sura.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: viewModel.isFavorite(sura.id) ? Colors.red : null,
                    ),
                    onPressed: () {
                      viewModel.toggleFavorite(sura.id);
                    },
                  ),
                ],
              ),
              children: ayahs
                  .map((ayah) => Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          title: _buildAyahText(
                              ayah, _searchController.text, viewModel),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SuraPage(
                                  suraId: sura.id,
                                  initialAyah: ayah.aya,
                                ),
                              ),
                            );
                          },
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      );
    }
  }

  // ویجت برای نمایش متن آیه با هایلایت عبارت جستجو
  Widget _buildAyahText(
      QuranText ayah, String query, QuranViewModel viewModel) {
    if (query.isEmpty) {
      return Text(
        'آیه ${ayah.aya}: ${ayah.text.length > 50 ? ayah.text.substring(0, 50) + '...' : ayah.text}',
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontFamily: 'vazirmatn', fontSize: 14),
      );
    }

    final normalizedQuery = viewModel.normalizeArabic(query).toLowerCase();
    final normalizedText = viewModel.normalizeArabic(ayah.text).toLowerCase();
    final displayText =
        ayah.text.length > 50 ? ayah.text.substring(0, 50) + '...' : ayah.text;

    if (normalizedText.contains(normalizedQuery)) {
      // پیدا کردن موقعیت عبارت در متن نرمال‌شده
      final startIndex = normalizedText.indexOf(normalizedQuery);
      final queryLength = normalizedQuery.length;

      // محاسبه موقعیت تقریبی در متن اصلی (با اعراب)
      int originalStart = 0;
      int normalizedIndex = 0;
      for (int i = 0;
          i < ayah.text.length && normalizedIndex < startIndex;
          i++) {
        if (!RegExp(
                r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]')
            .hasMatch(ayah.text[i])) {
          normalizedIndex++;
        }
        originalStart = i;
      }
      int originalEnd = originalStart;
      normalizedIndex = 0;
      for (int i = originalStart;
          i < ayah.text.length && normalizedIndex < queryLength;
          i++) {
        if (!RegExp(
                r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]')
            .hasMatch(ayah.text[i])) {
          normalizedIndex++;
        }
        originalEnd = i + 1;
      }

      // کوتاه کردن متن برای نمایش
      String before = '';
      String match = displayText;
      String after = '';
      if (originalEnd <= displayText.length) {
        before = displayText.substring(0, originalStart);
        match = displayText.substring(originalStart, originalEnd);
        after = displayText.substring(originalEnd);
      }

      return RichText(
        text: TextSpan(
          text: 'آیه ${ayah.aya}: ',
          style: const TextStyle(
              fontFamily: 'vazirmatn', fontSize: 14, color: Colors.black),
          children: [
            TextSpan(text: before),
            TextSpan(
              text: match,
              style: const TextStyle(backgroundColor: Colors.yellow),
            ),
            TextSpan(text: after),
          ],
        ),
        textDirection: TextDirection.rtl,
      );
    }

    return Text(
      'آیه ${ayah.aya}: $displayText',
      textDirection: TextDirection.rtl,
      style: const TextStyle(fontFamily: 'vazirmatn', fontSize: 14),
    );
  }
}
