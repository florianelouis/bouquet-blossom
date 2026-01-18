import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/models/flower.dart';

class FlowerCard extends StatelessWidget {
  final Flower flower;
  final bool isUnlocked;

  const FlowerCard({
    super.key,
    required this.flower,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sakuraPink, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: isUnlocked
                    ? Image.asset(
                        flower.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.error_outline,
                            size: 50,
                            color: Colors.red,
                          );
                        },
                      )
                    : Icon(
                        Icons.lock,
                        size: 50,
                        color: AppColors.matchaGreen.withValues(alpha: 0.5),
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                flower.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
