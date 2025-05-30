import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/models/quran_translation.dart';
import 'package:quran/viewmodels/quran_view_model.dart';
import 'package:quran/viewmodels/settings_view_model.dart';
import 'package:quran/views/widgets/ayah_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SuraPage extends StatefulWidget {
  final int suraId;

  const SuraPage({required this.suraId, Key? key}) : super(key: key);

  @override
  _SuraPageState createState() => _SuraPageState();
}

class _SuraPageState extends State<SuraPage> {
  int _currentSura = 0;
  int _currentPage = 0;
  int _currentJoz = 0;
  late final PageController _pageController;
  final Map<int, ItemScrollController> _scrollControllers = {}; // ذخیره کنترلر برای هر سوره
  final Map<int, ItemPositionsListener> _positionsListeners = {}; // ذخیره listener برای هر سوره

  @override
  void initState() {
    super.initState();
    _currentSura = widget.suraId;
    _pageController = PageController(initialPage: widget.suraId - 1);
    // ایجاد کنترلر و listener برای هر سوره
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    for (var sura in viewModel.quranNameList) {
      _scrollControllers[sura.id] = ItemScrollController();
      _positionsListeners[sura.id] = ItemPositionsListener.create();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateCurrentInfo(int suraId, ItemPositionsListener positionsListener) {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    final positions = positionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final firstVisibleIndex = positions
          .where((pos) => pos.itemLeadingEdge >= 0)
          .reduce((min, pos) => pos.itemLeadingEdge < min.itemLeadingEdge ? pos : min)
          .index;
      final ayah = viewModel.getAyahsBySura(suraId)[firstVisibleIndex];
      setState(() {
        _currentPage = ayah.pageNo;
        _currentJoz = ayah.joz;
      });
    }
  }

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
                  setState(() {
                    _currentSura = sura.id;
                  });
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPagePicker(BuildContext context) {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    final pages = viewModel.quranTextList.map((ayah) => ayah.pageNo).toSet().toList()..sort();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتخاب صفحه', textDirection: TextDirection.rtl),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final page = pages[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  final firstAyah = viewModel.quranTextList.firstWhere((ayah) => ayah.pageNo == page);
                 print(firstAyah.aya);
                  setState(() {
                    _currentSura = firstAyah.sura;
                    _currentPage = page;
                  });
                  final suraIndex = viewModel.quranNameList.indexWhere((sura) => sura.id == firstAyah.sura);
                  _pageController.animateToPage(
                    suraIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final ayahIndex = viewModel.getAyahsBySura(firstAyah.sura).indexWhere((ayah) => ayah.pageNo == page);
                    if (ayahIndex != -1 && _scrollControllers[firstAyah.sura] != null) {
                      _scrollControllers[firstAyah.sura]!.scrollTo(
                        index: ayahIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  });
                },
                child: Text('صفحه $page', textDirection: TextDirection.rtl),
              );
            },
          ),
        ),
      ),
    );
  }

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
                  final firstAyah = viewModel.quranTextList.firstWhere((ayah) => ayah.joz == joz.id);
                  setState(() {
                    _currentSura = firstAyah.sura;
                    _currentJoz = joz.id;
                  });
                  final suraIndex = viewModel.quranNameList.indexWhere((s) => s.id == firstAyah.sura);
                  _pageController.animateToPage(
                    suraIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final ayahsInSura = viewModel.getAyahsBySura(firstAyah.sura);
                    final ayahIndex = ayahsInSura.indexWhere((ayah) => ayah.joz == joz.id && ayah.index == firstAyah.index);
                    if (ayahIndex != -1 && _scrollControllers[firstAyah.sura] != null) {
                      _scrollControllers[firstAyah.sura]!.scrollTo(
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
    final setting = Provider.of<SettingsViewModel>(context);
    final suraName = viewModel.quranNameList.firstWhere((sura) => sura.id == _currentSura).sura;

    return Scaffold(
      // backgroundColor: setting.backgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _showSuraPicker(context),
              child: Text('سوره: $suraName', style: const TextStyle(fontSize: 14)),
            ),
            GestureDetector(
              onTap: () => _showPagePicker(context),
              child: Text('صفحه: $_currentPage', style: const TextStyle(fontSize: 14)),
            ),
            GestureDetector(
              onTap: () => _showJozPicker(context),
              child: Text('جزء: $_currentJoz', style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
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

          // استفاده از کنترلر و listener مربوط به سوره
          final scrollController = _scrollControllers[sura.id]!;
          final positionsListener = _positionsListeners[sura.id]!;
          positionsListener.itemPositions.addListener(() => _updateCurrentInfo(sura.id, positionsListener));

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(0.0),
            alignment: Alignment.center,
            child: Container(
              // color: setting.backgroundColor,
              child: ScrollablePositionedList.builder(
                itemScrollController: scrollController,
                itemPositionsListener: positionsListener,
                itemCount: ayahs.length,
                itemBuilder: (context, index) {
                  final ayah = ayahs[index];
                  final translation = translations.firstWhere(
                    (trans) => trans.aya == ayah.aya,
                    orElse: () => QuranTranslation(index: 0, sura: 0, aya: 0, text: ''),
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
                      translation: translation.text.isNotEmpty ? translation : null,
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