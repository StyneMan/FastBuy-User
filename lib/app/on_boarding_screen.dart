import 'package:customer/app/auth_screen/login_screen.dart';
import 'package:customer/controllers/on_boarding_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: controller.selectedPageIndex.value == 0
              ? AppThemeData.warning50
              : controller.selectedPageIndex.value == 1
                  ? Colors.white
                  : AppThemeData.primary50,
          body: Container(
            decoration: BoxDecoration(
              color: controller.selectedPageIndex.value == 0
                  ? AppThemeData.warning50
                  : controller.selectedPageIndex.value == 1
                      ? Colors.white
                      : AppThemeData.primary50,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: (value) {
                          controller.selectedPageIndex.value = value;

                          if (value == 0) {
                            controller.percentage.value = 0.40;
                          } else if (value == 1) {
                            controller.percentage.value = 0.75;
                          } else {
                            controller.percentage.value = 1.0;
                          }
                        },
                        itemCount: controller.onBoardingList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 256,
                                    height: 256,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(243, 242, 241, 0.812),
                                          Color(0x00FCEFE5),
                                        ],
                                        stops: [0.6, 1],
                                        begin: Alignment.topCenter,
                                      ),
                                    ),
                                    child: Image.asset(
                                      controller.selectedPageIndex.value == 0
                                          ? "assets/images/restaurant.png"
                                          : controller.selectedPageIndex
                                                      .value ==
                                                  1
                                              ? "assets/images/grocery.png"
                                              : "assets/images/dispatch.png",
                                      width: 86,
                                      height: 86,
                                    ),
                                  ),
                                ),
                                // Text(
                                //   "FastBuy".tr,
                                //   style: TextStyle(
                                //     color: themeChange.getThem()
                                //         ? AppThemeData.grey50
                                //         : AppThemeData.grey50,
                                //     fontSize: 32,
                                //     fontFamily: AppThemeData.bold,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 256,
                                  child: Text(
                                    controller.onBoardingList[index].title
                                        .toString()
                                        .tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey300
                                          : AppThemeData.secondary400,
                                      fontSize: 24,
                                      fontFamily: AppThemeData.bold,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    controller.onBoardingList[index].description
                                        .toString()
                                        .tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.secondary400
                                          : AppThemeData.secondary400,
                                      fontSize: 16,
                                      fontFamily: AppThemeData.regular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),
                controller.selectedPageIndex.value == 2
                    ? Center(
                        child: SizedBox(
                          child: RoundedButtonFill(
                            title: "Get Started".tr,
                            width: double.infinity,
                            color: AppThemeData.secondary400,
                            textColor: AppThemeData.grey50,
                            onPress: () {
                              if (controller.selectedPageIndex.value == 2) {
                                Preferences.setBoolean(
                                    Preferences.isFinishOnBoardingKey, true);
                                Get.offAll(LoginScreen());
                              } else {
                                controller.pageController.jumpToPage(
                                    controller.selectedPageIndex.value + 1);
                              }
                            },
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(
                                  3,
                                  (index) => buildDot(
                                      controller: controller,
                                      context: context,
                                      index: index),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Preferences.setBoolean(
                                      Preferences.isFinishOnBoardingKey, true);
                                  Get.offAll(LoginScreen());
                                },
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: AppThemeData.secondary500,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 55,
                                  height: 55,
                                  child: CircularProgressIndicator(
                                    value: controller.percentage.value,
                                    backgroundColor: Colors.white38,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      AppThemeData.primary100,
                                    ),
                                  ),
                                ),
                                const CircleAvatar(
                                  backgroundColor: AppThemeData.secondary400,
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: AppThemeData.primary50,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {
                              if (controller.selectedPageIndex.value == 2) {
                                Preferences.setBoolean(
                                    Preferences.isFinishOnBoardingKey, true);
                                Get.offAll(LoginScreen());
                              } else {
                                controller.pageController.jumpToPage(
                                    controller.selectedPageIndex.value + 1);
                              }
                            },
                          )
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  AnimatedContainer buildDot({
    required OnBoardingController controller,
    required BuildContext context,
    required int index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 8.0,
      width: controller.selectedPageIndex.value == index ? 24 : 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: controller.selectedPageIndex.value == index
            ? AppThemeData.primary300
            : Colors.grey.shade300,
      ),
    );
  }
}
