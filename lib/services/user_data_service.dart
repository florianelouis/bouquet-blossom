import 'package:shared_preferences/shared_preferences.dart';

// Service pour gérer les données de l'utilisateur
class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  SharedPreferences? _prefs;

  // Clés pour SharedPreferences
  static const String _keyCurrentLevel = 'current_level';
  static const String _keyFloralCurrency = 'floral_currency';
  static const String _keyUnlockedBouquets = 'unlocked_bouquets';
  static const String _keyCompletedLevels = 'completed_levels';
  static const String _keyBestScores = 'best_scores';
  static const String _keyTutorialCompleted = 'tutorial_completed';

  // Initialiser SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // NIVEAU ACTUEL
  
  // Récupérer le niveau actuel
  int getCurrentLevel() {
    return _prefs?.getInt(_keyCurrentLevel) ?? 1;
  }

  // Définir le niveau actuel
  Future<void> setCurrentLevel(int level) async {
    await _prefs?.setInt(_keyCurrentLevel, level);
  }

  // Passer au niveau suivant
  Future<void> nextLevel() async {
    final currentLevel = getCurrentLevel();
    await setCurrentLevel(currentLevel + 1);
  }

  // MONNAIE FLORALE
  
  // Récupérer la monnaie florale
  int getFloralCurrency() {
    return _prefs?.getInt(_keyFloralCurrency) ?? 0;
  }

  // Définir la monnaie florale
  Future<void> setFloralCurrency(int amount) async {
    await _prefs?.setInt(_keyFloralCurrency, amount);
  }

  // Ajouter de la monnaie florale
  Future<void> addFloralCurrency(int amount) async {
    final current = getFloralCurrency();
    await setFloralCurrency(current + amount);
  }

  // Retirer de la monnaie florale
  Future<bool> removeFloralCurrency(int amount) async {
    final current = getFloralCurrency();
    if (current >= amount) {
      await setFloralCurrency(current - amount);
      return true;
    }
    return false;
  }

  // BOUQUETS DÉBLOQUÉS
  
  // Récupérer la liste des bouquets débloqués (IDs)
  List<String> getUnlockedBouquets() {
    return _prefs?.getStringList(_keyUnlockedBouquets) ?? [];
  }

  // Débloquer un bouquet
  Future<void> unlockBouquet(String bouquetId) async {
    final unlocked = getUnlockedBouquets();
    if (!unlocked.contains(bouquetId)) {
      unlocked.add(bouquetId);
      await _prefs?.setStringList(_keyUnlockedBouquets, unlocked);
    }
  }

  // Vérifier si un bouquet est débloqué
  bool isBouquetUnlocked(String bouquetId) {
    return getUnlockedBouquets().contains(bouquetId);
  }

  // NIVEAUX COMPLÉTÉS
  
  // Récupérer la liste des niveaux complétés
  List<String> getCompletedLevels() {
    return _prefs?.getStringList(_keyCompletedLevels) ?? [];
  }

  // Marquer un niveau comme complété
  Future<void> completeLevel(String levelId) async {
    final completed = getCompletedLevels();
    if (!completed.contains(levelId)) {
      completed.add(levelId);
      await _prefs?.setStringList(_keyCompletedLevels, completed);
    }
  }

  // Vérifier si un niveau est complété
  bool isLevelCompleted(String levelId) {
    return getCompletedLevels().contains(levelId);
  }

  // MEILLEURS SCORES
  
  // Récupérer le meilleur score d'un niveau
  int getBestScore(String levelId) {
    final scores = _prefs?.getString(_keyBestScores);
    if (scores == null) return 0;
    
    final scoresMap = Map<String, int>.from(
      scores.split(',').fold<Map<String, int>>({}, (map, entry) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          map[parts[0]] = int.tryParse(parts[1]) ?? 0;
        }
        return map;
      })
    );
    
    return scoresMap[levelId] ?? 0;
  }

  // Définir le meilleur score d'un niveau
  Future<void> setBestScore(String levelId, int score) async {
    final currentBest = getBestScore(levelId);
    if (score > currentBest) {
      final scores = _prefs?.getString(_keyBestScores) ?? '';
      final scoresMap = Map<String, int>.from(
        scores.isEmpty ? {} : scores.split(',').fold<Map<String, int>>({}, (map, entry) {
          final parts = entry.split(':');
          if (parts.length == 2) {
            map[parts[0]] = int.tryParse(parts[1]) ?? 0;
          }
          return map;
        })
      );
      
      scoresMap[levelId] = score;
      final newScores = scoresMap.entries.map((e) => '${e.key}:${e.value}').join(',');
      await _prefs?.setString(_keyBestScores, newScores);
    }
  }

  // TUTORIEL
  
  // Vérifier si le tutoriel a été complété
  bool isTutorialCompleted() {
    return _prefs?.getBool(_keyTutorialCompleted) ?? false;
  }

  // Marquer le tutoriel comme complété
  Future<void> completeTutorial() async {
    await _prefs?.setBool(_keyTutorialCompleted, true);
  }

  // RÉINITIALISATION
  
  // Réinitialiser toutes les données de l'utilisateur
  Future<void> resetAllData() async {
    await _prefs?.clear();
  }

  // Réinitialiser uniquement la progression
  Future<void> resetProgress() async {
    await setCurrentLevel(1);
    await _prefs?.remove(_keyCompletedLevels);
    await _prefs?.remove(_keyBestScores);
  }
}
