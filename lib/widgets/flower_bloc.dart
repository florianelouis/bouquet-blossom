import 'package:flutter/material.dart';
import 'package:bouquetblossom/models/flower.dart';
import 'package:bouquetblossom/services/flowers_service.dart';
import 'dart:math';

class FlowerBloc extends StatelessWidget {
  final String flowerId;
  final VoidCallback? onTap;

  const FlowerBloc({super.key, required this.flowerId, this.onTap});

  // Récupérer les données de la fleur depuis le service
  Flower? _getFlower() {
    try {
      return FlowersService().getFlowerById(flowerId);
    } catch (e) {
      print('Erreur lors de la récupération de la fleur $flowerId: $e');
      return null;
    }
  }

  // Méthode statique pour générer un ID de fleur aléatoire
  static String randomFlowerId() {
    final flowers = FlowersService().getAllFlowers();
    if (flowers.isEmpty) return 'sakura'; // Valeur par défaut

    final random = Random();
    return flowers[random.nextInt(flowers.length)].id;
  }

  @override
  Widget build(BuildContext context) {
    final flower = _getFlower();

    // Si la fleur n'existe pas, afficher un placeholder
    if (flower == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.error_outline, color: Colors.grey),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            color: flower.blockColor,
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
              flower.imagePath, 
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading flower image: $error');
                return const Icon(Icons.local_florist, size: 40, color: Colors.white);
              },
            ),
          ),
        ),
      ),
    );
  }
}
