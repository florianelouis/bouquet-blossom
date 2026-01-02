import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/flower.dart';

// Service pour charger et gérer les fleurs du jeu
class FlowersService {
  static final FlowersService _instance = FlowersService._internal();
  factory FlowersService() => _instance;
  FlowersService._internal();

  List<Flower>? _flowers;

  // On charge les fleurs depuis le fichier JSON
  Future<void> loadFlowers() async {
    if (_flowers != null) return; // Si déjà chargé, on ne recharge pas

    try {
      final String jsonString = await rootBundle.loadString('assets/data/flowers.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _flowers = (jsonData['flowers'] as List)
          .map((flowerJson) => Flower.fromJson(flowerJson))
          .toList();
    } catch (e) {
      print('Erreur lors du chargement des fleurs: $e');
      _flowers = [];
    }
  }

  // Récupérer toutes les fleurs
  List<Flower> getAllFlowers() {
    return _flowers ?? [];
  }

  // Récupérer une fleur par son ID
  Flower? getFlowerById(String id) {
    return _flowers?.firstWhere(
      (flower) => flower.id == id,
      orElse: () => throw Exception('Fleur non trouvée: $id'),
    );
  }

  // Récupérer plusieurs fleurs par leurs IDs
  List<Flower> getFlowersByIds(List<String> ids) {
    return ids
        .map((id) => getFlowerById(id))
        .whereType<Flower>()
        .toList();
  }

  // Vérifier si les fleurs sont chargées
  bool get isLoaded => _flowers != null;
}
