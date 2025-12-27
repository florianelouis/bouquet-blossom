import 'package:flutter/material.dart';
import 'package:bouquetblossom/widgets/app_bar.dart';
import 'package:bouquetblossom/widgets/flower_bloc.dart';
import 'package:audioplayers/audioplayers.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  // Taille de la grille
  final int gridSize = 8;

  // Liste pour stocker les types de fleurs dans la grille
  List<List<FlowerType>> grid = [];

  // Identifiants uniques pour chaque bloc (pour les animations)
  List<List<UniqueKey>> blocKeys = [];

  // Animation en cours
  bool isAnimating = false;

  // Position de départ du drag
  int? dragStartRow;
  int? dragStartCol;
  
  // Blocs en cours de swap
  Set<String> swappingBlocs = {};
  
  // Blocs en cours de suppression
  Set<String> disappearingBlocs = {};
  
  // Lecteur audio pour la musique de fond
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Initialiser la grille avec des fleurs aléatoires
    initializeGrid();
    // Lancer la musique de fond en boucle
    _playBackgroundMusic();
  }
  
  // Jouer la musique de fond
  Future<void> _playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/music.mp3'));
  }
  
  @override
  void dispose() {
    // Arrêter et libérer le lecteur audio
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Initialiser la grille avec des fleurs aléatoires
  void initializeGrid() {
    // Générer la grille initiale
    grid = List.generate(
      gridSize,
      (row) => List.generate(gridSize, (col) => FlowerBloc.randomType()),
    );
    blocKeys = List.generate(
      gridSize,
      (row) => List.generate(gridSize, (col) => UniqueKey()),
    );
    
    // Supprimer les matches initiaux jusqu'à ce qu'il n'y en ait plus --> match = 3 mêmes fleurs ou plus alignées
    while (findAllMatches().isNotEmpty) {
      final matches = findAllMatches();
      for (final match in matches) {
        final parts = match.split(',');
        final row = int.parse(parts[0]);
        final col = int.parse(parts[1]);
        // Remplacer les matches par de nouvelles fleurs
        grid[row][col] = FlowerBloc.randomType();
      }
    }
  }

  // Gérer le début du déplacement
  void onDragStart(int row, int col) {
    if (isAnimating) return;
    dragStartRow = row;
    dragStartCol = col;
  }

  // Gérer la fin du déplacement
  void onDragEnd(int row, int col, DragEndDetails details) {
    if (isAnimating || dragStartRow == null || dragStartCol == null) return;

    // Calculer la direction du déplacement
    final dx = details.velocity.pixelsPerSecond.dx;
    final dy = details.velocity.pixelsPerSecond.dy;

    int targetRow = dragStartRow!;
    int targetCol = dragStartCol!;

    // Déterminer la direction dominante
    if (dx.abs() > dy.abs()) {
      // Mouvement horizontal
      if (dx > 0 && targetCol < gridSize - 1) {
        targetCol++; // Droite
      } else if (dx < 0 && targetCol > 0) {
        targetCol--; // Gauche
      }
    } else {
      // Mouvement vertical
      if (dy > 0 && targetRow < gridSize - 1) {
        targetRow++; // Bas
      } else if (dy < 0 && targetRow > 0) {
        targetRow--; // Haut
      }
    }

    // Vérifier si on a bougé et échanger
    if (targetRow != dragStartRow || targetCol != dragStartCol) {
      swapBlocs(dragStartRow!, dragStartCol!, targetRow, targetCol);
    }

    dragStartRow = null;
    dragStartCol = null;
  }

  // Vérifier si deux blocs sont adjacents
  bool isAdjacent(int row1, int col1, int row2, int col2) {
    return (row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1);
  }

  // Échanger deux blocs
  void swapBlocs(int row1, int col1, int row2, int col2) {
    isAnimating = true;
    
    // Marquer les blocs comme étant en swap
    setState(() {
      swappingBlocs.add('$row1,$col1');
      swappingBlocs.add('$row2,$col2');
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        // Échanger les types
        final temp = grid[row1][col1];
        grid[row1][col1] = grid[row2][col2];
        grid[row2][col2] = temp;

        // Échanger les clés
        final tempKey = blocKeys[row1][col1];
        blocKeys[row1][col1] = blocKeys[row2][col2];
        blocKeys[row2][col2] = tempKey;
      });
    });

    // Vérifier s'il y a des matches après l'échange
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
        processMatches();
      }
    });
  }

  // Vérifier s'il y a un match à une position donnée
  bool hasMatchAt(int row, int col) {
    final type = grid[row][col];

    // Vérifier horizontalement
    int countHorizontal = 1;
    // Compter à gauche
    for (int c = col - 1; c >= 0 && grid[row][c] == type; c--) {
      countHorizontal++;
    }
    // Compter à droite
    for (int c = col + 1; c < gridSize && grid[row][c] == type; c++) {
      countHorizontal++;
    }
    if (countHorizontal >= 3) return true;

    // Vérifier verticalement
    int countVertical = 1;
    // Compter en haut
    for (int r = row - 1; r >= 0 && grid[r][col] == type; r--) {
      countVertical++;
    }
    // Compter en bas
    for (int r = row + 1; r < gridSize && grid[r][col] == type; r++) {
      countVertical++;
    }
    if (countVertical >= 3) return true;

    return false;
  }

  // Trouver tous les matches dans la grille
  Set<String> findAllMatches() {
    Set<String> matches = {};

    // Vérifier toutes les positions
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final type = grid[row][col];

        // Vérifier horizontalement
        int countH = 1;
        for (int c = col + 1; c < gridSize && grid[row][c] == type; c++) {
          countH++;
        }
        if (countH >= 3) {
          for (int c = col; c < col + countH; c++) {
            matches.add('$row,$c');
          }
        }

        // Vérifier verticalement
        int countV = 1;
        for (int r = row + 1; r < gridSize && grid[r][col] == type; r++) {
          countV++;
        }
        if (countV >= 3) {
          for (int r = row; r < row + countV; r++) {
            matches.add('$r,$col');
          }
        }
      }
    }

    return matches;
  }

  // Traiter les matches trouvés
  void processMatches() {
    final matches = findAllMatches();

    if (matches.isEmpty) {
      isAnimating = false;
      return;
    }

    // Marquer les blocs comme disparaissant
    setState(() {
      disappearingBlocs = matches;
    });

    // Attendre que l'animation de disparition se termine
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        // Supprimer les matches (marquer comme vides)
        List<List<FlowerType?>> tempGrid = List.generate(
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

        // Faire tomber les blocs
        for (int col = 0; col < gridSize; col++) {
          // Collecter tous les blocs non-null et leurs clés de la colonne (de bas en haut)
          List<FlowerType> nonEmptyBlocs = [];
          List<UniqueKey> nonEmptyKeys = [];

          for (int row = gridSize - 1; row >= 0; row--) {
            if (tempGrid[row][col] != null) {
              nonEmptyBlocs.add(tempGrid[row][col]!);
              nonEmptyKeys.add(blocKeys[row][col]);
            }
          }

          // Remplir la colonne de bas en haut
          int blocIndex = 0;
          for (int row = gridSize - 1; row >= 0; row--) {
            if (blocIndex < nonEmptyBlocs.length) {
              grid[row][col] = nonEmptyBlocs[blocIndex];
              blocKeys[row][col] = nonEmptyKeys[blocIndex];
              blocIndex++;
            } else {
              // Générer de nouveaux blocs en haut
              grid[row][col] = FlowerBloc.randomType();
              blocKeys[row][col] = UniqueKey();
            }
          }
        }
      });

      // Vérifier récursivement s'il y a d'autres matches
      Future.delayed(const Duration(milliseconds: 500), () {
        if (findAllMatches().isNotEmpty) {
          processMatches();
        } else {
          isAnimating = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Widget séparé pour l'app bar
      appBar: CustomAppBar(title: 'Niveau 1'),
      body: Container(
        constraints: const BoxConstraints.expand(),
        // Use a background image from assets
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
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
                    duration: Duration(milliseconds: isDisappearing ? 300 : 350),
                    curve: isSwapping ? Curves.elasticOut : Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: isDisappearing ? 0.0 : (isSwapping ? 0.6 : 1.0),
                      duration: Duration(milliseconds: isDisappearing ? 300 : 350),
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
                          child: FlowerBloc(type: grid[row][col], onTap: null),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
