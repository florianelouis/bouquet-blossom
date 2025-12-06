import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bouquetblossom/widgets/popup_tuto.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isFirstWaterClick = true; // A mettre dans le local storage plus tard

  static const List<String> _titles = <String>['Accueil', 'Collections'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        toolbarTextStyle: const TextStyle(fontFamily: 'Manrope'),
        backgroundColor: AppColors.sakuraPink,
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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Action du bouton --> redirection vers la page de jeu
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                      // Couleur de fond du bouton
                      backgroundColor: AppColors.whitePink,
                      // Couleur du texte du bouton
                      foregroundColor: AppColors.sakuraPink,
                      // Couleur de la bordure du bouton
                      side: const BorderSide(
                        color: AppColors.sakuraPink,
                        width: 2,
                      ),
                      fixedSize: const Size(300, 60),
                    ),
                    child: const Text(
                      'Niveau 1',
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Action du bouton --> ajouter des fleurs au bouquet
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 50,
                            fontFamily: 'Manrope',
                          ),
                          backgroundColor: AppColors.matchaGreen,
                          foregroundColor: AppColors.whitePink,
                          side: const BorderSide(
                            color: AppColors.white,
                            width: 2,
                          ),
                          fixedSize: const Size(130, 60),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 8),
                            Image.asset(
                              'assets/images/sakura.webp',
                              width: 50,
                              height: 50,
                            ),
                            const Text(
                              '5',
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                color: AppColors.lightSakuraPink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Action du bouton --> arroser les fleurs du bouquet

                          if (_isFirstWaterClick) {
                            await showDialog(
                              context: context,
                              builder: (context) => const PopupTuto(
                                popupTitle: "Arrosoir",
                                popupText:
                                    "Les fleurs ont besoin d’eau pour pousser, essaie de les arroser !",
                              ),
                            );
                            setState(() {
                              _isFirstWaterClick = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 50,
                            fontFamily: 'Manrope',
                          ),
                          backgroundColor: AppColors.lightSakuraPink,
                          foregroundColor: AppColors.whitePink,
                          side: const BorderSide(
                            color: AppColors.white,
                            width: 2,
                          ),
                          fixedSize: const Size(130, 60),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/water.webp',
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.sakuraPink,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: 'Collections',
          ),
        ],
      ),
    );
  }
}
