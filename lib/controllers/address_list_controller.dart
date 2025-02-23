import 'dart:convert';

import 'package:customer/models/user_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_profile_controller.dart';

class AddressListController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;
  final profileController = Get.find<MyProfileController>();
  RxList<ShippingAddress> shippingAddressList = <ShippingAddress>[].obs;
  var shippingAddresses = {}.obs;

  List saveAsList = ['Home'.tr, 'Work'.tr, 'Hotel'.tr, 'other'.tr].obs;
  RxString selectedSaveAs = "Home".tr.obs;

  Rx<TextEditingController> houseBuildingTextEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> localityEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> landmarkEditingController =
      TextEditingController().obs;
  Rx<UserLocation> location = UserLocation().obs;
  Rx<UserLocation> location2 = UserLocation().obs;

  Rx<ShippingAddress> shippingModel = ShippingAddress().obs;
  Rx<ShippingAddress> receivingModel = ShippingAddress().obs;

  @override
  void onInit() {
    initAddress();
    // getUser();
    refreshShipping();

    super.onInit();
  }

  initAddress() async {
    try {
      final lati = Preferences.getString(Preferences.currLatitude);
      final longi = Preferences.getString(Preferences.currLongitude);
      final addr = Preferences.getString(Preferences.currAddress);
      final shipping = Preferences.getString(Preferences.shippingAddress);
      location.value.latitude = double.parse(lati);
      location.value.longitude = double.parse(longi);

      Map<String, dynamic> map = jsonDecode(shipping);
      debugPrint("PREFERENCE SHIPPING INFO ::: ${map}");

      if (map.isNotEmpty) {
        shippingModel.value = ShippingAddress(
          address: addr,
          addressAs: "Home",
          id: "1",
          isDefault: map['isDefault'],
          landmark: map['landmark'],
          locality: map['locality'],
          location: location.value,
        );
      }
    } catch (e) {
      debugPrint("eRRO $e");
    }
  }

  refreshShipping() {
    final accessToken = Preferences.getString(Preferences.accessTokenKey);

    if (accessToken.isNotEmpty) {
      APIService()
          .getShippingAdressesStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: 1,
      )
          .listen((onData) {
        debugPrint("MY SHIPPING ADDRESSES :: ${onData.body}");
        if (onData.statusCode >= 200 && onData.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(onData.body);

          shippingAddresses.value = map;
        }
      });
    }
  }

  // clearData() {
  //   shippingModel.value = ShippingAddress();
  //   houseBuildingTextEditingController.value.clear();
  //   localityEditingController.value.clear();
  //   landmarkEditingController.value.clear();
  //   location.value = UserLocation();
  //   selectedSaveAs.value = "Home".tr;
  // }

  // setData(ShippingAddress shippingAddress) {
  //   shippingModel.value = shippingAddress;
  //   houseBuildingTextEditingController.value.text =
  //       shippingAddress.address.toString();
  //   localityEditingController.value.text = shippingAddress.locality.toString();
  //   landmarkEditingController.value.text = shippingAddress.landmark.toString();
  //   selectedSaveAs.value = shippingAddress.addressAs.toString();
  //   location.value = shippingAddress.location!;
  // }

  // getUser() async {
  //   await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then(
  //     (value) {
  //       if (value != null) {
  //         userModel.value = value;
  //         if (userModel.value.shippingAddress != null) {
  //           shippingAddressList.value = userModel.value.shippingAddress!;
  //         }
  //       }
  //     },
  //   );
  // }
}
