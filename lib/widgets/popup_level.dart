import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/screen/assets/game.dart';

class PopupLevel extends StatelessWidget {
  final int levelNumber;
  final List<String> recompenses;
  const PopupLevel({
    super.key,
    required this.levelNumber,
    required this.recompenses,
  }); // Comme MainApp provient de StatelessWidget on doit la crée avec le super

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 362,
        height: 246,
        child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF99B3E7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text("Niveau $levelNumber"),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3950AE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text("Récompenses"),
                Row(
                  children: [
                    Text(recompenses[0]),
                    Image.asset(recompenses[1]),
                    Text(recompenses[2]),
                    Image.asset(recompenses[3]),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sakuraPink,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Game()),
              );
            },
            child: Text('Jouer', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    )
    )
    );
  }
}
