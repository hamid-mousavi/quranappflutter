import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:page_flip/page_flip.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// Models (بدون تغییر)
class QuranJoz {
  final int id;
  final String joz;
  final int pageNoSt;

  QuranJoz({required this.id, required this.joz, required this.pageNoSt});

  factory QuranJoz.fromJson(Map<String, dynamic> json) {
    return QuranJoz(
      id: json['id'],
      joz: json['joz'],
      pageNoSt: json['pageNoSt'],
    );
  }
}

class LatestPage {
  final int id;
  final String pageNo;

  LatestPage({required this.id, required this.pageNo});

  factory LatestPage.fromJson(Map<String, dynamic> json) {
    return LatestPage(
      id: json['id'],
      pageNo: json['pageNo'],
    );
  }
}

class QuranText {
  final int index;
  final int joz;
  final int pageNo;
  final int sura;
  final int aya;
  final String text;
  final String textClean;

  QuranText({
    required this.index,
    required this.joz,
    required this.pageNo,
    required this.sura,
    required this.aya,
    required this.text,
    required this.textClean,
  });

  factory QuranText.fromJson(Map<String, dynamic> json) {
    return QuranText(
      index: json['index'],
      joz: json['joz'],
      pageNo: json['pageNo'],
      sura: json['sura'],
      aya: json['aya'],
      text: json['text'],
      textClean: json['text_clean'],
    );
  }
}

class QuranName {
  final int id;
  final String sura;
  final int page;

  QuranName({required this.id, required this.sura, required this.page});

  factory QuranName.fromJson(Map<String, dynamic> json) {
    return QuranName(
      id: json['id'] ?? 0,
      sura: json['sura'] ?? 'نامشخص',
      page: json['page'] ?? 0,
    );
  }
}

class QuranTranslation {
  final int index;
  final int sura;
  final int aya;
  final String text;

  QuranTranslation({
    required this.index,
    required this.sura,
    required this.aya,
    required this.text,
  });

  factory QuranTranslation.fromJson(Map<String, dynamic> json) {
    return QuranTranslation(
      index: json['index'],
      sura: json['sura'],
      aya: json['aya'],
      text: json['text'],
    );
  }
}

