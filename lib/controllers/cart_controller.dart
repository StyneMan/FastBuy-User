import 'dart:convert';

import 'package:customer/models/coupon_model.dart';
import 'package:customer/models/user_model.dart';
import 'package:customer/models/vendor_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/services/cart_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'my_profile_controller.dart';

class CartController extends GetxController {
  final CartProvider cartProvider = CartProvider();
  var cartData = {}.obs;
  RxList currentCartItems = [].obs;
  final profileController = Get.put(MyProfileController());
  RxString vendorNote = "".obs;
  RxBool isInCart = false.obs;
  RxInt currCartIndex = 0.obs;
  var currCartItem = {}.obs;

  // Rx<TextEditingController> reMarkController = TextEditingController().obs;
  Rx<TextEditingController> couponCodeController = TextEditingController().obs;
  // Rx<TextEditingController> tipsController = TextEditingController().obs;

  Rx<ShippingAddress> selectedAddress = ShippingAddress().obs;
  Rx<VendorModel> vendorModel = VendorModel().obs;
  Rx<DeliveryCharge> deliveryChargeModel = DeliveryCharge().obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<CouponModel> couponList = <CouponModel>[].obs;
  RxList<CouponModel> allCouponList = <CouponModel>[].obs;
  RxString selectedFoodType = "Delivery".tr.obs;

  RxString deliveryType = "instant".tr.obs;
  Rx<DateTime> scheduleDateTime = DateTime.now().obs;
  RxDouble totalDistance = 0.0.obs;
  RxDouble deliveryCharges = 0.0.obs;
  RxDouble subTotal = 0.0.obs;
  RxDouble couponAmount = 0.0.obs;

  RxDouble specialDiscountAmount = 0.0.obs;
  RxDouble specialDiscount = 0.0.obs;
  RxString specialType = "".obs;

  RxDouble deliveryTips = 0.0.obs;
  RxDouble taxAmount = 0.0.obs;
  RxDouble totalAmount = 0.0.obs;
  Rx<CouponModel> selectedCouponModel = CouponModel().obs;

  @override
  void onInit() {
    // selectedAddress.value = Constant.selectedLocation;
    refreshCart();
    super.onInit();
  }

  refreshCart() async {
    try {
      final accessToken = Preferences.getString(Preferences.accessTokenKey);

      if (accessToken.isNotEmpty) {
        APIService()
            .getCartStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          // debugPrint("MY SHOPPING CART :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            cartData.value = map;
          }
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }
}
