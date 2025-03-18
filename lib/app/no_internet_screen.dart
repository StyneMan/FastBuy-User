import 'package:customer/controllers/splash_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:provider/provider.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SplashController>(builder: (controller) {
      return LoadingOverlayPro(
        isLoading: controller.isRetrying.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.grey,
        child: Scaffold(
          backgroundColor: AppThemeData.bgcolor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.wifi_slash,
                size: 48,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "Check your internet connection!".tr,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey200
                      : AppThemeData.grey700,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Center(
                child: SizedBox(
                  width: 128,
                  child: RoundedButtonFill(
                    title: "Try again".tr,
                    height: 5.0,
                    width: 128,
                    color: AppThemeData.primary300,
                    textColor: AppThemeData.grey50,
                    fontSizes: 16,
                    onPress: () async {
                      controller.retry();
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              controller.isRetrying.value
                  ? const LinearProgressIndicator()
                  : const SizedBox(),
            ],
          ),
        ),
      );
    });
  }
}
