import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/dash_board_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:iconify_flutter_plus/iconify_flutter_plus.dart'; // For Iconify Widget
// for Non Colorful Icons
// import 'package:colorful_iconify_flutter_plus/icons/emojione.dart'; // for Colorful Icons

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DashBoardController(),
        builder: (controller) {
          return PopScope(
            canPop: controller.canPopNow.value,
            onPopInvoked: (didPop) {
              final now = DateTime.now();
              if (controller.currentBackPressTime == null ||
                  now.difference(controller.currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                controller.currentBackPressTime = now;
                controller.canPopNow.value = false;
                ShowToastDialog.showToast("Double press to exit");
                return;
              } else {
                controller.canPopNow.value = true;
              }
            },
            // onPopInvokedWithResult: (didPop, dynamic) {
            //   final now = DateTime.now();
            //   if (controller.currentBackPressTime == null || now.difference(controller.currentBackPressTime!) > const Duration(seconds: 2)) {
            //     controller.currentBackPressTime = now;
            //     controller.canPopNow.value = false;
            //     ShowToastDialog.showToast("Double press to exit");
            //     return;
            //   } else {
            //     controller.canPopNow.value = true;
            //   }
            // },
            child: Scaffold(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : const Color(0xFFFAF6F1),
              body: controller.pageList[controller.selectedIndex.value],
              bottomNavigationBar: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    color: Colors.transparent),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    showUnselectedLabels: true,
                    showSelectedLabels: true,
                    selectedFontSize: 12,
                    selectedLabelStyle:
                        const TextStyle(fontFamily: AppThemeData.bold),
                    unselectedLabelStyle:
                        const TextStyle(fontFamily: AppThemeData.bold),
                    currentIndex: controller.selectedIndex.value,
                    backgroundColor: themeChange.getThem()
                        ? AppThemeData.grey900
                        : AppThemeData.grey50,
                    selectedItemColor: themeChange.getThem()
                        ? AppThemeData.primary300
                        : AppThemeData.primary300,
                    unselectedItemColor: themeChange.getThem()
                        ? AppThemeData.grey300
                        : AppThemeData.grey600,
                    onTap: (int index) {
                      if (index == 0) {
                        DashBoardController dashBoardController =
                            Get.put(DashBoardController());
                      }
                      controller.selectedIndex.value = index;
                    },
                    items: Constant.walletSetting == false
                        ? [
                            navigationBarItem(
                              themeChange,
                              index: 0,
                              assetIcon: "assets/icons/home.svg",
                              label: 'Home'.tr,
                              controller: controller,
                            ),
                            navigationBarItem(
                              themeChange,
                              index: 1,
                              assetIcon: "assets/icons/ic_fav.svg",
                              label: 'Favourites'.tr,
                              controller: controller,
                            ),
                            navigationBarItem(
                              themeChange,
                              index: 2,
                              assetIcon: "assets/icons/ic_orders.svg",
                              label: 'Orders'.tr,
                              controller: controller,
                            ),
                            navigationBarItem(
                              themeChange,
                              index: 3,
                              assetIcon: "assets/icons/ic_profile.svg",
                              label: 'Profile'.tr,
                              controller: controller,
                            ),
                          ]
                        : [
                            navigationBarItem(
                              themeChange,
                              index: 0,
                              assetIcon: controller.selectedIndex.value == 0
                                  ? Constant.homeIcon
                                  : Constant.homeIconOutline,
                              label: 'Home'.tr,
                              controller: controller,
                            ),
                            navigationBarItem(
                              themeChange,
                              index: 1,
                              assetIcon: controller.selectedIndex.value == 1
                                  ? Constant.favouriteIcon
                                  : Constant.favouriteIconOutline,
                              label: 'Favourites'.tr,
                              controller: controller,
                            ),
                            navigationBarItem(
                              themeChange,
                              index: 2,
                              assetIcon: controller.selectedIndex.value == 2
                                  ? Constant.walletIcon
                                  : Constant.walletIconOutline,
                              label: 'Wallet'.tr,
                              controller: controller,
                            ),
                            navigationBarItem(
                              themeChange,
                              index: 3,
                              assetIcon: controller.selectedIndex.value == 3
                                  ? Constant.orderIcon
                                  : Constant.orderIconOutline,
                              label: 'Orders'.tr,
                              controller: controller,
                            ),
                            navigationBarItem(
                              themeChange,
                              index: 4,
                              assetIcon: controller.selectedIndex.value == 4
                                  ? Constant.personIcon
                                  : Constant.personIconOutline,
                              label: 'Profile'.tr,
                              controller: controller,
                            ),
                          ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  BottomNavigationBarItem navigationBarItem(themeChange,
      {required int index,
      required String label,
      required String assetIcon,
      required DashBoardController controller}) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 1),
        child: Iconify(
          assetIcon,
          color: controller.selectedIndex.value == index
              ? themeChange.getThem()
                  ? AppThemeData.primary300
                  : AppThemeData.primary300
              : themeChange.getThem()
                  ? AppThemeData.grey300
                  : AppThemeData.grey600,
          size: 24,
        ),
      ),
      label: label,
    );
  }
}
