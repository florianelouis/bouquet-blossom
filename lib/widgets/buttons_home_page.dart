import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:bouquetblossom/widgets/popup_level.dart';
import 'package:bouquetblossom/services/user_data_service.dart';
import 'package:bouquetblossom/services/levels_service.dart';

class ButtonsHomePage extends StatefulWidget {
  const ButtonsHomePage({super.key});

  @override
  State<ButtonsHomePage> createState() => _ButtonsHomePageState();
}

class _ButtonsHomePageState extends State<ButtonsHomePage> {
  final UserDataService _userDataService = UserDataService();
  final LevelsService _levelsService = LevelsService();

  int _currentLevel = 1;
  int _floralCurrency = 0;
  int _flowerCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initProgress();
  }

  // Initialisation du service et récupération des données
  Future<void> _initProgress() async {
    await _userDataService.init();
    await _levelsService.loadLevels();

    if (mounted) {
      setState(() {
        _currentLevel = _userDataService.getCurrentLevel();
        _floralCurrency = _userDataService.getFloralCurrency();

        // Compter le nombre total de fleurs débloquées
        _flowerCount = _userDataService.getUnlockedBouquets().length;

        _isLoading = false;
      });
    }
  }

  // Rafraîchir les données quand on revient sur la page
  Future<void> _refreshData() async {
    await _initProgress();
  }

  // Action pour arroser (donne 100 pétales)
  Future<void> _waterFlowers() async {
    await _userDataService.addFloralCurrency(100);

    if (mounted) {
      setState(() {
        _floralCurrency = _userDataService.getFloralCurrency();
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous avez gagné 100 pétales ! 🌸'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Bouton Niveau
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Afficher la popup du niveau actuel
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) =>
                      PopupLevel(levelNumber: _currentLevel),
                );

                // Rafraîchir les données après fermeture de la popup
                _refreshData();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 8,
                ),
                backgroundColor: AppColors.whitePink,
                foregroundColor: AppColors.sakuraPink,
                side: const BorderSide(color: AppColors.sakuraPink, width: 2),
                fixedSize: const Size(300, 60),
              ),
              child: Text(
                'Niveau $_currentLevel',
                style: const TextStyle(
                  fontSize: 32,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Affichage des pétales (optionnel)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.lightSakuraPink.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.sakuraPink, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/petal.webp',
                width: 25,
                height: 25,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.star,
                    size: 25,
                    color: AppColors.sakuraPink,
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                '$_floralCurrency',
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: AppColors.sakuraPink,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Boutons Fleurs et Arrosoir
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Bouton Fleurs
            ElevatedButton(
              onPressed: () {
                // TODO: Naviguer vers la page de gestion des bouquets
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir !'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                backgroundColor: AppColors.matchaGreen,
                foregroundColor: AppColors.whitePink,
                side: const BorderSide(color: AppColors.white, width: 2),
                fixedSize: const Size(130, 60),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/sakura.webp',
                    width: 30,
                    height: 30,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading sakura: $error');
                      return const Icon(
                        Icons.local_florist,
                        size: 30,
                        color: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_flowerCount',
                    style: const TextStyle(
                      fontSize: 32,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Bouton Arrosoir
            ElevatedButton(
              onPressed: _waterFlowers,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                backgroundColor: AppColors.lightSakuraPink,
                foregroundColor: AppColors.whitePink,
                side: const BorderSide(color: AppColors.white, width: 2),
                fixedSize: const Size(130, 60),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/water.webp',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading water: $error');
                      return const Icon(
                        Icons.water_drop,
                        size: 40,
                        color: Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
