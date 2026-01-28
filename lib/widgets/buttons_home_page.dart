import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/widgets/popup_level.dart';
import 'package:bouquetblossom/services/user_data_service.dart';

class ButtonsHomePage extends StatefulWidget {
  const ButtonsHomePage({super.key});

  @override
  State<ButtonsHomePage> createState() => _ButtonsHomePageState();
}

class _ButtonsHomePageState extends State<ButtonsHomePage> {
  bool _isWaterButtonEnabled = true;
  Timer? _waterButtonTimer;

  bool _isFlowerButtonEnabled = true;

  @override
  void dispose() {
    _waterButtonTimer?.cancel();
    super.dispose();
  }

  Future<void> _onWaterButtonPressed() async {
    if (!_isWaterButtonEnabled) return;
    await UserDataService().addFloralCurrency(100);

    debugPrint(
      "Arrosage effectué ! Nouveau solde : ${UserDataService().getFloralCurrency()}",
    );

    setState(() {
      _isWaterButtonEnabled = false;
    });

    // Timer de 10 secondes avant de réactiver le bouton
    _waterButtonTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isWaterButtonEnabled = true;
        });
      }
    });
  }

  void _onFlowerButtonPressed() {
    if (!_isFlowerButtonEnabled) return;
    // TODO Action du bouton --> ajouter des fleurs au bouquet
  }

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
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => const PopupLevel(
                    levelNumber: 1,
                    recompenses: [
                      "1",
                      "assets/images/lily.webp",
                      "100",
                      "assets/images/petal.webp",
                    ],
                  ),
                );
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
              onPressed: _isFlowerButtonEnabled ? _onFlowerButtonPressed : null,
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
                      return const Icon(
                        Icons.local_florist,
                        size: 30,
                        color: Colors.white,
                      );
                    },
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
              onPressed: _isWaterButtonEnabled ? _onWaterButtonPressed : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                backgroundColor: _isWaterButtonEnabled
                    ? AppColors.lightSakuraPink
                    : Colors.grey,
                foregroundColor: AppColors.whitePink,
                side: BorderSide(
                  color: _isWaterButtonEnabled
                      ? AppColors.white
                      : Colors.grey.shade400,
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
                    errorBuilder: (context, error, stackTrace) {
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
