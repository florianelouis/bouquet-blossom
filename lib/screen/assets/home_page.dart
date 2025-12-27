import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/widgets/app_bar.dart';
import 'package:bouquetblossom/widgets/bottom_nav_bar.dart';
import 'package:bouquetblossom/widgets/buttons_home_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<String> _titles = <String>['Accueil', 'Collections'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Widget séparé pour l'app bar 
      appBar: CustomAppBar(
        title: _titles[_selectedIndex],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.sakuraPink, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Bouquet de fleurs',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          // Widget séparé pour les boutons
          const ButtonsHomePage(),
        ],
      ),
      // Widget séparé pour la bottom navigation bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}