import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'welcome_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bouquet Blossom',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.manropeTextTheme(),
      ),
      home: const WelcomePage(),
    );
  }
}