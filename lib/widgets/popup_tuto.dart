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
    return Dialog(
      child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3950AE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center( 
        child: SizedBox(
        width: 362,
        height: 246,
        child: Padding(padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                popupTitle,
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
              child: 
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    popupText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      
      ),

    ))));
  }
}
