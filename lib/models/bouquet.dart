class Bouquet {
  final int id;
  final int stems;
  final Map<String, String> images;
  final Map<String, String> flowers;

  Bouquet({
    required this.id,
    required this.stems,
    required this.images,
    required this.flowers,
  });

  // Obtenir l'image complète du bouquet (la dernière image)
  String get fullImage {
    return images[stems.toString()] ?? '';
  }

  factory Bouquet.fromJson(Map<String, dynamic> json) {
    return Bouquet(
      id: json['id'] as int,
      stems: json['stems'] as int,
      images: Map<String, String>.from(json['images'] as Map),
      flowers: Map<String, String>.from(json['flowers'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stems': stems,
      'images': images,
      'flowers': flowers,
    };
  }
}
