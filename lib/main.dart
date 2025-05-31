import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/viewmodels/quran_view_model.dart';
import 'package:quran/viewmodels/settings_view_model.dart';
import 'package:quran/views/home_page.dart';

// Main App
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final viewModel = QuranViewModel();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.loadData(context);
            });
            return viewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsViewModel(),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quran App',
            themeMode: settings.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.green,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                actionsIconTheme: IconThemeData(
                  color: Colors.white, // رنگ آیکون‌های نوار ابزار
                ),
                backgroundColor: Color(0xFF1E5E3A), // سبز مذهبی
                titleTextStyle: TextStyle(
                  fontFamily: 'vazirmatn', // فونت فارسی
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              cardTheme: CardTheme(
                color: Colors.grey.shade200, // رنگ پس‌زمینه Card در حالت روشن
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(
                  color: Colors.black,
                  fontFamily: 'amiriquran', // فونت عربی
                ),
                bodyMedium: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'amiriquran', // فونت عربی
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF121212),
              primaryColor: Colors.green,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1E5E3A), // سبز مذهبی در تم تیره
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
              ),
            ),
            home: const HomePage(),
            routes: {
              '/settings': (context) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
