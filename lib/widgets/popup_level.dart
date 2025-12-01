import 'package:flutter/material.dart';

class PopupLevel extends StatelessWidget {
  final int levelNumber;
  final String recompenses;
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
        borderRadius: BorderRadius.circular(20)
      ), 
      child: Column(
        children: [
        Text(popupTitle), 
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3950AE),                 
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(popupText),
        )
      ])
    );
  }
}
