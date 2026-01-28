import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/screen/assets/home_page.dart';

class PopupEndLevel extends StatelessWidget {
  final int levelNumber;
  final bool success;
  final int finalScore;
  final List<String> recompenses;
  final Map<String, int>? collectedFlowers;
  final Map<String, int>? requiredFlowers;

  const PopupEndLevel({
    super.key,
    required this.levelNumber,
    required this.success,
    required this.finalScore,
    required this.recompenses,
    this.collectedFlowers,
    this.requiredFlowers,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: success ? const Color(0xFF3950AE) : const Color(0xFFAE3939),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                success ? "Niveau réussi !" : "Niveau échoué",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              
              Text(
                "Niveau $levelNumber",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Score final
              Text(
                "Score: $finalScore",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              
              // Fleurs collectées
              if (requiredFlowers != null && collectedFlowers != null) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Fleurs collectées",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ...requiredFlowers!.entries.map((entry) {
                        final collected = collectedFlowers![entry.key] ?? 0;
                        final required = entry.value;
                        final isComplete = collected >= required;
                        
                        return Text(
                          '${entry.key}: $collected/$required ${isComplete ? "✓" : "✗"}',
                          style: TextStyle(
                            color: isComplete ? Colors.green : Colors.red,
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
              
              if (success) ...[
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF23357C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Text(
                          "Récompenses",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              recompenses[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.local_florist, color: Colors.white, size: 25),
                            const SizedBox(width: 15),
                            Text(
                              recompenses[2],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.monetization_on, color: Colors.white, size: 22),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 15),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sakuraPink,
                  side: const BorderSide(color: AppColors.white, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                },
                child: Text(
                  success ? 'Revenir à l\'accueil' : 'Réessayer',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}