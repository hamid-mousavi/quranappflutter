import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsViewModel extends ChangeNotifier {
  bool _alignment = true; // ترازبندی: left, center, right
  String _displayMode =
      'text_and_translation'; // نوع نمایش: text_only, translation_only, text_and_translation
  String _translation = 'makarem'; // ترجمه: makarem, qaraati, ansarian
  String _font = 'UthmanicHafs'; // فونت: default, amiri, vazir
  String _translationFont = 'vazirmatn'; // فونت: default, amiri, vazir
  double _fontSize = 21; // اندازه قلم
  double _translateFontSize = 18; // اندازه قلم ترجمه

  double _lineSpacing = 2.5; // فاصله خطوط
  Color _textColor = Colors.black; // رنگ متن
  Color _translationColor = Colors.blueGrey; // رنگ ترجمه
  Color _backgroundColor = Colors.white; // رنگ پس‌زمینه
  bool _isDarkMode = false; // حالت شب
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get alignment => _alignment;
  String get displayMode => _displayMode;
  String get translation => _translation;
  String get font => _font;
  double get translateFontSize => _translateFontSize;
  String get translationFont => _translationFont;

  double get fontSize => _fontSize;
  double get lineSpacing => _lineSpacing;
  Color get textColor => _textColor;
  Color get translationColor => _translationColor;
  Color get backgroundColor => _backgroundColor;
  bool get isDarkMode => _isDarkMode;

  void toogleAlignment(bool value) {
    _alignment = value;
    notifyListeners();
  }

  void updateDisplayMode(String value) {
    _displayMode = value;
    notifyListeners();
  }

  void updateTranslation(String value) {
    _translation = value;
    notifyListeners();
  }

  void updateFont(String value) {
    _font = value;
    notifyListeners();
  }

  void updateTranslationFont(String value) {
    _translationFont = value;
    notifyListeners();
  }

  void updateFontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  void updateTranslateFontSize(double value) {
    _translateFontSize = value;
    notifyListeners();
  }

  void updateLineSpacing(double value) {
    _lineSpacing = value;
    notifyListeners();
  }

  void updateTextColor(Color value) {
    _textColor = value;
    notifyListeners();
  }

  void updateTranslationColor(Color value) {
    _translationColor = value;
    notifyListeners();
  }

  void updateBackgroundColor(Color value) {
    _backgroundColor = value;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات', style: TextStyle(fontSize: 18)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // ترازبندی
              // const Text('ترازبندی متن',
              //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // SwitchListTile(
              //   title: const Text('فعال کردن ترازبندی'),
              //   value: settings.alignment,
              //   onChanged: (value) => settings.toogleAlignment(value),
              // ),
              // const SizedBox(height: 16),

              // نوع نمایش
              const Text('نوع نمایش',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: settings.displayMode,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'text_only', child: Text('فقط متن')),
                  DropdownMenuItem(
                      value: 'translation_only', child: Text('فقط ترجمه')),
                  DropdownMenuItem(
                      value: 'text_and_translation',
                      child: Text('متن و ترجمه')),
                ],
                onChanged: (value) {
                  if (value != null) settings.updateDisplayMode(value);
                },
              ),
              const SizedBox(height: 16),

              // انتخاب ترجمه
              const Text('انتخاب ترجمه',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: settings.translation,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                      value: 'makarem', child: Text('مکارم شیرازی')),
                  DropdownMenuItem(value: 'qaraati', child: Text('قرائتی')),
                  DropdownMenuItem(value: 'ansarian', child: Text('انصاریان')),
                ],
                onChanged: (value) {
                  if (value != null) settings.updateTranslation(value);
                },
              ),
              const SizedBox(height: 16),

              // انتخاب فونت
              const Text('فونت',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: settings.font,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                      value: 'UthmanicHafs', child: Text('عثمان حفص')),
                  DropdownMenuItem(value: 'osmanTaha', child: Text('عثمان طه')),
                  DropdownMenuItem(
                      value: 'amiriquran', child: Text('امیری قرآن')),
                  DropdownMenuItem(value: 'vazirmatn', child: Text('وزیر')),
                  DropdownMenuItem(value: 'amiri', child: Text('امیری')),
                ],
                onChanged: (value) {
                  if (value != null) settings.updateFont(value);
                },
              ),
              const SizedBox(height: 16),
              // انتخاب فونت ترجمه
              const Text('فونت ترجمه',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: settings.translationFont,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'vazirmatn', child: Text('پیش‌فرض')),
                  DropdownMenuItem(value: 'amiri', child: Text('امیری')),
                ],
                onChanged: (value) {
                  if (value != null) settings.updateTranslationFont(value);
                },
              ),
              const SizedBox(height: 16),

              // اندازه قلم
              const Text('اندازه قلم',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Slider(
                value: settings.fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                label: settings.fontSize.toStringAsFixed(1),
                onChanged: (value) => settings.updateFontSize(value),
              ),
              const SizedBox(height: 16),
              // اندازه قلم ترجمه
              const Text('اندازه قلم ترجمه',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Slider(
                value: settings.translateFontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                label: settings.translateFontSize.toStringAsFixed(1),
                onChanged: (value) => settings.updateTranslateFontSize(value),
              ),

              // فاصله خطوط
              const Text('فاصله خطوط',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Slider(
                value: settings.lineSpacing,
                min: 1.0,
                max: 3.0,
                divisions: 10,
                label: settings.lineSpacing.toStringAsFixed(1),
                onChanged: (value) => settings.updateLineSpacing(value),
              ),
              const SizedBox(height: 16),

              // رنگ متن
              const Text('رنگ متن',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ListTile(
                title: const Text('انتخاب رنگ متن'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  color: settings.textColor,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('انتخاب رنگ متن'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: settings.textColor,
                          onColorChanged: (color) =>
                              settings.updateTextColor(color),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('تأیید'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // رنگ ترجمه
              const Text('رنگ ترجمه',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ListTile(
                title: const Text('انتخاب رنگ ترجمه'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  color: settings.translationColor,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('انتخاب رنگ ترجمه'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: settings.translationColor,
                          onColorChanged: (color) =>
                              settings.updateTranslationColor(color),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('تأیید'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // رنگ پس‌زمینه
              const Text('رنگ پس‌زمینه',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ListTile(
                title: const Text('انتخاب رنگ پس‌زمینه'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  color: settings.backgroundColor,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('انتخاب رنگ پس‌زمینه'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: settings.backgroundColor,
                          onColorChanged: (color) =>
                              settings.updateBackgroundColor(color),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('تأیید'),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // حالت شب و روز
              // const Text('حالت شب',
              //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // SwitchListTile(
              //   title: const Text('فعال کردن حالت شب'),
              //   value: settings.isDarkMode,
              //   onChanged: (value) => settings.toggleDarkMode(value),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
