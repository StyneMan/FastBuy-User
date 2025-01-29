import 'dart:convert';

import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_profile_controller.dart';

class FavouriteController extends GetxController {
  RxBool favouriteRestaurant = true.obs;
  final profileController = Get.find<MyProfileController>();
  // RxList<FavouriteItemModel> favouriteItemList = <FavouriteItemModel>[].obs;
  // // RxList<FavouriteModel> favouriteList = <FavouriteModel>[].obs;
  // RxList<VendorModel> favouriteVendorList = <VendorModel>[].obs;
  // RxList<ProductModel> favouriteFoodList = <ProductModel>[].obs;

  var favouriteList = {}.obs;
  var favouriteStores = {}.obs;
  var favouriteRestaurants = {}.obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  refreshData() async {
    try {
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      if (accessToken.isNotEmpty) {
        APIService()
            .getFavouritesStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          vendorType: "restaurant",
          page: 1,
        )
            .listen((onData) {
          debugPrint("RESTAURANT FAVOURITES :: ${onData.body}");
          isLoading.value = false;
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            favouriteRestaurants.value = map;
          }
        });

        APIService()
            .getFavouritesStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          vendorType: "grocery_store",
          page: 1,
        )
            .listen((onData) {
          debugPrint("STORE  FAVOURITES :: ${onData.body}");
          isLoading.value = false;
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            favouriteStores.value = map;
          }
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }
}
