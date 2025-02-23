import 'package:customer/app/auth_screen/login_screen.dart';
import 'package:customer/app/vendor_screens/vendor_card.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/favourite_controller.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});

  final _profileController = Get.find<MyProfileController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: FavouriteController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surfaceDark
                : const Color(0xFFFAF6F1),
            body: SafeArea(
              child: controller.isLoading.value
                  ? Constant.loader()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).viewPadding.top),
                      child: Expanded(
                        child: _profileController.userData.value.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/login.gif",
                                      height: 120,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Please Log In to Continue".tr,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey100
                                            : AppThemeData.grey800,
                                        fontSize: 22,
                                        fontFamily: AppThemeData.semiBold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "You’re not logged in. Please sign in to access your account and explore all features."
                                          .tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey500,
                                        fontSize: 16,
                                        fontFamily: AppThemeData.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    RoundedButtonFill(
                                      title: "Log in".tr,
                                      width: 55,
                                      height: 5.5,
                                      color: AppThemeData.primary300,
                                      textColor: AppThemeData.grey50,
                                      onPress: () async {
                                        Get.offAll(LoginScreen());
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey700
                                            : AppThemeData.grey200,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  controller.favouriteRestaurant
                                                      .value = true;
                                                },
                                                child: Container(
                                                  decoration: controller
                                                              .favouriteRestaurant
                                                              .value ==
                                                          false
                                                      ? null
                                                      : ShapeDecoration(
                                                          color: AppThemeData
                                                              .grey900,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              120,
                                                            ),
                                                          ),
                                                        ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                    child: Text(
                                                      "Favourite Restaurants"
                                                          .tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .semiBold,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .primary300
                                                            : AppThemeData
                                                                .primary300,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  controller.favouriteRestaurant
                                                      .value = false;
                                                },
                                                child: Container(
                                                  decoration: controller
                                                              .favouriteRestaurant
                                                              .value ==
                                                          true
                                                      ? null
                                                      : ShapeDecoration(
                                                          color: AppThemeData
                                                              .grey900,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        120),
                                                          ),
                                                        ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                    child: Text(
                                                      "Favourite Stores".tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .semiBold,
                                                        color: controller
                                                                    .favouriteRestaurant
                                                                    .value ==
                                                                true
                                                            ? themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey400
                                                                : AppThemeData
                                                                    .grey500
                                                            : themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .primary300
                                                                : AppThemeData
                                                                    .primary300,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                      ),
                                      child: controller
                                              .favouriteRestaurant.value
                                          ? controller.favouriteRestaurants
                                                  .value.isEmpty
                                              ? const SizedBox()
                                              : controller.favouriteRestaurants
                                                      .value['data'].isEmpty
                                                  ? Constant.showEmptyView(
                                                      message:
                                                          "Favourite Restaurants not found.")
                                                  : ListView.separated(
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: controller
                                                          .favouriteRestaurants
                                                          .value['data']
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        debugPrint(
                                                            "CHECK ING RES FAVS ::: ${controller.favouriteRestaurants.value['data']}");
                                                        final vendorLocationModel =
                                                            controller.favouriteRestaurants
                                                                        .value[
                                                                    'data'][index]
                                                                [
                                                                'vendor_location'];
                                                        return InkWell(
                                                          onTap: () {},
                                                          child: VendorCard(
                                                            item:
                                                                vendorLocationModel,
                                                          ),
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const SizedBox(
                                                        height: 16.0,
                                                      ),
                                                    )
                                          : controller.favouriteRestaurants
                                                  .value.isEmpty
                                              ? const SizedBox()
                                              : controller.favouriteStores
                                                      .value['data'].isEmpty
                                                  ? Constant.showEmptyView(
                                                      message:
                                                          "Favourite Stores not found.")
                                                  : ListView.separated(
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: controller
                                                          .favouriteStores
                                                          .value['data']
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        debugPrint(
                                                            "CHECK ING STOREs FAVS ::: ${controller.favouriteRestaurants.value['data']}");
                                                        final vendorLocationModel =
                                                            controller.favouriteStores
                                                                        .value[
                                                                    'data'][index]
                                                                [
                                                                'vendor_location'];
                                                        return InkWell(
                                                          onTap: () {},
                                                          child: VendorCard(
                                                            item:
                                                                vendorLocationModel,
                                                          ),
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const SizedBox(
                                                        height: 16.0,
                                                      ),
                                                    ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
            ),
          );
        });
  }
}
