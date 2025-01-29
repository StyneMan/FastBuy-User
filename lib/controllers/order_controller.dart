import 'dart:convert';

import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/models/cart_product_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/services/cart_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final profileController = Get.find<MyProfileController>();

  var myOrders = {}.obs;
  var myParcelOrders = {}.obs;
  var myInprogressOrders = {}.obs;
  var myDeliveredOrders = {}.obs;
  var myCancelledOrders = {}.obs;
  RxString riderNote = "".obs;
  RxString selectedPaymentMethod = "wallet".obs;
  RxString deliveryType = "delivery".obs;
  var deliveryEstimates = {}.obs;
  var couponAppliedId = "".obs;
  var couponAppliedAmount = 0.0.obs;

  RxBool isLoading = true.obs;

  RxInt activeCheckoutStep = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getOrder();
    super.onInit();
  }

  getOrder() async {
    if (profileController.userData.value.isNotEmpty) {
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      APIService()
          .getOrdersStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: 1,
      )
          .listen((onData) {
        // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
        if (onData.statusCode >= 200 && onData.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(onData.body);
          myOrders.value = map;
        }
      });

      APIService()
          .getOrdersInprogressStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: 1,
      )
          .listen((onData) {
        // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
        if (onData.statusCode >= 200 && onData.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(onData.body);
          myInprogressOrders.value = map;
        }
      });

      APIService()
          .getOrdersDeliveredStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: 1,
      )
          .listen((onData) {
        // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
        if (onData.statusCode >= 200 && onData.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(onData.body);
          myDeliveredOrders.value = map;
        }
      });

      APIService()
          .getOrdersCancelledStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: 1,
      )
          .listen((onData) {
        // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
        if (onData.statusCode >= 200 && onData.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(onData.body);
          myCancelledOrders.value = map;
        }
      });

      APIService()
          .getParcelOrdersStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: 1,
      )
          .listen((onData) {
        // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
        if (onData.statusCode >= 200 && onData.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(onData.body);
          myParcelOrders.value = map;
        }
      });
    }

    isLoading.value = false;
  }

  final CartProvider cartProvider = CartProvider();

  addToCart({required CartProductModel cartProductModel}) {
    cartProvider.addToCart(
        Get.context!, cartProductModel, cartProductModel.quantity!);
    update();
  }
}
