import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1000,
        width: 1000,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Bouquet Blossom',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'ChettaVissto',
                  // Fallback fonts in case the custom font doesn't contain the glyphs
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
