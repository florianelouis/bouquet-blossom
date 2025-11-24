import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        // Use a background image from assets
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Image.asset('assets/images/logo.png', width: 450, height: 450),
              const SizedBox(height: 24),
              // Bouton "Jouer"
              ElevatedButton(
                onPressed: () {
                  // Action à effectuer lors du clic sur le bouton
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  textStyle: const TextStyle(fontSize: 50, fontFamily: 'ChettaVissto'),
                  backgroundColor: AppColors.sakuraPink,
                  foregroundColor: AppColors.whitePink,
                  side: const BorderSide(color: AppColors.white, width: 2),
                ),
                child: const Text('Jouer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
