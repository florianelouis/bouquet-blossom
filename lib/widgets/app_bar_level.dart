import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBarLevel extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int currentScore;
  final int targetScore;
  final int? movesRemaining;
  final Map<String, int>? collectedFlowers;
  final Map<String, int>? requiredFlowers;

  const CustomAppBarLevel({
    super.key,
    required this.title,
    this.currentScore = 0,
    this.targetScore = 0,
    this.movesRemaining,
    this.collectedFlowers,
    this.requiredFlowers,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Mouvements restants ou infini
          if (movesRemaining != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: Colors.black, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    '$movesRemaining',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else
            const Text(
              "∞",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

          // Score actuel / Objectif
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 30,
                  minHeight: 40,
                  maxWidth: 200,
                  maxHeight: 40,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$currentScore",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        " / ",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      Text(
                        "$targetScore",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Objectifs de fleurs
          if (requiredFlowers != null && collectedFlowers != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: requiredFlowers!.entries.take(2).map((entry) {
                  final collected = collectedFlowers![entry.key] ?? 0;
                  final required = entry.value;
                  final isComplete = collected >= required;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            'assets/images/${entry.key}.webp',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.local_florist,
                                size: 20,
                                color: Colors.black,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$collected/$required',
                          style: TextStyle(
                            color: isComplete ? Colors.green : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      toolbarTextStyle: const TextStyle(fontFamily: 'Manrope'),
      backgroundColor: AppColors.sakuraPink,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
