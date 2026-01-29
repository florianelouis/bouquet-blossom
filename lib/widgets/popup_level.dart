import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/screen/assets/game.dart';
import 'package:bouquetblossom/services/levels_service.dart';
import 'package:bouquetblossom/services/user_data_service.dart';

class PopupLevel extends StatefulWidget {
  final int levelNumber;

  const PopupLevel({super.key, required this.levelNumber});

  @override
  State<PopupLevel> createState() => _PopupLevelState();
}

class _PopupLevelState extends State<PopupLevel> {
  late final UserDataService _userDataService;
  late final LevelsService _levelsService;
  LevelConfig? levelConfig;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _userDataService = UserDataService();
    _levelsService = LevelsService();
    _loadLevelData();
  }

  Future<void> _loadLevelData() async {
    await _userDataService.init();
    await _levelsService.loadLevels();

    setState(() {
      levelConfig = _levelsService.getLevelConfig(widget.levelNumber);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Dialog(
        child: SizedBox(
          width: 350,
          height: 250,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      );
    }

    if (levelConfig == null) {
      return Dialog(
        child: Container(
          width: 350,
          height: 250,
          decoration: BoxDecoration(
            color: const Color(0xFF3950AE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              'Niveau introuvable',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      );
    }

    // Stocker dans une variable locale
    final config = levelConfig!;
    final estimatedReward = (config.objective.points / 100).round();

    return Dialog(
      child: Container(
        width: 350,
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: const Color(0xFF3950AE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Titre
                Text(
                  "Niveau ${widget.levelNumber}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 15),

                // Container avec les objectifs
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF23357C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Text(
                          "Objectifs",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Points
                        Text(
                          '${config.objective.points} points',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),

                        // Mouvements
                        if (!config.hasUnlimitedMoves)
                          Text(
                            '${config.moves} coups',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          )
                        else
                          const Text(
                            'Coups illimités',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),

                        // Fleurs à collecter
                        if (config.hasFlowerObjectives) ...[
                          const SizedBox(height: 5),
                          ...config.objective.flowers!.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '${entry.value} ${entry.key}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Container avec les récompenses
                Container(
                  width: double.infinity,
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
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "1",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                'assets/images/lily.webp',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint(
                                    'Error loading reward image: $error',
                                  );
                                  return const Icon(
                                    Icons.local_florist,
                                    size: 30,
                                    color: Colors.white,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "~$estimatedReward",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: Image.asset(
                                'assets/images/petal.webp',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint(
                                    'Error loading reward image: $error',
                                  );
                                  return const Icon(
                                    Icons.star,
                                    size: 25,
                                    color: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Bouton Jouer
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sakuraPink,
                      side: const BorderSide(color: AppColors.white, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Game(levelConfig: config),
                        ),
                      );
                    },
                    child: const Text(
                      'Jouer',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
