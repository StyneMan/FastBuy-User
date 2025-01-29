import 'dart:convert';

import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorsController extends GetxController {
  RxBool isLoading = true.obs;
  var zoneVendors = {}.obs;
  var allvendors = {}.obs;
  var restaurantVendors = {}.obs;
  var storeVendors = {}.obs;
  RxList packOptions = [].obs;

  RxBool isOptionsExpanded = false.obs;
  var selectedPacks = {}.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    init();
    super.onInit();
  }

  RxString isDarkMode = "Light".obs;
  RxBool isDarkModeSwitch = false.obs;

  init() async {
    final accessToken = Preferences.getString(Preferences.accessTokenKey);

    if (accessToken.isNotEmpty) {
      try {
        final vendors = await APIService().getVendors(
          accessToken: accessToken,
          page: 1,
        );
        debugPrint("VENDORS :::: ${vendors.body}");
        if (vendors.statusCode >= 200 && vendors.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(vendors.body);
          allvendors.value = map;
        }

        final restaurants = await APIService().getVendors(
          accessToken: accessToken,
          page: 1,
          vendorType: "restaurant",
        );
        debugPrint("RESTAURANT VENDORS :::: ${restaurants.body}");
        if (restaurants.statusCode >= 200 && restaurants.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(restaurants.body);
          debugPrint("RESTAURANT MAPPED :::: ${map}");
          restaurantVendors.value = map;
        }

        final stores = await APIService().getVendors(
          accessToken: accessToken,
          page: 1,
          vendorType: "grocery_store",
        );
        debugPrint("STORE VENDORS :::: ${stores.body}");
        if (stores.statusCode >= 200 && stores.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(stores.body);
          storeVendors.value = map;
        }

        final packResp = await APIService().getPackOptions();
        debugPrint("PACK OPTION RESPONSE HERE ::: ${packResp.body}");
        if (packResp.statusCode >= 200 && packResp.statusCode <= 299) {
          final List<dynamic> decodedList = jsonDecode(packResp.body);

          // Ensure the list contains maps
          List<Map<String, dynamic>> list =
              decodedList.map((item) => item as Map<String, dynamic>).toList();

          // Assign the value
          packOptions.value = list;
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  setVendors(var vendors) {
    allvendors.value = vendors;
  }

  setRestaurantVendors(var vendors) {
    restaurantVendors.value = vendors;
  }

  setStoreVendors(var vendors) {
    storeVendors.value = vendors;
  }
}
