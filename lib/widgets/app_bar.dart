import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Padding(
            padding: EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 30,
                  minHeight: 40,
                  maxWidth: 150,
                  maxHeight: 40,
                ),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "/assets/images/petal.webp"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
