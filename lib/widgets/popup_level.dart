import 'package:flutter/material.dart';

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
    return Container(
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
                Row(children: [
                  Text(recompenses[0]),
                  Image(image:AssetImage(recompenses[1])),
                  Text(recompenses[2]),
                  Image(image:AssetImage(recompenses[3])),
                ]),
              ]
            ),
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.hovered))
                    return Colors.blue.withOpacity(0.04);
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Colors.blue.withOpacity(0.12);
                  return null; // Defer to the widget's default.
                }),
              ),
              onPressed: () {},
              child: Text('Jouer'),
            ),
        ],
      ),
    );
  }
}