// Services
class QuranService {
  Future<List<QuranJoz>> loadQuranJoz(BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/quranJOZ.json');

      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => QuranJoz.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LatestPage>> loadLatestPage(BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/latest_page.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => LatestPage.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuranText>> loadQuranText(BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/quran_text.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => QuranText.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuranName>> loadQuranNames(BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/quranNameList.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => QuranName.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuranTranslation>> loadQuranTranslations(
      BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/json/fa_makarem.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => QuranTranslation.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

// ViewModel
class QuranViewModel extends ChangeNotifier {
  final QuranService _service = QuranService();
  List<QuranJoz> quranJozList = [];
  List<LatestPage> latestPageList = [];
  List<QuranText> quranTextList = [];
  List<QuranName> quranNameList = [];
  List<QuranTranslation> quranTranslationList = [];
  String? errorMessage;

  Future<void> loadData(BuildContext context) async {
    try {
      quranJozList = await _service.loadQuranJoz(context);
      latestPageList = await _service.loadLatestPage(context);
      quranTextList = await _service.loadQuranText(context);
      quranNameList = await _service.loadQuranNames(context);
      quranTranslationList = await _service.loadQuranTranslations(context);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'خطا در بارگذاری داده‌ها: $e';
    }
    notifyListeners();
  }

  List<QuranText> getAyahsBySura(int sura) {
    return quranTextList.where((ayah) => ayah.sura == sura).toList();
  }

  List<QuranTranslation> getTranslationsBySura(int sura) {
    return quranTranslationList.where((trans) => trans.sura == sura).toList();
  }
}

// Widgets
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

// Pages
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

class SuraPage extends StatefulWidget {
  final int suraId;

  const SuraPage({required this.suraId, Key? key}) : super(key: key);

  @override
  _SuraPageState createState() => _SuraPageState();
}

class _SuraPageState extends State<SuraPage> {
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener =
      ItemPositionsListener.create();
  final GlobalKey<PageFlipBuilderState> _pageFlipKey =
      GlobalKey<PageFlipBuilderState>(); // تغییر به PageFlipBuilderState
  int _currentSura = 0;
  int _currentPage = 0;
  int _currentJoz = 0;

  @override
  void initState() {
    super.initState();
    _currentSura = widget.suraId;
  }

  // @override
  // void dispose() {
  //   _positionsListener.itemPositions.removeListener(_updateCurrentInfo);
  //   super.dispose();
  // }

  void _updateCurrentInfo(int suraId, ItemPositionsListener positionsListener) {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    final positions = positionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final firstVisibleIndex = positions
          .where((pos) => pos.itemLeadingEdge >= 0)
          .reduce((min, pos) =>
              pos.itemLeadingEdge < min.itemLeadingEdge ? pos : min)
          .index;
      final ayah = viewModel.getAyahsBySura(suraId)[firstVisibleIndex];
      setState(() {
        _currentPage = ayah.pageNo;
        _currentJoz = ayah.joz;
      });
    }
  }

  // نمایش دیالوگ برای انتخاب سوره
  void _showSuraPicker(BuildContext context) {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتخاب سوره', textDirection: TextDirection.rtl),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.quranNameList.length,
            itemBuilder: (context, index) {
              final sura = viewModel.quranNameList[index];
              return ListTile(
                title: Text(sura.sura, textDirection: TextDirection.rtl),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SuraPage(suraId: sura.id)),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // نمایش دیالوگ برای انتخاب صفحه
  void _showPagePicker(BuildContext context) {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    final pages = viewModel.quranTextList
        .map((ayah) => ayah.pageNo)
        .toSet()
        .toList()
      ..sort();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتخاب صفحه', textDirection: TextDirection.rtl),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final page = pages[index];
              return ListTile(
                title: Text('صفحه $page', textDirection: TextDirection.rtl),
                onTap: () {
                  Navigator.pop(context);
                  final firstAyah = viewModel.quranTextList
                      .firstWhere((ayah) => ayah.pageNo == page);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SuraPage(suraId: firstAyah.sura)),
                  );
                  // اسکرول به آیه اول صفحه
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final ayahIndex = viewModel
                        .getAyahsBySura(firstAyah.sura)
                        .indexWhere((ayah) => ayah.pageNo == page);
                    _scrollController.scrollTo(
                      index: ayahIndex,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // نمایش دیالوگ برای انتخاب جزء
  void _showJozPicker(BuildContext context) {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتخاب جزء', textDirection: TextDirection.rtl),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.quranJozList.length,
            itemBuilder: (context, index) {
              final joz = viewModel.quranJozList[index];
              return ListTile(
                title: Text(joz.joz, textDirection: TextDirection.rtl),
                onTap: () {
                  Navigator.pop(context);
                  final firstAyahInJoz = viewModel.quranTextList
                      .firstWhere((ayah) => ayah.joz == joz.id);
                  // هدایت به سوره‌ای که جزء در آن شروع می‌شود
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SuraPage(suraId: firstAyahInJoz.sura)),
                  );
                  // اسکرول به اولین آیه جزء
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final ayahsInSura =
                        viewModel.getAyahsBySura(firstAyahInJoz.sura);
                    final ayahIndex = ayahsInSura.indexWhere((ayah) =>
                        ayah.joz == joz.id &&
                        ayah.index == firstAyahInJoz.index);
                    if (ayahIndex != -1) {
                      _scrollController.scrollTo(
                        index: ayahIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranViewModel>(context);
    final suraName = viewModel.quranNameList
        .firstWhere((sura) => sura.id == widget.suraId)
        .sura;
    final suraIndex =
        viewModel.quranNameList.indexWhere((sura) => sura.id == widget.suraId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _showSuraPicker(context),
              child:
                  Text('سوره: $suraName', style: const TextStyle(fontSize: 14)),
            ),
            GestureDetector(
              onTap: () => _showPagePicker(context),
              child: Text('صفحه: $_currentPage',
                  style: const TextStyle(fontSize: 14)),
            ),
            GestureDetector(
              onTap: () => _showJozPicker(context),
              child: Text('جزء: $_currentJoz',
                  style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: suraIndex),
        itemCount: viewModel.quranNameList.length,
        onPageChanged: (index) {
          setState(() {
            _currentSura = viewModel.quranNameList[index].id;
          });
        },
        itemBuilder: (context, index) {
          final sura = viewModel.quranNameList[index];
          final ayahs = viewModel.getAyahsBySura(sura.id);
          final translations = viewModel.getTranslationsBySura(sura.id);
          // کنترلرهای مستقل برای هر سوره
          final scrollController = ItemScrollController();
          final positionsListener = ItemPositionsListener.create();
          positionsListener.itemPositions.addListener(
              () => _updateCurrentInfo(sura.id, positionsListener));

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // پرسپکتیو برای افکت ورق زدن
              ..rotateY(0.0),
            alignment: Alignment.center,
            child: Container(
              color: Colors.white,
              child: ScrollablePositionedList.builder(
                itemScrollController: scrollController,
                itemPositionsListener: positionsListener,
                itemCount: ayahs.length,
                itemBuilder: (context, index) {
                  final ayah = ayahs[index];
                  final translation = translations.firstWhere(
                    (trans) => trans.aya == ayah.aya,
                    orElse: () =>
                        QuranTranslation(index: 0, sura: 0, aya: 0, text: ''),
                  );
                  return GestureDetector(
                    onTap: () {
                      scrollController.scrollTo(
                        index: index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    },
                    child: AyahWidget(
                      ayah: ayah,
                      translation:
                          translation.text.isNotEmpty ? translation : null,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class LatestPageScreen extends StatelessWidget {
  const LatestPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranViewModel>(context);
    if (viewModel.latestPageList.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final latestPage = viewModel.latestPageList.first;
    final ayahs = viewModel.quranTextList
        .where((ayah) => ayah.pageNo == int.parse(latestPage.pageNo))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('آخرین صفحه')),
      body: ListView.builder(
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          final ayah = ayahs[index];
          final translation = viewModel.quranTranslationList.firstWhere(
            (trans) => trans.sura == ayah.sura && trans.aya == ayah.aya,
            orElse: () => QuranTranslation(index: 0, sura: 0, aya: 0, text: ''),
          );
          return AyahWidget(
            ayah: ayah,
            translation: translation.text.isNotEmpty ? translation : null,
          );
        },
      ),
    );
  }
}

// Main App
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = QuranViewModel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.loadData(context);
        });
        return viewModel;
      },
      child: MaterialApp(
        title: 'Quran App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Amiri',
        ),
        home: const HomePage(),
      ),
    );
  }
}
