import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran/function/convert_to_arabic.dart';
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
  final Map<int, ItemScrollController> _scrollControllers = {};
  final Map<int, ItemPositionsListener> _positionsListeners = {};
  bool _isAutoScrolling = false;
  Timer? _scrollTimer;
  bool _isFullScreen = false;
  double _scrollSpeed = 1.0; // ضریب سرعت (1x, 2x, 3x, 4x, 5x)

  @override
  void initState() {
    super.initState();
    _currentSura = widget.suraId;
    _pageController = PageController(initialPage: widget.suraId - 1);
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    for (var sura in viewModel.quranNameList) {
      _scrollControllers[sura.id] = ItemScrollController();
      _positionsListeners[sura.id] = ItemPositionsListener.create();
    }
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

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

  void _toggleAutoScroll() {
    setState(() {
      _isAutoScrolling = !_isAutoScrolling;
    });

    if (_isAutoScrolling) {
      final viewModel = Provider.of<QuranViewModel>(context, listen: false);
      final ayahs = viewModel.getAyahsBySura(_currentSura);
      int currentIndex = 0;

      final positions = _positionsListeners[_currentSura]!.itemPositions.value;
      if (positions.isNotEmpty) {
        currentIndex = positions
            .where((pos) => pos.itemLeadingEdge >= 0)
            .reduce((min, pos) =>
                pos.itemLeadingEdge < min.itemLeadingEdge ? pos : min)
            .index;
      }

      _scrollTimer?.cancel();
      _startAutoScroll(currentIndex, ayahs);
    } else {
      _scrollTimer?.cancel();
    }
  }

  void _startAutoScroll(int currentIndex, List<dynamic> ayahs) {
    _scrollTimer = Timer.periodic(
      Duration(
          milliseconds: (10000 / _scrollSpeed).round()), // سرعت بر اساس ضریب
      (timer) {
        if (!_isAutoScrolling || currentIndex >= ayahs.length - 1) {
          timer.cancel();
          setState(() {
            _isAutoScrolling = false;
          });
          return;
        }
        currentIndex++;
        _scrollControllers[_currentSura]!.scrollTo(
          index: currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  void _setScrollSpeed(double speed) {
    if (_scrollSpeed != speed && _isAutoScrolling) {
      setState(() {
        _scrollSpeed = speed;
      });
      _scrollTimer?.cancel();
      final viewModel = Provider.of<QuranViewModel>(context, listen: false);
      final ayahs = viewModel.getAyahsBySura(_currentSura);
      int currentIndex = 0;
      final positions = _positionsListeners[_currentSura]!.itemPositions.value;
      if (positions.isNotEmpty) {
        currentIndex = positions
            .where((pos) => pos.itemLeadingEdge >= 0)
            .reduce((min, pos) =>
                pos.itemLeadingEdge < min.itemLeadingEdge ? pos : min)
            .index;
      }
      _startAutoScroll(currentIndex, ayahs);
    } else {
      setState(() {
        _scrollSpeed = speed;
      });
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final page = pages[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  final firstAyah = viewModel.quranTextList
                      .firstWhere((ayah) => ayah.pageNo == page);
                  setState(() {
                    _currentSura = firstAyah.sura;
                    _currentPage = page;
                  });
                  final suraIndex = viewModel.quranNameList
                      .indexWhere((sura) => sura.id == firstAyah.sura);
                  _pageController.animateToPage(
                    suraIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final ayahIndex = viewModel
                        .getAyahsBySura(firstAyah.sura)
                        .indexWhere((ayah) => ayah.pageNo == page);
                    if (ayahIndex != -1 &&
                        _scrollControllers[firstAyah.sura] != null) {
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
                  final firstAyah = viewModel.quranTextList
                      .firstWhere((ayah) => ayah.joz == joz.id);
                  setState(() {
                    _currentSura = firstAyah.sura;
                    _currentJoz = joz.id;
                  });
                  final suraIndex = viewModel.quranNameList
                      .indexWhere((s) => s.id == firstAyah.sura);
                  _pageController.animateToPage(
                    suraIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final ayahsInSura =
                        viewModel.getAyahsBySura(firstAyah.sura);
                    final ayahIndex = ayahsInSura.indexWhere((ayah) =>
                        ayah.joz == joz.id && ayah.index == firstAyah.index);
                    if (ayahIndex != -1 &&
                        _scrollControllers[firstAyah.sura] != null) {
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
    final suraName = viewModel.quranNameList
        .firstWhere((sura) => sura.id == _currentSura)
        .sura;

    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF1E5E3A),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // عملکرد جستجو
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isAutoScrolling
                        ? Icons.pause
                        : Icons.keyboard_double_arrow_down,
                  ),
                  onPressed: _toggleAutoScroll,
                ),
                IconButton(
                  icon: Icon(
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  ),
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: viewModel.quranNameList.length,
            onPageChanged: (index) {
              setState(() {
                _currentSura = viewModel.quranNameList[index].id;
                _isAutoScrolling = false;
                _scrollTimer?.cancel();
              });
            },
            itemBuilder: (context, index) {
              final sura = viewModel.quranNameList[index];
              final ayahs = viewModel.getAyahsBySura(sura.id);
              final translations = viewModel.getTranslationsBySura(sura.id);

              final scrollController = _scrollControllers[sura.id]!;
              final positionsListener = _positionsListeners[sura.id]!;
              positionsListener.itemPositions.addListener(
                  () => _updateCurrentInfo(sura.id, positionsListener));

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(0.0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    if (!_isFullScreen)
                      Container(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        color: const Color(0xFF1E5E3A),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => _showSuraPicker(context),
                              child: Text('سوره  $suraName',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'vazirmatn')),
                            ),
                            GestureDetector(
                              onTap: () => _showPagePicker(context),
                              child: Text(
                                  'صفحه  ${convertToArabicNumber(_currentPage)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'vazirmatn')),
                            ),
                            GestureDetector(
                              onTap: () => _showJozPicker(context),
                              child: Text(
                                  'جزء  ${convertToArabicNumber(_currentJoz)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'vazirmatn')),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ScrollablePositionedList.builder(
                        itemScrollController: scrollController,
                        itemPositionsListener: positionsListener,
                        itemCount: ayahs.length,
                        itemBuilder: (context, index) {
                          final ayah = ayahs[index];
                          final translation = translations.firstWhere(
                            (trans) => trans.aya == ayah.aya,
                            orElse: () => QuranTranslation(
                                index: 0, sura: 0, aya: 0, text: ''),
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
                              translation: translation.text.isNotEmpty
                                  ? translation
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_isAutoScrolling)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSpeedButton(1.0),
                    const SizedBox(width: 8),
                    _buildSpeedButton(2.0),
                    const SizedBox(width: 8),
                    _buildSpeedButton(3.0),
                    const SizedBox(width: 8),
                    _buildSpeedButton(4.0),
                    const SizedBox(width: 8),
                    _buildSpeedButton(5.0),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpeedButton(double speed) {
    return GestureDetector(
      onTap: () => _setScrollSpeed(speed),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: _scrollSpeed == speed
              ? const Color(0xFF1E5E3A)
              : Colors.grey.shade600,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          '${speed}x',
          style: TextStyle(
            color: _scrollSpeed == speed ? Colors.white : Colors.white70,
            fontSize: 14,
            fontFamily: 'vazirmatn',
          ),
        ),
      ),
    );
  }
}
