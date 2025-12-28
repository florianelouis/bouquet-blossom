import 'package:flutter/material.dart';
import 'package:bouquetblossom/widgets/app_bar.dart';
import 'package:bouquetblossom/widgets/bottom_nav_bar.dart';
import 'package:bouquetblossom/screen/assets/home.dart';
import 'package:bouquetblossom/screen/assets/collections.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<String> _titles = <String>['Accueil', 'Collections'];

  // Liste des "fragments" à afficher
  static const List<Widget> _pages = <Widget>[
    AssetsHome(),
    CollectionsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Titre dynamique selon l'onglet sélectionné
      appBar: CustomAppBar(
        title: _titles[_selectedIndex],
      ),
      body: _pages[_selectedIndex],
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
