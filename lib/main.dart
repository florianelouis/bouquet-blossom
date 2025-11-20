import 'package:flutter/material.dart';
import 'home.dart';

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
      ),
      home: const Home(),
    );
  }
}