import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:bouquetblossom/models/bouquet.dart';

class BouquetsService {
  static final BouquetsService _instance = BouquetsService._internal();
  factory BouquetsService() => _instance;
  BouquetsService._internal();

  List<Bouquet> _bouquets = [];
  bool _isLoaded = false;

  // Charger les bouquets depuis le fichier JSON
  Future<void> loadBouquets() async {
    if (_isLoaded) return;

    try {
      debugPrint('🌸 Chargement des bouquets...');
      final String jsonString = await rootBundle.loadString('assets/data/bouquets.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _bouquets = (jsonData['bouquets'] as List)
          .map((bouquetJson) => Bouquet.fromJson(bouquetJson))
          .toList();
      
      _isLoaded = true;
      debugPrint('✅ ${_bouquets.length} bouquets chargés avec succès');
    } catch (e) {
      debugPrint('❌ Erreur lors du chargement des bouquets: $e');
      rethrow;
    }
  }

  // Récupérer tous les bouquets
  List<Bouquet> getAllBouquets() {
    debugPrint('📋 Récupération de ${_bouquets.length} bouquets (isLoaded: $_isLoaded)');
    return _bouquets;
  }

  // Récupérer un bouquet par son ID
  Bouquet? getBouquetById(int id) {
    try {
      return _bouquets.firstWhere((bouquet) => bouquet.id == id);
    } catch (e) {
      return null;
    }
  }
}
