import 'dart:convert';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'my_profile_controller.dart';

class LogisticsController extends GetxController {
  final profileController = Get.find<MyProfileController>();
  final addressController = Get.find<AddressListController>();

  RxBool isLoading = true.obs;
  RxInt activeStep = 0.obs;
  var zoneVendors = {}.obs;
  var allOrders = {}.obs;
  RxString riderNote = "".obs;

  var receiverAddress = dynamic.obs;

  Rx<TextEditingController> senderNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> senderPhoneEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> senderEmailEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> senderStreetEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> senderLandmarkEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> sendercountryCodeEditingController =
      TextEditingController().obs;

  Rx<TextEditingController> receiverNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> receiverPhoneEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> receiverEmailEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> receiverStreetEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> receiverLandmarkEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> receivercountryCodeEditingController =
      TextEditingController().obs;

  Rx<TextEditingController> packageNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> packageQuantityEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> weightEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> dimensionEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> shippingEditingController =
      TextEditingController().obs;
  RxString selectedShipping = "".obs;

  RxList addedPackages = [].obs;
  RxList images = [].obs;
  RxBool shouldAddMorePackage = true.obs;

  RxBool isFetchingCost = false.obs;
  RxList paymentMethods = ["wallet", "card"].obs;
  RxString selectedPayment = "".obs;

  var estimateData = {}.obs;

  final cloudinary = Cloudinary.full(
    apiKey: '833281127161936',
    apiSecret: 'oLfUxTbYmdoQJwKGd64hje3m_Sc',
    cloudName: 'dgmelutoi',
  );

  @override
  void onInit() {
    // TODO: implement onInit
    init();
    super.onInit();
  }

  RxString isDarkMode = "Light".obs;
  RxBool isDarkModeSwitch = false.obs;

  init() async {
    senderEmailEditingController.value.text =
        profileController.userData.value['email_address'];
    senderNameEditingController.value.text =
        profileController.userData.value['first_name'] +
            " " +
            profileController.userData.value['last_name'];
    final accessToken = Preferences.getString(Preferences.accessTokenKey);

    senderPhoneEditingController.value.text =
        profileController.userData.value['phone_number'];

    sendercountryCodeEditingController.value.text =
        profileController.userData.value['country_code'];

    receivercountryCodeEditingController.value.text = "NG";

    if (accessToken.isNotEmpty) {
      try {
        final vendors = await APIService().getVendors(
          accessToken: accessToken,
          page: 1,
        );
        debugPrint("VENDORS :::: ${vendors.body}");

        final restaurantVendors = await APIService().getVendors(
          accessToken: accessToken,
          page: 1,
          vendorType: "restaurant",
        );
        debugPrint("RESTAURANT VENDORS :::: ${restaurantVendors.body}");

        final storeVendors = await APIService().getVendors(
          accessToken: accessToken,
          page: 1,
          vendorType: "grocery_store",
        );
        debugPrint("STORE VENDORS :::: ${storeVendors.body}");

        final gatewayResponse = await APIService().getPaymentGateways();
        debugPrint("PAYMENT GATEWAYS ::: ${gatewayResponse.body}");
        if (gatewayResponse.statusCode >= 200 &&
            gatewayResponse.statusCode <= 299) {
          final dynamic decoded = jsonDecode(gatewayResponse.body);

          if (decoded is List) {
            final List<Map<String, dynamic>> mapList =
                decoded.map((e) => Map<String, dynamic>.from(e)).toList();
            profileController.paymentGateways.value = mapList;
          } else {
            debugPrint("Unexpected response structure.");
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  setOrder(var orders) {
    allOrders.value = orders;
  }

  final ImagePicker _imagePicker = ImagePicker();
  RxString profileImage = "".obs;

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      images.value = [...images.value, image.path];
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }

  savePackage(var payload) {
    addedPackages.value = [...addedPackages.value, payload];
    // Clear fields
    packageNameEditingController.value.clear();
    packageQuantityEditingController.value.clear();
    dimensionEditingController.value.clear();
    weightEditingController.value.clear();
    images.value = [];
    shouldAddMorePackage.value = true;
  }

  calculateCost() async {
    try {
      isFetchingCost.value = true;
      double totalWeight = 0.0;
      debugPrint("ADDED PACKAGES ::: ${addedPackages.value}");
      for (int i = 0; i < addedPackages.value.length; i++) {
        debugPrint("WEIGHT ::: ${addedPackages.value[i]['weight']}");
        double? weight = double.tryParse(addedPackages.value[i]['weight']);
        totalWeight = totalWeight + (weight ?? 0.0);
      }

      await Future.delayed(const Duration(seconds: 2), () {
        debugPrint("EZeGE MENT :: $totalWeight");
      });

      final accessToken = Preferences.getString(Preferences.accessTokenKey);

      Map payload = {
        "totalWeight": totalWeight,
        "senderLat": addressController.location.value.latitude,
        "senderLng": addressController.location.value.longitude,
        "receiverLat": addressController.location2.value.latitude,
        "receiverLng": addressController.location2.value.longitude,
        "shippingType": selectedShipping.value.toLowerCase(),
      };

      final resp = await APIService().estimateParcelFare(
        accessToken: accessToken,
        payload: payload,
      );
      isFetchingCost.value = false;
      debugPrint("FARE RESPONSE ::: ${resp.body}");
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast(map['message']);
        estimateData.value = map;
        activeStep.value = 3;
      } else {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast(map['message']);
        activeStep.value = 2;
      }
    } catch (e) {
      debugPrint(e.toString());
      isFetchingCost.value = false;
    }
  }

  calculateCostFare() async {
    try {
      isFetchingCost.value = true;
      final accessToken = Preferences.getString(Preferences.accessTokenKey);

      Map payload = {
        "totalWeight": double.parse(weightEditingController.value.text),
        "senderLat": addressController.location.value.latitude,
        "senderLng": addressController.location.value.longitude,
        "receiverLat": addressController.location2.value.latitude,
        "receiverLng": addressController.location2.value.longitude,
        "shippingType": selectedShipping.value.toLowerCase(),
      };

      final resp = await APIService().estimateParcelFare(
        accessToken: accessToken,
        payload: payload,
      );
      isFetchingCost.value = false;
      debugPrint("FARE RESPONSE ::: ${resp.body}");
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast(map['message']);
        estimateData.value = map;
      } else {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast(map['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      isFetchingCost.value = false;
    }
  }
}
