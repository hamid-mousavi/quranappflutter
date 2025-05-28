
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/models/latest_page.dart';
import 'package:quran/models/quran_joz.dart';
import 'package:quran/models/quran_name.dart';
import 'package:quran/models/quran_text.dart';
import 'package:quran/models/quran_translation.dart';
import 'package:quran/service/quran_service.dart';
import 'package:quran/viewmodels/quran_view_model.dart';
import 'package:quran/views/home_page.dart';
import 'package:quran/views/widgets/ayah_widget.dart';
import 'package:quran/views/widgets/sura_card.dart';

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
