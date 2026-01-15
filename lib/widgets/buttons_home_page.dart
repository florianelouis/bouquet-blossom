import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:bouquetblossom/widgets/popup_level.dart';

class ButtonsHomePage extends StatelessWidget {
  const ButtonsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bouton Niveau
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO afficher cette pop up avant le lancement du jeu (qui se fait dans la pop up directement /widgets/popup_level.dart)
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) => PopupLevel( levelNumber: 1, recompenses: ["1", "/assets/images/lily.webp", "100", "/assets/images/petal.webp"]),
                );
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
        // Boutons Fleurs et Arrosoir
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Bouton Fleurs
            ElevatedButton(
              onPressed: () {
                // TODO Action du bouton --> ajouter des fleurs au bouquet
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
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
                  Image.asset(
                    'assets/images/sakura.webp',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '5',
                    style: TextStyle(
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
              onPressed: () {
                // TODO Action du bouton --> arroser les fleurs du bouquet // donne 100 pétales 
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
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
                    width: 40,
                    height: 40,
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