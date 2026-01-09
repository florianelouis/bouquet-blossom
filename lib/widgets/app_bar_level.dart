import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBarLevel extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBarLevel({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      toolbarTextStyle: const TextStyle(fontFamily: 'Manrope'),
      backgroundColor: AppColors.sakuraPink,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
