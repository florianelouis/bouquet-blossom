import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/widgets/buttons_home_page.dart';

class AssetsHome extends StatefulWidget {
  const AssetsHome({super.key});

  @override
  State<AssetsHome> createState() => _AssetsHomeState();
}

class _AssetsHomeState extends State<AssetsHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.sakuraPink, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              // TODO: État actuel du bouquet à afficher ici
              child: Center(
                child: Image.asset(
                  'assets/images/bouquets/bouquet1-4.webp',
                  fit: BoxFit.contain,
                  cacheWidth: 600,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading bouquet: $error');
                    return const Icon(
                      Icons.local_florist,
                      size: 100,
                      color: AppColors.sakuraPink,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const ButtonsHomePage(),
      ],
    );
  }
}
