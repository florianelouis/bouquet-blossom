import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/models/bouquet.dart';

class BouquetCard extends StatelessWidget {
  final Bouquet bouquet;
  final bool isUnlocked;

  const BouquetCard({
    super.key,
    required this.bouquet,
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
        child: isUnlocked
            ? Image.asset(
                bouquet.fullImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                  );
                },
              )
            : Center(
                child: Icon(
                  Icons.lock,
                  size: 50,
                  color: AppColors.sakuraPink.withValues(alpha: 0.5),
                ),
              ),
      ),
    );
  }
}
