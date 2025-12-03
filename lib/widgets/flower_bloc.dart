import 'package:flutter/material.dart';

class FlowerBloc extends StatelessWidget {
  final String srcImg;
  final Color color;
  const FlowerBloc({
    super.key,
    required this.srcImg,
    required this.color,
  }); // Comme MainApp provient de StatelessWidget on doit la crée avec le super

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(srcImg),
    );
  }
}
