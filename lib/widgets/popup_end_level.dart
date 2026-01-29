import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/screen/assets/home_page.dart';
import 'package:bouquetblossom/services/user_data_service.dart';
import 'package:bouquetblossom/services/levels_service.dart';
import 'package:bouquetblossom/screen/assets/game.dart';

class PopupEndLevel extends StatefulWidget {
  final int levelNumber;
  final bool success;
  final int finalScore;
  final Map<String, int>? collectedFlowers;
  final Map<String, int>? requiredFlowers;
  final int? remainingMoves;
  final LevelConfig levelConfig;
  final List<List<String>> currentGrid;
  final int currentScore;
  final Map<String, int> currentCollectedFlowers;
  final VoidCallback? onContinueWithExtraMoves;

  const PopupEndLevel({
    super.key,
    required this.levelNumber,
    required this.success,
    required this.finalScore,
    this.collectedFlowers,
    this.requiredFlowers,
    this.remainingMoves,
    required this.levelConfig,
    required this.currentGrid,
    required this.currentScore,
    required this.currentCollectedFlowers,
    this.onContinueWithExtraMoves,
  });

  @override
  State<PopupEndLevel> createState() => _PopupEndLevelState();
}

class _PopupEndLevelState extends State<PopupEndLevel> {
  final UserDataService _userDataService = UserDataService();
  final LevelsService _levelsService = LevelsService();

  static const int EXTRA_MOVES_AMOUNT = 5;

  @override
  void initState() {
    super.initState();
    if (widget.success) {
      _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    await _userDataService.init();

    await _userDataService.setBestScore(
      'level_${widget.levelNumber}',
      widget.finalScore,
    );

    await _userDataService.completeLevel('level_${widget.levelNumber}');

    if (widget.levelNumber == _userDataService.getCurrentLevel()) {
      await _userDataService.nextLevel();
    }

    final levelConfig = _levelsService.getLevelConfig(widget.levelNumber);
    if (levelConfig != null) {
      await _userDataService.unlockBouquet('bouquet_${levelConfig.bouquetId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: widget.success
              ? const Color(0xFF3950AE)
              : const Color(0xFFAE3939),
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
                  widget.success ? "Niveau réussi !" : "Niveau échoué",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  "Niveau ${widget.levelNumber}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 15),

                // Score
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.success
                        ? const Color(0xFF23357C)
                        : const Color(0xFF7C2323),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Text(
                          "Score",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${widget.finalScore}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Fleurs collectées
                if (widget.requiredFlowers != null &&
                    widget.collectedFlowers != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.success
                          ? const Color(0xFF23357C)
                          : const Color(0xFF7C2323),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const Text(
                            "Fleurs collectées",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...widget.requiredFlowers!.entries.map((entry) {
                            final collected =
                                widget.collectedFlowers![entry.key] ?? 0;
                            final required = entry.value;
                            final isComplete = collected >= required;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '${entry.key}: $collected/$required ${isComplete ? "✓" : "✗"}',
                                style: TextStyle(
                                  color: isComplete
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 15),

                // Bouton ajouter des mouvements (si échec)
                if (!widget.success &&
                    widget.remainingMoves != null &&
                    widget.remainingMoves! <= 0 &&
                    widget.onContinueWithExtraMoves != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB74D),
                        side: const BorderSide(
                          color: AppColors.white,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: widget.onContinueWithExtraMoves,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '+$EXTRA_MOVES_AMOUNT coups',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Bouton principal
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
                      if (widget.success) {
                        // Retour à l'accueil si succès
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      } else {
                        // Réessayer le niveau
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Game(levelConfig: widget.levelConfig),
                          ),
                        );
                      }
                    },
                    child: Text(
                      widget.success ? 'Revenir à l\'accueil' : 'Réessayer',
                      style: const TextStyle(
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
