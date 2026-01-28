import 'dart:convert';
import 'package:flutter/services.dart';

class LevelObjective {
  final int points;
  final Map<String, int>? flowers;

  LevelObjective({
    required this.points,
    this.flowers,
  });

  factory LevelObjective.fromJson(Map<String, dynamic> json) {
    return LevelObjective(
      points: json['points'] as int,
      flowers: json['flowers'] != null
          ? Map<String, int>.from(json['flowers'])
          : null,
    );
  }
}

class LevelConfig {
  final int id;
  final int bouquetId;
  final int moves; // -1 = illimité
  final LevelObjective objective;

  LevelConfig({
    required this.id,
    required this.bouquetId,
    required this.moves,
    required this.objective,
  });

  factory LevelConfig.fromJson(Map<String, dynamic> json) {
    return LevelConfig(
      id: json['id'] as int,
      bouquetId: json['bouquet_id'] as int,
      moves: json['moves'] as int,
      objective: LevelObjective.fromJson(json['objective']),
    );
  }

  bool get hasUnlimitedMoves => moves == -1;
  
  bool get hasFlowerObjectives => objective.flowers != null && objective.flowers!.isNotEmpty;
}

class LevelsService {
  // Singleton pattern
  static final LevelsService _instance = LevelsService._internal();
  factory LevelsService() => _instance;
  LevelsService._internal();

  List<LevelConfig>? _levels;

  // Charger les niveaux depuis le JSON
  Future<void> loadLevels() async {
    if (_levels != null) return; // Déjà chargé

    try {
      final String jsonString = await rootBundle.loadString('assets/data/levels.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> levelsJson = jsonData['levels'];
      
      _levels = levelsJson.map((json) => LevelConfig.fromJson(json)).toList();
    } catch (e) {
      print('Error loading levels: $e');
      _levels = [];
    }
  }

  // Récupérer un niveau par son ID
  LevelConfig? getLevelConfig(int levelId) {
    if (_levels == null) return null;
    try {
      return _levels!.firstWhere((level) => level.id == levelId);
    } catch (e) {
      return null;
    }
  }

  // Récupérer tous les niveaux
  List<LevelConfig> getAllLevels() {
    return _levels ?? [];
  }

  // Récupérer le nombre total de niveaux
  int getTotalLevels() {
    return _levels?.length ?? 0;
  }
  
  // Récupérer tous les niveaux d'un bouquet
  List<LevelConfig> getLevelsByBouquet(int bouquetId) {
    if (_levels == null) return [];
    return _levels!.where((level) => level.bouquetId == bouquetId).toList();
  }
}