import 'package:flutter/material.dart';

class PopupTuto extends StatelessWidget {
  final String popupTitle;
  final String popupText;
  const PopupTuto({
    super.key,
    required this.popupTitle,
    required this.popupText,
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
