import 'dart:convert';

import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/models/cart_product_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/services/cart_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final profileController = Get.find<MyProfileController>();
  final cartController = Get.find<CartController>();

  var myOrders = [].obs;
  var myParcelOrders = [].obs;
  var myInprogressOrders = [].obs;
  var myDeliveredOrders = [].obs;
  var myCancelledOrders = [].obs;

  RxBool isLoadingMoreOrders = false.obs;
  RxBool isLoadingMoreParcelOrders = false.obs;
  RxBool isLoadingMoreInprogressOrders = false.obs;
  RxBool isLoadingMoreDeliveredOrders = false.obs;
  RxBool isLoadingMoreCancelledOrders = false.obs;

  RxBool hasMoreOrders = false.obs;
  RxBool hasMoreParcelOrders = false.obs;
  RxBool hasMoreInprogressOrders = false.obs;
  RxBool hasMoreDeliveredOrders = false.obs;
  RxBool hasMoreCancelledOrders = false.obs;

  var ordersScrollController = ScrollController();
  var parcelOrdersScrollController = ScrollController();
  var inProgressOrdersScrollController = ScrollController();
  var deliveredOrdersScrollController = ScrollController();
  var cancelledOrdersScrollController = ScrollController();

  RxInt ordersCurrentPage = 1.obs;
  RxInt parcelOrdersCurrentPage = 1.obs;
  RxInt inProgressOrdersCurrentPage = 1.obs;
  RxInt deliveredOrdersCurrentPage = 1.obs;
  RxInt cancelledOrdersCurrentPage = 1.obs;

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
    getOrder();
    super.onInit();
  }

  void setupScrollListener() {
    ordersScrollController.addListener(() async {
      if (ordersScrollController.position.pixels ==
          ordersScrollController.position.maxScrollExtent) {
        debugPrint("Reached end");
        // Constant.toast("REACHED THE END !!!");

        // Prevent multiple calls at once
        if (hasMoreOrders.value) {
          await loadMoreOrders();
        }
      }
    });

    parcelOrdersScrollController.addListener(() async {
      if (parcelOrdersScrollController.position.pixels ==
          parcelOrdersScrollController.position.maxScrollExtent) {
        if (hasMoreParcelOrders.value) {
          await loadMoreParcelOrders();
        }
      }
    });

    inProgressOrdersScrollController.addListener(() async {
      if (inProgressOrdersScrollController.position.pixels ==
          inProgressOrdersScrollController.position.maxScrollExtent) {
        debugPrint("Reached end");
        if (hasMoreOrders.value) {
          await loadMoreInProgressOrders();
        }
      }
    });

    deliveredOrdersScrollController.addListener(() async {
      if (deliveredOrdersScrollController.position.pixels ==
          deliveredOrdersScrollController.position.maxScrollExtent) {
        debugPrint("Reached end");
        if (hasMoreOrders.value) {
          await loadMoreDeliveredOrders();
        }
      }
    });

    cancelledOrdersScrollController.addListener(() async {
      if (cancelledOrdersScrollController.position.pixels ==
          cancelledOrdersScrollController.position.maxScrollExtent) {
        debugPrint("Reached end");
        if (hasMoreOrders.value) {
          await loadMoreCancelledOrders();
        }
      }
    });
  }

  Future<void> loadMoreOrders() async {
    final accessToken = Preferences.getString(Preferences.accessTokenKey);

    if (accessToken.isEmpty) return;

    isLoadingMoreOrders.value = true;
    ordersCurrentPage.value = ordersCurrentPage.value + 1;

    try {
      APIService()
          .getOrdersStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: ordersCurrentPage.value, // Next page
      )
          .listen((response) {
        debugPrint("SECOND PAGE  ::: ${response.body}");
        isLoadingMoreOrders.value = false;
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(response.body);

          // Append new data to existing list
          myOrders.value = [...myOrders.value, ...map['data']];

          hasMoreOrders.value = int.parse("${map['totalPages']}") >
                  int.parse("${map['currentPage']}")
              ? true
              : false;
          ordersCurrentPage.value = int.parse("${map['currentPage']}");
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoadingMoreOrders.value = false;
    } finally {
      isLoadingMoreOrders.value = false;
    }
  }

  Future<void> loadMoreParcelOrders() async {
    final accessToken = Preferences.getString(Preferences.accessTokenKey);

    if (accessToken.isEmpty) return;

    isLoadingMoreParcelOrders.value = true;
    parcelOrdersCurrentPage.value = parcelOrdersCurrentPage.value + 1;

    try {
      APIService()
          .getParcelOrdersStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: parcelOrdersCurrentPage.value, // Next page
      )
          .listen((response) {
        debugPrint("NeXT PAGE  ::: ${response.body}");
        isLoadingMoreParcelOrders.value = false;
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(response.body);

          // Append new data to existing list
          myParcelOrders.value = [...myParcelOrders.value, ...map['data']];

          hasMoreParcelOrders.value = int.parse("${map['totalPages']}") >
                  int.parse("${map['currentPage']}")
              ? true
              : false;
          parcelOrdersCurrentPage.value = int.parse("${map['currentPage']}");
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoadingMoreParcelOrders.value = false;
    } finally {
      isLoadingMoreParcelOrders.value = false;
    }
  }

  Future<void> loadMoreInProgressOrders() async {
    final accessToken = Preferences.getString(Preferences.accessTokenKey);

    if (accessToken.isEmpty) return;

    isLoadingMoreInprogressOrders.value = true;
    inProgressOrdersCurrentPage.value = inProgressOrdersCurrentPage.value + 1;

    try {
      APIService()
          .getOrdersInprogressStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: inProgressOrdersCurrentPage.value, // Next page
      )
          .listen((response) {
        debugPrint("NEXT PAGE  ::: ${response.body}");
        isLoadingMoreInprogressOrders.value = false;
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(response.body);

          // Append new data to existing list
          myInprogressOrders.value = [
            ...myInprogressOrders.value,
            ...map['data']
          ];

          hasMoreInprogressOrders.value = int.parse("${map['totalPages']}") >
                  int.parse("${map['currentPage']}")
              ? true
              : false;
          inProgressOrdersCurrentPage.value =
              int.parse("${map['currentPage']}");
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoadingMoreInprogressOrders.value = false;
    } finally {
      isLoadingMoreInprogressOrders.value = false;
    }
  }

  Future<void> loadMoreDeliveredOrders() async {
    final accessToken = Preferences.getString(Preferences.accessTokenKey);

    if (accessToken.isEmpty) return;

    isLoadingMoreDeliveredOrders.value = true;
    deliveredOrdersCurrentPage.value = deliveredOrdersCurrentPage.value + 1;

    try {
      APIService()
          .getOrdersDeliveredStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: deliveredOrdersCurrentPage.value, // Next page
      )
          .listen((response) {
        debugPrint("NEXT PAGE  ::: ${response.body}");
        isLoadingMoreDeliveredOrders.value = false;
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(response.body);

          // Append new data to existing list
          myDeliveredOrders.value = [
            ...myDeliveredOrders.value,
            ...map['data']
          ];

          hasMoreDeliveredOrders.value = int.parse("${map['totalPages']}") >
                  int.parse("${map['currentPage']}")
              ? true
              : false;
          deliveredOrdersCurrentPage.value = int.parse("${map['currentPage']}");
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoadingMoreDeliveredOrders.value = false;
    } finally {
      isLoadingMoreDeliveredOrders.value = false;
    }
  }

  Future<void> loadMoreCancelledOrders() async {
    final accessToken = Preferences.getString(Preferences.accessTokenKey);

    if (accessToken.isEmpty) return;

    isLoadingMoreCancelledOrders.value = true;
    cancelledOrdersCurrentPage.value = cancelledOrdersCurrentPage.value + 1;

    try {
      APIService()
          .getOrdersCancelledStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: cancelledOrdersCurrentPage.value, // Next page
      )
          .listen((response) {
        debugPrint("NEXT PAGE  ::: ${response.body}");
        isLoadingMoreCancelledOrders.value = false;
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(response.body);

          // Append new data to existing list
          myCancelledOrders.value = [
            ...myCancelledOrders.value,
            ...map['data']
          ];

          hasMoreCancelledOrders.value = int.parse("${map['totalPages']}") >
                  int.parse("${map['currentPage']}")
              ? true
              : false;
          cancelledOrdersCurrentPage.value = int.parse("${map['currentPage']}");
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoadingMoreCancelledOrders.value = false;
    } finally {
      isLoadingMoreCancelledOrders.value = false;
    }
  }

  getOrder() async {
    if (profileController.userData.value.isNotEmpty) {
      final accessToken = Preferences.getString(Preferences.accessTokenKey);

      if (accessToken.isNotEmpty) {
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
            myOrders.value = map['data'];
            hasMoreOrders.value = int.parse("${map['totalPages']}") >
                    int.parse("${map['currentPage']}")
                ? true
                : false;
            ordersCurrentPage.value = int.parse("${map['currentPage']}");
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
            myInprogressOrders.value = map['data'];
            hasMoreInprogressOrders.value = int.parse("${map['totalPages']}") >
                    int.parse("${map['currentPage']}")
                ? true
                : false;
            inProgressOrdersCurrentPage.value =
                int.parse("${map['currentPage']}");
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
            myDeliveredOrders.value = map['data'];
            hasMoreDeliveredOrders.value = int.parse("${map['totalPages']}") >
                    int.parse("${map['currentPage']}")
                ? true
                : false;
            deliveredOrdersCurrentPage.value =
                int.parse("${map['currentPage']}");
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
            myCancelledOrders.value = map['data'];
            hasMoreCancelledOrders.value = int.parse("${map['totalPages']}") >
                    int.parse("${map['currentPage']}")
                ? true
                : false;
            cancelledOrdersCurrentPage.value =
                int.parse("${map['currentPage']}");
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
            myParcelOrders.value = map['data'];
            hasMoreParcelOrders.value = int.parse("${map['totalPages']}") >
                    int.parse("${map['currentPage']}")
                ? true
                : false;
            parcelOrdersCurrentPage.value = int.parse("${map['currentPage']}");
          }
        });
      }
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
