import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'dart:math';

// Types de fleurs disponibles dans le jeu
enum FlowerType {
  sakura,
  poppy,
  lily,
  sunflower,
  hydrangea,
}

class FlowerBloc extends StatelessWidget {
  final FlowerType type;
  final VoidCallback? onTap;
  
  const FlowerBloc({
    super.key,
    required this.type,
    this.onTap,
  });

  // Méthode pour obtenir la couleur selon le type de fleur
  Color getColor() {
    switch (type) {
      case FlowerType.sakura:
        return AppColors.flowerSakura;
      case FlowerType.poppy:
        return AppColors.flowerPoppy;
      case FlowerType.lily:
        return AppColors.flowerLily;
      case FlowerType.sunflower:
        return AppColors.flowerSunflower;
      case FlowerType.hydrangea:
        return AppColors.flowerHydrangea;
    }
  }

  // Méthode pour obtenir le chemin de l'image selon le type de fleur
  String getImagePath() {
    switch (type) {
      case FlowerType.sakura:
        return 'assets/images/sakura.webp';
      case FlowerType.poppy:
        return 'assets/images/poppy.webp';
      case FlowerType.lily:
        return 'assets/images/lily.webp';
      case FlowerType.sunflower:
        return 'assets/images/sunflower.webp';
      case FlowerType.hydrangea:
        return 'assets/images/hydrangea.webp';
    }
  }

  // Méthode statique pour générer un type de fleur aléatoire
  static FlowerType randomType() {
    final random = Random();
    return FlowerType.values[random.nextInt(FlowerType.values.length)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              getImagePath(),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
