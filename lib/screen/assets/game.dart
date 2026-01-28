import 'package:flutter/material.dart';
import 'package:bouquetblossom/widgets/flower_bloc.dart';
import 'package:bouquetblossom/widgets/app_bar_level.dart';
import 'package:bouquetblossom/widgets/popup_end_level.dart';
import 'package:bouquetblossom/services/levels_service.dart';
import 'package:bouquetblossom/services/user_data_service.dart';

class Game extends StatefulWidget {
  final LevelConfig levelConfig;

  const Game({
    super.key,
    required this.levelConfig,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late final UserDataService _userDataService;

  // Taille de la grille
  final int gridSize = 8;

  // Liste pour stocker les IDs de fleurs dans la grille
  List<List<String>> grid = [];

  // Identifiants uniques pour chaque bloc (pour les animations)
  List<List<UniqueKey>> blocKeys = [];

  // Score du niveau en cours
  int currentScore = 0;

  // Mouvements restants
  int? movesRemaining;

  // Compteur de fleurs collectées
  Map<String, int> collectedFlowers = {};

  // Animation en cours
  bool isAnimating = false;

  // Position de départ du drag
  int? dragStartRow;
  int? dragStartCol;

  // Blocs en cours de swap
  Set<String> swappingBlocs = {};

  // Blocs en cours de suppression
  Set<String> disappearingBlocs = {};

  @override
  void initState() {
    super.initState();
    _userDataService = UserDataService();
    
    // Initialiser les mouvements
    if (!widget.levelConfig.hasUnlimitedMoves) {
      movesRemaining = widget.levelConfig.moves;
    }

    // Initialiser le compteur de fleurs si nécessaire
    if (widget.levelConfig.hasFlowerObjectives) {
      widget.levelConfig.objective.flowers!.forEach((flower, _) {
        collectedFlowers[flower] = 0;
      });
    }

    // Initialiser la grille avec des fleurs aléatoires
    initializeGrid();
  }

  // Initialiser la grille avec des fleurs aléatoires
  void initializeGrid() {
    grid = List.generate(
      gridSize,
      (row) => List.generate(gridSize, (col) => FlowerBloc.randomFlowerId()),
    );
    blocKeys = List.generate(
      gridSize,
      (row) => List.generate(gridSize, (col) => UniqueKey()),
    );

    // Supprimer les matches initiaux
    while (findAllMatches().isNotEmpty) {
      final matches = findAllMatches();
      for (final match in matches) {
        final parts = match.split(',');
        final row = int.parse(parts[0]);
        final col = int.parse(parts[1]);
        grid[row][col] = FlowerBloc.randomFlowerId();
      }
    }
    currentScore = 0;
  }

  // Vérifier si les objectifs sont atteints
  bool checkObjectivesCompleted() {
    // Vérifier les points
    if (currentScore < widget.levelConfig.objective.points) {
      return false;
    }

    // Vérifier les fleurs si nécessaire
    if (widget.levelConfig.hasFlowerObjectives) {
      for (var entry in widget.levelConfig.objective.flowers!.entries) {
        if ((collectedFlowers[entry.key] ?? 0) < entry.value) {
          return false;
        }
      }
    }

    return true;
  }

  // Vérifier si le joueur a perdu (plus de mouvements)
  bool checkGameOver() {
    if (movesRemaining != null && movesRemaining! <= 0) {
      return !checkObjectivesCompleted();
    }
    return false;
  }

  // Sauvegarder la progression et donner les récompenses
  Future<void> _completeLevel() async {
    final levelId = 'level_${widget.levelConfig.id}';

    // Marquer le niveau comme complété
    await _userDataService.completeLevel(levelId);

    // Enregistrer le meilleur score
    await _userDataService.setBestScore(levelId, currentScore);

    // Calculer les récompenses (par exemple, proportionnelles au score)
    final currencyReward = (currentScore / 100).round();
    await _userDataService.addFloralCurrency(currencyReward);

    // Débloquer le bouquet correspondant
    await _userDataService.unlockBouquet('bouquet_${widget.levelConfig.bouquetId}');

    // Passer au niveau suivant si c'est le niveau actuel
    if (_userDataService.getCurrentLevel() == widget.levelConfig.id) {
      await _userDataService.nextLevel();
    }
  }

  // Gérer le début du déplacement
  void onDragStart(int row, int col) {
    if (isAnimating) return;
    if (checkGameOver()) return;
    dragStartRow = row;
    dragStartCol = col;
  }

  // Gérer la fin du déplacement
  void onDragEnd(int row, int col, DragEndDetails details) {
    if (isAnimating || dragStartRow == null || dragStartCol == null) return;
    if (checkGameOver()) return;

    // Calculer la direction du déplacement
    final dx = details.velocity.pixelsPerSecond.dx;
    final dy = details.velocity.pixelsPerSecond.dy;

    int targetRow = dragStartRow!;
    int targetCol = dragStartCol!;

    // Déterminer la direction dominante
    if (dx.abs() > dy.abs()) {
      if (dx > 0 && targetCol < gridSize - 1) {
        targetCol++;
      } else if (dx < 0 && targetCol > 0) {
        targetCol--;
      }
    } else {
      if (dy > 0 && targetRow < gridSize - 1) {
        targetRow++;
      } else if (dy < 0 && targetRow > 0) {
        targetRow--;
      }
    }

    // Vérifier si on a bougé et échanger
    if (targetRow != dragStartRow || targetCol != dragStartCol) {
      swapBlocs(dragStartRow!, dragStartCol!, targetRow, targetCol);
    }

    dragStartRow = null;
    dragStartCol = null;
  }

  // Échanger deux blocs
  void swapBlocs(int row1, int col1, int row2, int col2) {
    isAnimating = true;

    setState(() {
      swappingBlocs.add('$row1,$col1');
      swappingBlocs.add('$row2,$col2');
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        final temp = grid[row1][col1];
        grid[row1][col1] = grid[row2][col2];
        grid[row2][col2] = temp;

        final tempKey = blocKeys[row1][col1];
        blocKeys[row1][col1] = blocKeys[row2][col2];
        blocKeys[row2][col2] = tempKey;
      });
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        swappingBlocs.clear();
      });

      if (!hasMatchAt(row1, col1) && !hasMatchAt(row2, col2)) {
        // Pas de match - annuler l'échange
        setState(() {
          swappingBlocs.add('$row1,$col1');
          swappingBlocs.add('$row2,$col2');
        });

        Future.delayed(const Duration(milliseconds: 50), () {
          setState(() {
            final temp = grid[row1][col1];
            grid[row1][col1] = grid[row2][col2];
            grid[row2][col2] = temp;

            final tempKey = blocKeys[row1][col1];
            blocKeys[row1][col1] = blocKeys[row2][col2];
            blocKeys[row2][col2] = tempKey;
          });
        });

        Future.delayed(const Duration(milliseconds: 400), () {
          setState(() {
            swappingBlocs.clear();
          });
          isAnimating = false;
        });
      } else {
        // Décrémenter les mouvements seulement si le swap est valide
        if (movesRemaining != null) {
          setState(() {
            movesRemaining = movesRemaining! - 1;
          });
        }
        processMatches();
      }
    });
  }

  // Vérifier s'il y a un match à une position donnée
  bool hasMatchAt(int row, int col) {
    final flowerId = grid[row][col];

    // Vérifier horizontalement
    int countHorizontal = 1;
    for (int c = col - 1; c >= 0 && grid[row][c] == flowerId; c--) {
      countHorizontal++;
    }
    for (int c = col + 1; c < gridSize && grid[row][c] == flowerId; c++) {
      countHorizontal++;
    }
    if (countHorizontal >= 3) return true;

    // Vérifier verticalement
    int countVertical = 1;
    for (int r = row - 1; r >= 0 && grid[r][col] == flowerId; r--) {
      countVertical++;
    }
    for (int r = row + 1; r < gridSize && grid[r][col] == flowerId; r++) {
      countVertical++;
    }
    if (countVertical >= 3) return true;

    return false;
  }

  // Trouver tous les matches dans la grille
  Set<String> findAllMatches() {
    Set<String> matches = {};
    Map<String, int> tempFlowerCount = {};

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final flowerId = grid[row][col];

        // Vérifier horizontalement
        int countH = 1;
        for (int c = col + 1; c < gridSize && grid[row][c] == flowerId; c++) {
          countH++;
        }
        if (countH >= 3) {
          for (int c = col; c < col + countH; c++) {
            final pos = '$row,$c';
            if (!matches.contains(pos)) {
              matches.add(pos);
              tempFlowerCount[flowerId] = (tempFlowerCount[flowerId] ?? 0) + 1;
            }
          }
          // Points bonus
          if (countH >= 5) {
            currentScore += 500;
          } else if (countH >= 4) {
            currentScore += 250;
          } else {
            currentScore += 100;
          }
        }

        // Vérifier verticalement
        int countV = 1;
        for (int r = row + 1; r < gridSize && grid[r][col] == flowerId; r++) {
          countV++;
        }
        if (countV >= 3) {
          for (int r = row; r < row + countV; r++) {
            final pos = '$r,$col';
            if (!matches.contains(pos)) {
              matches.add(pos);
              tempFlowerCount[flowerId] = (tempFlowerCount[flowerId] ?? 0) + 1;
            }
          }
          // Points bonus
          if (countV >= 5) {
            currentScore += 500;
          } else if (countV >= 4) {
            currentScore += 250;
          } else {
            currentScore += 100;
          }
        }
      }
    }

    // Mettre à jour le compteur de fleurs collectées
    tempFlowerCount.forEach((flower, count) {
      if (collectedFlowers.containsKey(flower)) {
        collectedFlowers[flower] = (collectedFlowers[flower] ?? 0) + count;
      }
    });

    return matches;
  }

  // Traiter les matches trouvés
  void processMatches() {
    final matches = findAllMatches();

    if (matches.isEmpty) {
      isAnimating = false;
      
      // Vérifier si le niveau est terminé
      if (checkObjectivesCompleted()) {
        _showEndLevelDialog(true);
      } else if (checkGameOver()) {
        _showEndLevelDialog(false);
      }
      return;
    }

    setState(() {
      disappearingBlocs = matches;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        List<List<String?>> tempGrid = List.generate(
          gridSize,
          (row) => List.generate(gridSize, (col) => grid[row][col]),
        );

        for (final match in matches) {
          final parts = match.split(',');
          final row = int.parse(parts[0]);
          final col = int.parse(parts[1]);
          tempGrid[row][col] = null;
        }

        disappearingBlocs.clear();

        for (int col = 0; col < gridSize; col++) {
          List<String> nonEmptyBlocs = [];
          List<UniqueKey> nonEmptyKeys = [];

          for (int row = gridSize - 1; row >= 0; row--) {
            if (tempGrid[row][col] != null) {
              nonEmptyBlocs.add(tempGrid[row][col]!);
              nonEmptyKeys.add(blocKeys[row][col]);
            }
          }

          int blocIndex = 0;
          for (int row = gridSize - 1; row >= 0; row--) {
            if (blocIndex < nonEmptyBlocs.length) {
              grid[row][col] = nonEmptyBlocs[blocIndex];
              blocKeys[row][col] = nonEmptyKeys[blocIndex];
              blocIndex++;
            } else {
              grid[row][col] = FlowerBloc.randomFlowerId();
              blocKeys[row][col] = UniqueKey();
            }
          }
        }
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (findAllMatches().isNotEmpty) {
          processMatches();
        } else {
          isAnimating = false;
          
          // Vérifier si le niveau est terminé
          if (checkObjectivesCompleted()) {
            _showEndLevelDialog(true);
          } else if (checkGameOver()) {
            _showEndLevelDialog(false);
          }
        }
      });
    });
  }

  // Afficher le dialogue de fin de niveau
  void _showEndLevelDialog(bool success) async {
    if (success) {
      await _completeLevel();
    }

    if (!mounted) return;

    // Calculer les récompenses
    final currencyReward = (currentScore / 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => PopupEndLevel(
        levelNumber: widget.levelConfig.id,
        success: success,
        finalScore: currentScore,
        recompenses: [
          "1",
          "assets/images/lily.webp",
          currencyReward.toString(),
          "assets/images/petal.webp",
        ],
        collectedFlowers: collectedFlowers,
        requiredFlowers: widget.levelConfig.objective.flowers,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarLevel(title: "Niveau ${widget.levelConfig.id}"),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Affichage des objectifs et mouvements
                _buildObjectivesDisplay(),
                const SizedBox(height: 10),
                
                // Grille de jeu
                AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, index) {
                      final row = index ~/ gridSize;
                      final col = index % gridSize;
                      final blocKey = '$row,$col';
                      final isSwapping = swappingBlocs.contains(blocKey);
                      final isDisappearing = disappearingBlocs.contains(blocKey);
                      
                      return AnimatedScale(
                        scale: isDisappearing ? 0.0 : (isSwapping ? 0.85 : 1.0),
                        duration: Duration(
                          milliseconds: isDisappearing ? 300 : 350,
                        ),
                        curve: isSwapping ? Curves.elasticOut : Curves.easeInOut,
                        child: AnimatedOpacity(
                          opacity: isDisappearing ? 0.0 : (isSwapping ? 0.6 : 1.0),
                          duration: Duration(
                            milliseconds: isDisappearing ? 300 : 350,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeOut,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: GestureDetector(
                              key: blocKeys[row][col],
                              onPanStart: (_) => onDragStart(row, col),
                              onPanEnd: (details) => onDragEnd(row, col, details),
                              child: FlowerBloc(
                                flowerId: grid[row][col],
                                onTap: null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                
                // Affichage du score
                Text(
                  '$currentScore',
                  style: const TextStyle(
                    fontSize: 48,
                    fontFamily: 'ChettaVissto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildObjectivesDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Mouvements restants
          if (movesRemaining != null)
            Text(
              'Coups: $movesRemaining',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          
          // Objectif de points
          Text(
            'Objectif: ${widget.levelConfig.objective.points}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          
          // Objectifs de fleurs
          if (widget.levelConfig.hasFlowerObjectives) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: widget.levelConfig.objective.flowers!.entries.map((entry) {
                final collected = collectedFlowers[entry.key] ?? 0;
                final required = entry.value;
                final isComplete = collected >= required;
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isComplete ? Colors.green : Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${entry.key}: $collected/$required',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}