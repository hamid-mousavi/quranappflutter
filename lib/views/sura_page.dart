import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quran/function/convert_to_arabic.dart';
import 'package:quran/models/quran_text.dart';
import 'package:quran/models/quran_translation.dart';
import 'package:quran/viewmodels/quran_view_model.dart';
import 'package:quran/viewmodels/settings_view_model.dart';
import 'package:quran/views/widgets/ayah_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// نگاشت قاری‌ها به نام‌های فارسی و تصاویر
final Map<String, Map<String, String>> _reciterInfo = {
  'ar.ahmedajamy': {
    'name': 'احمد العجمي',
    'image': 'https://example.com/images/ahmedajamy.jpg'
  },
  'ar.alafasy': {
    'name': 'مشاري العفاسي',
    'image': 'https://example.com/images/alafasy.jpg'
  },
  'ar.alafasy-2': {
    'name': 'مشاري العفاسي (۲)',
    'image': 'https://example.com/images/alafasy.jpg'
  },
  'ar.hudhaify': {
    'name': 'علي الحذيفي',
    'image': 'https://example.com/images/hudhaify.jpg'
  },
  'ar.hudhaify-2': {
    'name': 'علي الحذيفي (۲)',
    'image': 'https://example.com/images/hudhaify.jpg'
  },
  'ar.husary': {
    'name': 'محمود خليل الحصري',
    'image': 'https://example.com/images/husary.jpg'
  },
  'ar.husary-2': {
    'name': 'محمود خليل الحصري (۲)',
    'image': 'https://example.com/images/husary.jpg'
  },
  'ar.husarymujawwad': {
    'name': 'الحصري (مجود)',
    'image': 'https://example.com/images/husary.jpg'
  },
  'ar.husarymujawwad-2': {
    'name': 'الحصري (مجود) (۲)',
    'image': 'https://example.com/images/husary.jpg'
  },
  'ar.mahermuaiqly': {
    'name': 'ماهر المعيقلي',
    'image': 'https://example.com/images/mahermuaiqly.jpg'
  },
  'ar.mahermuaiqly-2': {
    'name': 'ماهر المعيقلي (۲)',
    'image': 'https://example.com/images/mahermuaiqly.jpg'
  },
  'ar.minshawi': {
    'name': 'محمد صديق المنشاوي',
    'image': 'https://example.com/images/minshawi.jpg'
  },
  'ar.minshawi-2': {
    'name': 'محمد صديق المنشاوي (۲)',
    'image': 'https://example.com/images/minshawi.jpg'
  },
  'ar.muhammadayyoub': {
    'name': 'محمد أيوب',
    'image': 'https://example.com/images/muhammadayyoub.jpg'
  },
  'ar.muhammadayyoub-2': {
    'name': 'محمد أيوب (۲)',
    'image': 'https://example.com/images/muhammadayyoub.jpg'
  },
  'ar.muhammadjibreel': {
    'name': 'محمد جبريل',
    'image': 'https://example.com/images/muhammadjibreel.jpg'
  },
  'ar.muhammadjibreel-2': {
    'name': 'محمد جبريل (۲)',
    'image': 'https://example.com/images/muhammadjibreel.jpg'
  },
  'ar.shaatree': {
    'name': 'أبو بكر الشاطري',
    'image': 'https://example.com/images/shaatree.jpg'
  },
  'ar.shaatree-2': {
    'name': 'أبو بكر الشاطري (۲)',
    'image': 'https://example.com/images/shaatree.jpg'
  },
  'fr.leclerc': {
    'name': 'لكليرك (فرانسوی)',
    'image': 'https://example.com/images/leclerc.jpg'
  },
  'ru.kuliev-audio': {
    'name': 'کولیف (روسی)',
    'image': 'https://example.com/images/kuliev.jpg'
  },
  'zh.chinese': {
    'name': 'چینی',
    'image': 'https://example.com/images/chinese.jpg'
  },
  'ar.abdulbasitmurattal': {
    'name': 'عبدالباسط عبدالصمد',
    'image': 'https://example.com/images/abdulbasit.jpg'
  },
  'ar.abdulbasitmurattal-2': {
    'name': 'عبدالباسط عبدالصمد (۲)',
    'image': 'https://example.com/images/abdulbasit.jpg'
  },
  'ar.abdullahbasfar': {
    'name': 'عبدالله بصفر',
    'image': 'https://example.com/images/abdullahbasfar.jpg'
  },
  'ar.abdullahbasfar-2': {
    'name': 'عبدالله بصفر (۲)',
    'image': 'https://example.com/images/abdullahbasfar.jpg'
  },
  'ar.abdurrahmaansudais': {
    'name': 'عبدالرحمن السديس',
    'image': 'https://example.com/images/sudais.jpg'
  },
  'ar.abdurrahmaansudais-2': {
    'name': 'عبدالرحمن السديس (۲)',
    'image': 'https://example.com/images/sudais.jpg'
  },
  'ar.hanirifai': {
    'name': 'هاني الرفاعي',
    'image': 'https://example.com/images/hanirifai.jpg'
  },
  'ar.hanirifai-2': {
    'name': 'هاني الرفاعي (۲)',
    'image': 'https://example.com/images/hanirifai.jpg'
  },
  'en.walk': {
    'name': 'واک (انگلیسی)',
    'image': 'https://example.com/images/walk.jpg'
  },
  'ar.ibrahimakhbar': {
    'name': 'إبراهيم الأخضر',
    'image': 'https://example.com/images/ibrahimakhbar.jpg'
  },
  'ru.kuliev-audio-2': {
    'name': 'کولیف (روسی) (۲)',
    'image': 'https://example.com/images/kuliev.jpg'
  },
  'fa.hedayatfarfooladvand': {
    'name': 'هدایت‌فر فولادوند',
    'image': 'https://example.com/images/hedayatfar.jpg'
  },
  'ar.parhizgar': {
    'name': 'پرهیزگار',
    'image': 'https://example.com/images/parhizgar.jpg'
  },
  'ar.abdulsamad': {
    'name': 'عبدالصمد',
    'image': 'https://example.com/images/abdulsamad.jpg'
  },
  'ar.aymanswoaid': {
    'name': 'أيمن سويد',
    'image': 'https://example.com/images/aymanswoaid.jpg'
  },
  'ar.aymanswoaid-2': {
    'name': 'أيمن سويد (۲)',
    'image': 'https://example.com/images/aymanswoaid.jpg'
  },
  'ar.minshawimujawwad': {
    'name': 'المنشاوي (مجود)',
    'image': 'https://example.com/images/minshawi.jpg'
  },
  'ar.minshawimujawwad-2': {
    'name': 'المنشاوي (مجود) (۲)',
    'image': 'https://example.com/images/minshawi.jpg'
  },
  'ar.saoodshuraym': {
    'name': 'سعود الشريم',
    'image': 'https://example.com/images/saoodshuraym.jpg'
  },
  'ar.saoodshuraym-2': {
    'name': 'سعود الشريم (۲)',
    'image': 'https://example.com/images/saoodshuraym.jpg'
  },
  'ur.khan': {
    'name': 'خان (اردو)',
    'image': 'https://example.com/images/khan.jpg'
  },
};

