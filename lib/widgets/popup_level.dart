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
        width: 400,
        height: 250,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3950AE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: SizedBox(
              width: 400,
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Niveau $levelNumber",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          decoration: TextDecoration.none,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF23357C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text(
                              "Récompenses",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  recompenses[0],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(
                                  height: 40, // Ajustez selon vos besoins
                                  width: 40,
                                  child: Image.asset(
                                    recompenses[1],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text(
                                  recompenses[2],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(
                                  height: 40, // Ajustez selon vos besoins
                                  width: 40,
                                  child: Image.asset(
                                    recompenses[3],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sakuraPink,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Game(),
                            ),
                          );
                        },
                        child: Text(
                          'Jouer',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
