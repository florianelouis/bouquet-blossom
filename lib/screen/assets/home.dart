import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/widgets/popup_tuto.dart';
import 'package:bouquetblossom/widgets/popup_level.dart';
import 'package:bouquetblossom/services/user_data_service.dart';

class AssetsHome extends StatefulWidget {
  const AssetsHome({super.key});

  @override
  State<AssetsHome> createState() => _AssetsHomeState();
}

class _AssetsHomeState extends State<AssetsHome> {
  bool _isFirstWaterClick = true;
  bool _isFirstBouquetClick = true;

  final UserDataService _userDataService = UserDataService();
  int _currentLevel = 1;

  @override
  void initState() {
    super.initState();
    // 2. Charger les données au démarrage
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    await _userDataService.init();
    if (mounted) {
      setState(() {
        _currentLevel = _userDataService.getCurrentLevel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              // TODO: État actuel du bouquet à afficher ici
              child: Center(
                child: Image.asset(
                  'assets/images/bouquets/bouquet1-4.webp',
                  fit: BoxFit.contain,
                  cacheWidth: 600,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading bouquet: $error');
                    return const Icon(
                      Icons.local_florist,
                      size: 100,
                      color: AppColors.sakuraPink,
                    );
                  },
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
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          PopupLevel(levelNumber: _currentLevel),
                    );
                    setState(() {
                      //_isLevelClick = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 8,
                    ),
                    backgroundColor: AppColors.whitePink,
                    foregroundColor: AppColors.sakuraPink,
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_isFirstBouquetClick) {
                          await showDialog(
                            context: context,
                            builder: (context) => const PopupTuto(
                              popupTitle: "Bouquet",
                              popupText:
                                  "Tu as récupéré des fleurs dans des niveaux, ajoute les à ton bouquet.",
                            ),
                          );
                          setState(() {
                            _isFirstBouquetClick = false;
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
                            cacheWidth: 100,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Error loading sakura: $error');
                              return const Icon(
                                Icons.local_florist,
                                size: 50,
                                color: AppColors.sakuraPink,
                              );
                            },
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
                        if (_isFirstWaterClick) {
                          await showDialog(
                            context: context,
                            builder: (context) => const PopupTuto(
                              popupTitle: "Arrosoir",
                              popupText:
                                  "Les fleurs ont besoin d'eau pour pousser, essaie de les arroser !",
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
                            cacheWidth: 160,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Error loading water: $error');
                              return const Icon(
                                Icons.water_drop,
                                size: 80,
                                color: AppColors.lightSakuraPink,
                              );
                            },
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
    );
  }
}
