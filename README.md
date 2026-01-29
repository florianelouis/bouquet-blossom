# Bouquet Blossom 🌸

Un jeu mobile de type tile-matching floral développé avec Flutter où vous collectez des fleurs pour créer de magnifiques bouquets.

## 📋 Table des matières

- [À propos](#à-propos)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Configuration](#configuration)
- [Lancement de l'application](#lancement-de-lapplication)
- [Comment jouer](#comment-jouer)
- [Structure du projet](#structure-du-projet)
- [Dépendances](#dépendances)

## 🌺 À propos

Bouquet Blossom est un jeu mobile de type tile-matching où vous alignez des fleurs pour créer des bouquets. Le jeu propose :

- Un système de tile-matching avec grille 8x8
- Une collection de fleurs à débloquer
- Des bouquets à compléter
- Un système de monnaie florale (pétales)
- De la musique d'ambiance
- Un tutoriel intégré

## 🔧 Prérequis

Avant de commencer, assurez-vous d'avoir installé :

- **Flutter SDK** (version 3.9.2 ou supérieure)
  - [Guide d'installation Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (inclus avec Flutter)
- Un IDE au choix :
  - **Android Studio** avec les plugins Flutter et Dart
  - **Visual Studio Code** avec l'extension Flutter
  - **IntelliJ IDEA** avec les plugins Flutter et Dart
- Pour tester sur mobile :
  - **Android Studio** pour émulateur Android, ou un appareil Android en mode développeur

## 📥 Installation

### 1. Cloner le projet

```bash
git clone https://github.com/florianelouis/bouquet-blossom
cd bouquetblossom
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Vérifier l'installation

```bash
flutter doctor
```

Cette commande vérifie votre environnement et affiche un rapport des outils installés. Résolvez les problèmes signalés avant de continuer.

## ⚙️ Configuration

### Assets requis

Assurez-vous que les dossiers suivants contiennent les fichiers nécessaires :

```
assets/
├── images/
│   ├── logo.png
│   ├── background.webp
│   ├── water.webp
│   ├── petal.webp
│   ├── sakura.webp
│   ├── lily.webp
│   └── bouquets/
│       └── bouquet1-4.webp
├── audio/
│   └── music.mp3
└── data/
    ├── flowers.json
    └── bouquets.json
```

### Fichiers de données

#### `assets/data/flowers.json`

Exemple de structure :

```json
{
  "flowers": [
    {
      "id": "sakura",
      "name": "Sakura",
      "imagePath": "assets/images/sakura.webp",
      "blockColor": "#F69AA5",
      "description": "La fleur de cerisier japonaise...",
      "blossomSeason": "Printemps"
    }
  ]
}
```

#### `assets/data/bouquets.json`

Exemple de structure :

```json
{
  "bouquets": [
    {
      "id": 1,
      "stems": 4,
      "images": {
        "1": "assets/images/bouquets/bouquet1-1.webp",
        "4": "assets/images/bouquets/bouquet1-4.webp"
      },
      "flowers": {
        "1": "sakura"
      }
    }
  ]
}
```

## 🚀 Lancement de l'application

### Sur émulateur/simulateur

1. Démarrez un émulateur Android

2. Lancez l'application :

```bash
flutter run
```

### Sur appareil physique

1. Connectez votre appareil en USB

2. Activez le mode développeur et le débogage USB (Android)

3. Vérifiez que l'appareil est détecté :

```bash
flutter devices
```

4. Lancez l'application :

```bash
flutter run
```

### Mode release (production)

Pour une version optimisée :

```bash
flutter run --release
```

### Compiler l'APK (Android)

```bash
flutter build apk --release
```
L'APK se trouvera dans `build/app/outputs/flutter-apk/`


## 🎮 Comment jouer

### Écran d'accueil

1. **Bouquet actuel** : Affiche votre progression actuelle
2. **Niveau** : Cliquez pour voir les récompenses et démarrer une partie
3. **Bouton Fleurs** : Ajoutez des fleurs à votre bouquet
4. **Bouton Arrosoir** : Arrosez vos fleurs pour gagner 100 pétales (disponible toutes les 10 secondes)

### Jeu

1. **Glissez** une fleur vers une case adjacente (haut, bas, gauche, droite)
2. **Alignez** 3 fleurs identiques ou plus pour les faire disparaître
3. **Gagnez des points** :
   - 3 fleurs alignées : 100 points
   - 4 fleurs alignées : 250 points
   - 5 fleurs alignées ou plus : 500 points

### Collections

- **Onglet Bouquets** : Consultez tous les bouquets disponibles
- **Onglet Fleurs** : Découvrez toutes les fleurs et leurs informations (cliquez sur une fleur débloquée)

## 📁 Structure du projet

```
lib/
├── constants/
│   └── app_colors.dart          # Palette de couleurs
├── models/
│   ├── flower.dart              # Modèle de données Fleur
│   └── bouquet.dart             # Modèle de données Bouquet
├── screen/
│   └── assets/
│       ├── welcome_page.dart    # Écran d'accueil
│       ├── home_page.dart       # Page principale avec navigation
│       ├── home.dart            # Vue d'accueil
│       ├── game.dart            # Écran de jeu Match-3
│       └── collections.dart     # Collections de fleurs et bouquets
├── services/
│   ├── flowers_service.dart     # Gestion des fleurs
│   ├── bouquets_service.dart    # Gestion des bouquets
│   └── user_data_service.dart   # Gestion des données utilisateur
├── widgets/
│   ├── app_bar.dart             # Barre d'application personnalisée
│   ├── bottom_nav_bar.dart      # Barre de navigation inférieure
│   ├── flower_bloc.dart         # Widget bloc de fleur (jeu)
│   ├── flower_card.dart         # Carte de fleur (collection)
│   ├── bouquet_card.dart        # Carte de bouquet
│   ├── buttons_home_page.dart   # Boutons de la page d'accueil
│   ├── popup_level.dart         # Popup d'information de niveau
│   ├── popup_tuto.dart          # Popup de tutoriel
│   └── popup_flower.dart        # Popup de détails de fleur
└── main.dart                    # Point d'entrée de l'application
```

## 📦 Dépendances

### Dépendances principales

- **flutter** : Framework de développement
- **google_fonts** (^7.0.2) : Polices Google (Manrope)
- **audioplayers** (^6.1.0) : Lecture audio pour la musique de fond
- **shared_preferences** (^2.3.3) : Stockage local des données utilisateur
- **timer_button** (^2.3.3) : Boutons avec timer


## 🎨 Polices personnalisées

Le projet utilise la police **ChettaVissto** pour certains titres. Assurez-vous que le fichier `fonts/ChettaVissto.ttf` est présent.

## 🐛 Résolution de problèmes

### Les images ne s'affichent pas

- Vérifiez que tous les fichiers sont présents dans le dossier `assets/`
- Relancez `flutter pub get`
- Effectuez un "hot restart" (R dans le terminal)

### La musique ne joue pas

- Vérifiez que `assets/audio/music.mp3` existe
- Testez sur un appareil physique (certains émulateurs ont des problèmes audio)

### Erreur de build

```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Licence

Ce projet est un projet éducatif, réalisé dans le cadre du BUT MMI de l'IUT de Laval.
Ressource : R507 - Dispositifs Interactifs

Lien de la présentation du 29/01/2026 : https://www.figma.com/slides/JjCzYETM8JeBewht6OqJNQ/Pr%C3%A9sentation-Bouquet-Blossom?node-id=5-6&t=kZOm07PXlq4DIHvD-1
