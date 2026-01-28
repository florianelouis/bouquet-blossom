import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/screen/assets/game.dart';
import 'package:bouquetblossom/services/levels_service.dart';
import 'package:bouquetblossom/services/user_data_service.dart';

class PopupLevel extends StatefulWidget {
  final int levelNumber;

  const PopupLevel({
    super.key,
    required this.levelNumber,
  });

  @override
  State<PopupLevel> createState() => _PopupLevelState();
}

class _PopupLevelState extends State<PopupLevel> {
  late final UserDataService _userDataService;
  late final LevelsService _levelsService;
  LevelConfig? levelConfig; // Changé de LevelsService? à LevelConfig?
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
    await _levelsService.loadLevels(); // Changé de LevelsData() à _levelsService

    setState(() {
      levelConfig = _levelsService.getLevelConfig(widget.levelNumber); // Changé de LevelsData() à _levelsService
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
        child: SizedBox(
          width: 350,
          height: 250,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3950AE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Niveau introuvable',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      );
    }

    // Calculer les récompenses estimées
    final estimatedReward = (levelConfig!.objective.points / 100).round();

    return Dialog(
      child: SizedBox(
        width: 350,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3950AE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                
                // Objectifs du niveau
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
                          "Objectifs",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        // Points
                        Text(
                          '${levelConfig!.objective.points} points',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        
                        // Mouvements
                        if (!levelConfig!.hasUnlimitedMoves)
                          Text(
                            '${levelConfig!.moves} coups',
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
                        if (levelConfig!.hasFlowerObjectives) ...[
                          const SizedBox(height: 10),
                          ...levelConfig!.objective.flowers!.entries.map((entry) {
                            return Text(
                              '${entry.value} ${entry.key}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                decoration: TextDecoration.none,
                              ),
                            );
                          }).toList(),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Récompenses
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
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "1",
                              style: TextStyle(
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
                              "~$estimatedReward",
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
                
                const SizedBox(height: 15),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sakuraPink,
                    side: const BorderSide(color: AppColors.white, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Game(levelConfig: levelConfig!),
                      ),
                    );
                  },
                  child: const Text(
                    'Jouer',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
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