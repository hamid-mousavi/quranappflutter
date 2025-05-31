import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  }

  void _onSearchChanged() {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    viewModel.filterSuras(_searchController.text);
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
            'فهرست سوره‌ها',
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
                Navigator.pushNamed(
                    context, '/settings'); // رفتن به صفحه تنظیمات
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
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style:
                        const TextStyle(fontFamily: 'vazirmatn', fontSize: 14),
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'جستجوی سوره...',
                      hintStyle: const TextStyle(
                          fontFamily: 'vazirmatn', fontSize: 14),
                      filled: true,
                      fillColor: Colors.grey.shade200, // پس‌زمینه طوسی
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0), // کاهش ارتفاع
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // گوشه‌های گرد
                        borderSide: BorderSide.none, // بدون خطوط بوردر
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
                        mainAxisAlignment:
                            MainAxisAlignment.start, // اطمینان از چپ‌چین بودن
                        children: [
                          Icon(Icons.search,
                              size: 20, color: Colors.grey), // آیکن جستجو
                          SizedBox(width: 8), // فاصله بین آیکن‌ها
                          Icon(Icons.mic, size: 20, color: Colors.grey),
                          SizedBox(
                            width: 5,
                          ) // آیکن ضبط صدا
                        ],
                      ),
                    ),
                  ),
                ),
                // تب‌ها
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
                            } else if (index == 1) {
                              viewModel.filterByJuz();
                            } else {
                              viewModel.resetFilter();
                            }
                          },
                          tabs: const [
                            Tab(text: 'سوره'),
                            Tab(text: 'جزء'),
                            Tab(text: 'علاقه‌مندی‌ها'),
                          ],
                        ),
                        Expanded(
                          child: Consumer<QuranViewModel>(
                            builder: (context, viewModel, child) {
                              if (viewModel.errorMessage != null) {
                                return Center(
                                  child: Text(
                                    viewModel.errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              if (viewModel.quranNameList.isEmpty) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                itemCount: viewModel.quranNameList.length,
                                itemBuilder: (context, index) {
                                  final sura = viewModel.quranNameList[index];
                                  return SuraCard(
                                    sura: sura,
                                    isFavorite: viewModel.isFavorite(sura.id),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SuraPage(suraId: sura.id),
                                        ),
                                      );
                                    },
                                    onFavoriteTap: () {
                                      viewModel.toggleFavorite(sura.id);
                                    },
                                  );
                                },
                              );
                            },
                          ),
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
}