// تعریف ساختار قاری‌ها و کیفیت‌های موجود
final Map<String, List<String>> _reciterBitrates = {
  'ar.ahmedajamy': ['128', '64'],
  'ar.alafasy': ['128', '64'],
  'ar.alafasy-2': ['128', '64'],
  'ar.hudhaify': ['128', '32', '64'],
  'ar.hudhaify-2': ['128', '32', '64'],
  'ar.husary': ['128', '64'],
  'ar.husary-2': ['128', '64'],
  'ar.husarymujawwad': ['128', '64'],
  'ar.husarymujawwad-2': ['128', '64'],
  'ar.mahermuaiqly': ['128', '64'],
  'ar.mahermuaiqly-2': ['128', '64'],
  'ar.minshawi': ['128'],
  'ar.minshawi-2': ['128'],
  'ar.muhammadayyoub': ['128'],
  'ar.muhammadayyoub-2': ['128'],
  'ar.muhammadjibreel': ['128'],
  'ar.muhammadjibreel-2': ['128'],
  'ar.shaatree': ['128', '64'],
  'ar.shaatree-2': ['128', '64'],
  'fr.leclerc': ['128'],
  'ru.kuliev-audio': ['128'],
  'zh.chinese': ['128'],
  'ar.abdulbasitmurattal': ['192', '64'],
  'ar.abdulbasitmurattal-2': ['192', '64'],
  'ar.abdullahbasfar': ['192', '32', '64'],
  'ar.abdullahbasfar-2': ['192', '32', '64'],
  'ar.abdurrahmaansudais': ['192', '64'],
  'ar.abdurrahmaansudais-2': ['192', '64'],
  'ar.hanirifai': ['192', '64'],
  'ar.hanirifai-2': ['192', '64'],
  'en.walk': ['192'],
  'ar.ibrahimakhbar': ['32'],
  'ru.kuliev-audio-2': ['320'],
  'fa.hedayatfarfooladvand': ['40'],
  'ar.parhizgar': ['48'],
  'ar.abdulsamad': ['64'],
  'ar.aymanswoaid': ['64'],
  'ar.aymanswoaid-2': ['64'],
  'ar.minshawimujawwad': ['64'],
  'ar.minshawimujawwad-2': ['64'],
  'ar.saoodshuraym': ['64'],
  'ar.saoodshuraym-2': ['64'],
  'ur.khan': ['64'],
};

