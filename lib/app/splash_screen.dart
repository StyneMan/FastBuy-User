import 'package:customer/controllers/splash_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemeData.primary400,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo_white.png",
                  width: 75,
                  height: 75,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to".tr,
                      style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey50,
                          fontSize: 24,
                          fontFamily: AppThemeData.bold),
                    ),
                    const SizedBox(
                      width: 2.0,
                    ),
                    Text(
                      " FastBuy",
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.primary500
                            : AppThemeData.primary500,
                        fontSize: 24,
                        fontFamily: AppThemeData.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Your Orders & Packages Delivered Fast!".tr,
                  style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey50),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
