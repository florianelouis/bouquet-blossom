import 'package:flutter/material.dart';

// Modèle d'une fleur dans le jeu
class Flower {
  final String id;
  final String name;
  final String imagePath;
  final Color blockColor;
  final String description;
  final String blossomSeason;

  Flower({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.blockColor,
    required this.description,
    required this.blossomSeason,
  });

  // Créer une fleur depuis un fichier JSON
  factory Flower.fromJson(Map<String, dynamic> json) {
    return Flower(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      blockColor: _parseColor(json['blockColor']),
      description: json['description'] ?? '',
      blossomSeason: json['blossomSeason'] ?? '',
    );
  }

  // Convertir une fleur en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'blockColor': '#${blockColor.value.toRadixString(16).substring(2).toUpperCase()}',
      'description': description,
      'blossomSeason': blossomSeason,
    };
  }

  // Récupérer la couleur depuis une chaîne hexadécimale
  static Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Ajouter l'alpha
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