class SuraPage extends StatefulWidget {
  final int suraId;
  final int? initialJuz;
  final int? initialAyah; // پارامتر جدید برای آیه خاص

  const SuraPage({
    required this.suraId,
    this.initialJuz,
    this.initialAyah,
    Key? key,
  }) : super(key: key);

  @override
  _SuraPageState createState() => _SuraPageState();
}

class _SuraPageState extends State<SuraPage> {
  int _currentSura = 0;
  int _currentPage = 0;
  int _currentJoz = 0;
  int _currentAyahIndex = 0;
  bool _isPlaying = false;
  bool _isAutoScrolling = false;
  double _scrollSpeed = 1.0;
  int _repeatCount = 1;
  int _currentRepeat = 0;
  String _selectedReciter = 'ar.alafasy';
  String _selectedBitrate = '128';
  late final PageController _pageController;
  final Map<int, ItemScrollController> _scrollControllers = {};
  final Map<int, ItemPositionsListener> _positionsListeners = {};
  Timer? _scrollTimer;
  Timer? _updateTimer;
  bool _isFullScreen = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isScrollingToPage = false;

  @override
  void initState() {
    super.initState();
    _currentSura = widget.suraId;
    _pageController = PageController(
      initialPage: widget.suraId - 1,
      keepPage: false,
      viewportFraction: 1.0,
    );
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    for (var sura in viewModel.quranNameList) {
      _scrollControllers[sura.id] = ItemScrollController();
      _positionsListeners[sura.id] = ItemPositionsListener.create();
    }

    // اسکرول به جزء یا آیه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialJuz != null) {
        final firstAyah = viewModel.getFirstAyahOfJoz(widget.initialJuz!);
        if (firstAyah != null) {
          _scrollToAyah(firstAyah.sura, firstAyah.aya);
        } else {
          print('No ayah found for Juz ${widget.initialJuz}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('آیه‌ای برای این جزء یافت نشد')),
          );
        }
      } else if (widget.initialAyah != null) {
        _scrollToAyah(widget.suraId, widget.initialAyah!);
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _playNextAyah();
    });
  }

  void _scrollToAyah(int suraId, int ayahNumber) {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    setState(() {
      _currentSura = suraId;
      _isScrollingToPage = true;
    });
    final suraIndex = viewModel.getSuraIndexById(suraId);
    _pageController.jumpToPage(suraIndex);
    final ayahIndex = viewModel
        .getAyahsBySura(suraId)
        .indexWhere((ayah) => ayah.aya == ayahNumber);
    if (ayahIndex != -1 && _scrollControllers[suraId] != null) {
      final ayah = viewModel.getAyahsBySura(suraId)[ayahIndex];
      setState(() {
        _currentPage = ayah.pageNo;
        _currentJoz = ayah.joz;
        _currentAyahIndex = ayahIndex;
      });
      _scrollControllers[suraId]!.scrollTo(
        index: ayahIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    setState(() {
      _isScrollingToPage = false;
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _updateTimer?.cancel();
    _audioPlayer.dispose();
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _playAyah(int ayahIndex) async {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    final ayahs = viewModel.getAyahsBySura(_currentSura);
    if (ayahIndex >= ayahs.length) return;

    setState(() {
      _currentAyahIndex = ayahIndex;
      _isPlaying = true;
      _currentRepeat = 0;
    });

    final ayah = ayahs[ayahIndex];
    final audioUrl = _getAudioUrl(ayah, _selectedReciter, _selectedBitrate);
    try {
      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      setState(() {
        _isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در پخش صدا: $e')),
      );
    }

    _scrollControllers[_currentSura]!.scrollTo(
      index: ayahIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _playNextAyah() {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    final ayahs = viewModel.getAyahsBySura(_currentSura);

    if (_currentRepeat < _repeatCount - 1) {
      setState(() {
        _currentRepeat++;
      });
      _playAyah(_currentAyahIndex);
    } else if (_currentAyahIndex < ayahs.length - 1) {
      _playAyah(_currentAyahIndex + 1);
    } else {
      setState(() {
        _isPlaying = false;
        _currentAyahIndex = 0;
      });
      _audioPlayer.stop();
    }
  }

  void _pauseAyah() {
    setState(() {
      _isPlaying = false;
    });
    _audioPlayer.pause();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pauseAyah();
    } else {
      _playAyah(_currentAyahIndex);
    }
  }

  String _getAudioUrl(QuranText ayah, String reciter, String bitrate) {
    if (!_reciterBitrates.containsKey(reciter) ||
        !_reciterBitrates[reciter]!.contains(bitrate)) {
      reciter = 'ar.alafasy';
      bitrate = '128';
    }

    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    int globalAyahNumber = ayah.aya;
    for (int i = 1; i < ayah.sura; i++) {
      final suraAyahs = viewModel.getAyahsBySura(i).length;
      globalAyahNumber += suraAyahs;
    }

    return 'https://cdn.islamic.network/quran/audio/$bitrate/$reciter/$globalAyahNumber.mp3';
  }

  void _setReciter(String reciter) {
    setState(() {
      _selectedReciter = reciter;
      _selectedBitrate = _reciterBitrates[reciter]!.first;
    });
    if (_isPlaying) {
      _playAyah(_currentAyahIndex);
    }
  }

  void _setBitrate(String bitrate) {
    setState(() {
      _selectedBitrate = bitrate;
    });
    if (_isPlaying) {
      _playAyah(_currentAyahIndex);
    }
  }

  void _setRepeatCount(int count) {
    setState(() {
      _repeatCount = count;
      _currentRepeat = 0;
    });
  }

  void _seekAudio(double value) {
    final newPosition = _totalDuration * value;
    _audioPlayer.seek(newPosition);
  }

  void _showReciterPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتخاب قاری', textDirection: TextDirection.rtl),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: _reciterBitrates.keys.length,
            itemBuilder: (context, index) {
              final reciter = _reciterBitrates.keys.elementAt(index);
              final reciterName =
                  _reciterInfo[reciter]?['name'] ?? reciter.split('.').last;
              final reciterImage = _reciterInfo[reciter]?['image'] ??
                  'https://example.com/images/default.jpg';
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(reciterImage),
                  radius: 20,
                  onBackgroundImageError: (exception, stackTrace) =>
                      const Icon(Icons.person),
                ),
                title: Text(reciterName, textDirection: TextDirection.rtl),
                onTap: () {
                  _setReciter(reciter);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    int tempRepeatCount = _repeatCount;
    String tempBitrate = _selectedBitrate;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تنظیمات پخش', textDirection: TextDirection.rtl),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: tempBitrate,
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      tempBitrate = value;
                    });
                  }
                },
                items: (_reciterBitrates[_selectedReciter] ?? ['128'])
                    .map((bitrate) {
                  return DropdownMenuItem(
                    value: bitrate,
                    child: Text('$bitrate kbps'),
                  );
                }).toList(),
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'vazirmatn'),
              ),
              DropdownButton<int>(
                value: tempRepeatCount,
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      tempRepeatCount = value;
                    });
                  }
                },
                items: const [
                  DropdownMenuItem(value: 1, child: Text('۱ بار')),
                  DropdownMenuItem(value: 2, child: Text('۲ بار')),
                  DropdownMenuItem(value: 3, child: Text('۳ بار')),
                  DropdownMenuItem(value: 5, child: Text('۵ بار')),
                ],
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'vazirmatn'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _setBitrate(tempBitrate);
              _setRepeatCount(tempRepeatCount);
              Navigator.pop(context);
            },
            child: const Text('تأیید'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لغو'),
          ),
        ],
      ),
    );
  }

  void _updateCurrentInfo(int suraId, ItemPositionsListener positionsListener) {
    if (_isScrollingToPage || (_updateTimer != null && _updateTimer!.isActive))
      return;
    _updateTimer = Timer(const Duration(milliseconds: 100), () {
      final viewModel = Provider.of<QuranViewModel>(context, listen: false);
      final positions = positionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstVisibleIndex = positions
            .where((pos) => pos.itemLeadingEdge >= 0)
            .reduce((min, pos) =>
                pos.itemLeadingEdge < min.itemLeadingEdge ? pos : min)
            .index;
        final ayah = viewModel.getAyahsBySura(suraId)[firstVisibleIndex];
        if (_currentPage != ayah.pageNo || _currentJoz != ayah.joz) {
          setState(() {
            _currentPage = ayah.pageNo;
            _currentJoz = ayah.joz;
          });
        }
      }
    });
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
                onTap: () async {
                  Navigator.pop(context);
                  final firstAyah = viewModel.quranTextList
                      .firstWhere((ayah) => ayah.pageNo == page);
                  setState(() {
                    _currentSura = firstAyah.sura;
                    _currentPage = page;
                    _isScrollingToPage = true;
                  });
                  final suraIndex = viewModel.quranNameList
                      .indexWhere((sura) => sura.id == firstAyah.sura);
                  await _pageController.animateToPage(
                    suraIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                  final ayahIndex = viewModel
                      .getAyahsBySura(firstAyah.sura)
                      .indexWhere((ayah) => ayah.pageNo == page);
                  if (ayahIndex != -1 &&
                      _scrollControllers[firstAyah.sura] != null) {
                    await _scrollControllers[firstAyah.sura]!.scrollTo(
                      index: ayahIndex,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    final ayah =
                        viewModel.getAyahsBySura(firstAyah.sura)[ayahIndex];
                    setState(() {
                      _currentPage = ayah.pageNo;
                      _currentJoz = ayah.joz;
                      _isScrollingToPage = false;
                    });
                  } else {
                    setState(() {
                      _isScrollingToPage = false;
                    });
                  }
                },
                child: Text('صفحه $page', textDirection: TextDirection.rtl),
              );
            },
          ),
        ),
      ),
    );
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
      Duration(milliseconds: (5000 / _scrollSpeed).round()),
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
          duration: const Duration(milliseconds: 600),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتخاب سوره', textDirection: TextDirection.rtl),
        content: _SuraPickerContent(
          onSuraSelected: (int suraId, int index) {
            setState(() {
              _currentSura = suraId;
            });
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            Navigator.pop(context);
          },
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
                onTap: () async {
                  Navigator.pop(context);
                  final firstAyah = viewModel.getFirstAyahOfJoz(joz.id);
                  if (firstAyah != null) {
                    setState(() {
                      _currentSura = firstAyah.sura;
                      _currentJoz = joz.id;
                      _currentPage = firstAyah.pageNo;
                      _isScrollingToPage = true;
                    });
                    final suraIndex = viewModel.quranNameList
                        .indexWhere((s) => s.id == firstAyah.sura);
                    await _pageController.animateToPage(
                      suraIndex,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    final ayahIndex = viewModel
                        .getAyahsBySura(firstAyah.sura)
                        .indexWhere((ayah) => ayah.aya == firstAyah.aya);
                    if (ayahIndex != -1 &&
                        _scrollControllers[firstAyah.sura] != null) {
                      await _scrollControllers[firstAyah.sura]!.scrollTo(
                        index: ayahIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                    setState(() {
                      _isScrollingToPage = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('آیه‌ای برای این جزء یافت نشد')),
                    );
                  }
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
    final settings = Provider.of<SettingsViewModel>(context);
    final suraName = viewModel.quranNameList
        .firstWhere((sura) => sura.id == _currentSura)
        .sura;

    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF1E5E3A),
              actions: const [
                _AppBarActions(),
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
                _isPlaying = false;
                _currentAyahIndex = 0;
                _scrollTimer?.cancel();
                _audioPlayer.stop();
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
                              child: Text('سوره $suraName',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'vazirmatn')),
                            ),
                            GestureDetector(
                              onTap: () => _showPagePicker(context),
                              child: Text(
                                  'صفحه ${convertToArabicNumber(_currentPage)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'vazirmatn')),
                            ),
                            GestureDetector(
                              onTap: () => _showJozPicker(context),
                              child: Text(
                                  'جزء ${convertToArabicNumber(_currentJoz)}',
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
                        initialScrollIndex:
                            _currentSura == sura.id ? _currentAyahIndex : 0,
                        itemBuilder: (context, index) {
                          final ayah = ayahs[index];
                          final translation = translations.firstWhere(
                            (trans) => trans.aya == ayah.aya,
                            orElse: () => QuranTranslation(
                                index: 0, sura: 0, aya: 0, text: ''),
                          );
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentAyahIndex = index;
                              });
                              scrollController.scrollTo(
                                index: index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AyahWidget(
                              ayah: ayah,
                              translation: translation.text.isNotEmpty
                                  ? translation
                                  : null,
                              settings: settings,
                              isHighlighted: _currentAyahIndex == index,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: _MiniPlayer(
              isPlaying: _isPlaying,
              togglePlayPause: _togglePlayPause,
              setReciter: _setReciter,
              selectedReciter: _selectedReciter,
              setBitrate: _setBitrate,
              setRepeatCount: _setRepeatCount,
              currentPosition: _currentPosition,
              totalDuration: _totalDuration,
              seekAudio: _seekAudio,
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

class _AppBarActions extends StatelessWidget {
  const _AppBarActions();

  @override
  Widget build(BuildContext context) {
    final suraPageState = context.findAncestorStateOfType<_SuraPageState>()!;
    return Row(
      children: [
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
            suraPageState._isAutoScrolling
                ? Icons.pause
                : Icons.keyboard_double_arrow_down,
          ),
          onPressed: suraPageState._toggleAutoScroll,
        ),
        IconButton(
          icon: Icon(
            suraPageState._isFullScreen
                ? Icons.fullscreen_exit
                : Icons.fullscreen,
          ),
          onPressed: suraPageState._toggleFullScreen,
        ),
      ],
    );
  }
}

class _SuraPickerContent extends StatelessWidget {
  final Function(int suraId, int index) onSuraSelected;

  const _SuraPickerContent({required this.onSuraSelected});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: viewModel.quranNameList.length,
        itemBuilder: (context, index) {
          final sura = viewModel.quranNameList[index];
          return ListTile(
            title: Text(sura.sura, textDirection: TextDirection.rtl),
            onTap: () {
              onSuraSelected(sura.id, index);
            },
          );
        },
      ),
    );
  }
}

class _SpeedControlBar extends StatelessWidget {
  const _SpeedControlBar();

  @override
  Widget build(BuildContext context) {
    final suraPageState = context.findAncestorStateOfType<_SuraPageState>()!;
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          suraPageState._buildSpeedButton(1.0),
          const SizedBox(width: 8),
          suraPageState._buildSpeedButton(2.0),
          const SizedBox(width: 8),
          suraPageState._buildSpeedButton(3.0),
          const SizedBox(width: 8),
          suraPageState._buildSpeedButton(4.0),
          const SizedBox(width: 8),
          suraPageState._buildSpeedButton(5.0),
        ],
      ),
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback togglePlayPause;
  final Function(String) setReciter;
  final String selectedReciter;
  final Function(String) setBitrate;
  final Function(int) setRepeatCount;
  final Duration currentPosition;
  final Duration totalDuration;
  final Function(double) seekAudio;

  const _MiniPlayer({
    required this.isPlaying,
    required this.togglePlayPause,
    required this.setReciter,
    required this.selectedReciter,
    required this.setBitrate,
    required this.setRepeatCount,
    required this.currentPosition,
    required this.totalDuration,
    required this.seekAudio,
  });

  @override
  Widget build(BuildContext context) {
    final reciterName = _reciterInfo[selectedReciter]?['name'] ??
        selectedReciter.split('.').last;
    final reciterImage = _reciterInfo[selectedReciter]?['image'] ??
        'https://example.com/images/default.jpg';

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context
                    .findAncestorStateOfType<_SuraPageState>()!
                    ._showReciterPicker(context),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundImage: NetworkImage(reciterImage),
                      radius: 16,
                      onBackgroundImageError: (exception, stackTrace) =>
                          const Icon(Icons.person),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_circle,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: togglePlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => context
                    .findAncestorStateOfType<_SuraPageState>()!
                    ._showSettingsDialog(context),
              ),
            ],
          ),
          Slider(
            value: totalDuration.inSeconds > 0
                ? currentPosition.inSeconds / totalDuration.inSeconds
                : 0.0,
            onChanged: seekAudio,
            activeColor: const Color(0xFF1E5E3A),
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
