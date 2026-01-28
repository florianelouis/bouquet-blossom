import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:bouquetblossom/services/user_data_service.dart';

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
            padding: const EdgeInsets.all(5),
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
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable:
                            UserDataService().floralCurrencyNotifier,
                        builder: (context, value, child) {
                          return Text(
                            "$value",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          );
                        },
                      ),

                      const Padding(padding: EdgeInsets.only(right: 5)),
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          'assets/images/petal.webp',
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.black,
                            );
                          },
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
