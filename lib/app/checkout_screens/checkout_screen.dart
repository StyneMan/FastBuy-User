import 'dart:convert';

import 'package:customer/app/auth_screen/otp_screen.dart';
import 'package:customer/app/checkout_screens/steps/delivery_step.dart';
import 'package:customer/app/checkout_screens/steps/payment_step.dart';
import 'package:customer/app/dash_board_screens/dash_board_screen.dart';
import 'package:customer/app/wallet_screen/set_wallet_pin.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/controllers/dash_board_controller.dart';
import 'package:customer/controllers/order_controller.dart';
import 'package:customer/controllers/wallet_controller.dart';
import 'package:customer/payment/MercadoPagoScreen.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final cart;
  const CheckoutScreen({
    super.key,
    required this.cart,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final addressController = Get.find<AddressListController>();
  final walletController = Get.find<WalletController>();
  final dashboardController = Get.find<DashBoardController>();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeChange.getThem() ? Colors.transparent : const Color(0xFFFAF6F1),
      appBar: AppBar(
        backgroundColor: themeChange.getThem()
            ? Colors.transparent
            : const Color(0xFFFAF6F1),
        title: Text(
          "Checkout".tr,
          style: TextStyle(
            fontSize: 16,
            color: themeChange.getThem()
                ? AppThemeData.grey50
                : AppThemeData.grey900,
            fontFamily: AppThemeData.regular,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: GetX(
          init: OrderController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              controller.activeCheckoutStep.value = 0;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Delivery Address".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.secondary400,
                                  fontFamily: AppThemeData.regular,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppThemeData.primary300,
                                      width: 6.0,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment Information".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : controller.activeCheckoutStep.value == 1
                                        ? AppThemeData.secondary400
                                        : AppThemeData.grey500,
                                fontFamily: AppThemeData.regular,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        controller.activeCheckoutStep.value == 1
                                            ? AppThemeData.primary300
                                            : AppThemeData.grey300,
                                    width: 6.0,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: controller.activeCheckoutStep.value == 0
                        ? DeliveryStep(
                            cart: widget.cart,
                            // index: widget.index,
                            onSelectDelivery: (value) {
                              controller.deliveryType.value = value;
                            },
                          )
                        : PaymentStep(
                            controller: controller,
                            cart: widget.cart,
                            // index: widget.index,
                            onSelectPayment: (value) {
                              controller.selectedPaymentMethod.value = value;
                            },
                          ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RoundedButtonFill(
                          title: controller.activeCheckoutStep.value == 0
                              ? "Make Payment".tr
                              : "Place Order".tr,
                          height: 5.5,
                          color: AppThemeData.primary300,
                          textColor: AppThemeData.grey50,
                          fontSizes: 16,
                          onPress: () {
                            if (controller.activeCheckoutStep.value == 0) {
                              if (controller.deliveryType.value == "delivery") {
                                estimateDeliveryFee(
                                  controller: controller,
                                );
                              } else {
                                setState(() {
                                  controller.activeCheckoutStep.value = 1;
                                });
                              }
                            } else {
                              // Handle order placement here
                              if (controller.selectedPaymentMethod.value ==
                                  'wallet') {
                                // Now check for wallet balance and the rest...
                                if (walletController
                                        .userWallet.value['balance'] <
                                    (controller.deliveryEstimates
                                            .value['service_charge'] +
                                        widget.cart['total_amount'] +
                                        controller.deliveryEstimates
                                            .value['delivery_fee'])) {
                                  showWalletSheet(themeChange: themeChange);
                                } else {
                                  // Check if wallet pin is set
                                  if (walletController.profileController
                                          .userData.value['wallet_pin'] ==
                                      null) {
                                    showSetWalletPINSheet(
                                      themeChange: themeChange,
                                    );
                                  } else {
                                    Get.to(
                                      OtpScreen(
                                        type: "wallet",
                                        payload: {
                                          "userType": "customer",
                                          "paymentInfo": {
                                            "amount": double.parse(
                                                "${controller.deliveryEstimates.value['service_charge'] + widget.cart['total_amount'] + controller.deliveryEstimates.value['delivery_fee']}"), // payable amount here
                                            "email_address":
                                                '${dashboardController.profileController.userData.value['email_address']} ',
                                            "full_name":
                                                "${dashboardController.profileController.userData.value['first_name']} ${dashboardController.profileController.userData.value['last_name']}",
                                            "customer_id":
                                                "${dashboardController.profileController.userData.value['id']}",
                                            "phone_number":
                                                "${dashboardController.profileController.userData.value['phone_number']}",
                                            "title": "Order Purchase",
                                          },
                                          "orderInfo": {
                                            "amount": double.parse(
                                                "${widget.cart['total_amount']}"),
                                            "items": widget.cart['items'],
                                            "customerId":
                                                "${dashboardController.profileController.userData.value['id']}",
                                            "vendorLocationId": widget
                                                .cart['vendor_location']['id'],
                                            "riderNote":
                                                controller.riderNote.value,
                                            "vendorNote":
                                                widget.cart['vendor_note'],
                                            "orderType":
                                                widget.cart['vendor_location']
                                                                ['vendor']
                                                            ['vendor_type'] ==
                                                        "restaurant"
                                                    ? "restaurant_order"
                                                    : "store_order",
                                            "deliveryType":
                                                controller.deliveryType.value,
                                            "paymentMethod": controller
                                                .selectedPaymentMethod.value,
                                            "deliveryFee": controller
                                                .deliveryEstimates
                                                .value['delivery_fee'],
                                            "deliveryTime": controller
                                                .deliveryEstimates
                                                .value['delivery_time'],
                                            "deliveryAddress": addressController
                                                .shippingModel.value
                                                .getFullAddress(),
                                            "deliveryAddrLat":
                                                "${addressController.location.value.latitude}",
                                            "deliveryAddrLng":
                                                "${addressController.location.value.longitude}",
                                            "riderCommission": double.parse(
                                                "${controller.deliveryEstimates.value['rider_commission'] ?? "0.0"}"),
                                            "serviceCharge": double.parse(
                                                "${controller.deliveryEstimates.value['service_charge'] ?? "1.0"}")
                                          },
                                        },
                                      ),
                                      transition: Transition.cupertino,
                                    );
                                  }
                                }
                              } else {
                                // Init payment here
                                placeOrder(controller: controller);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }

  estimateDeliveryFee({required OrderController controller}) async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      Map payload = {
        "vendorLocationId": widget.cart['vendor_location']['id'],
        "totalAmount": int.parse("${widget.cart['total_amount']}"),
        "latitude": "${addressController.location.value.latitude}",
        "longitude": "${addressController.location.value.longitude}",
      };

      final response = await APIService().estimateDeliveryFare(
        accessToken: accessToken,
        payload: payload,
      );
      debugPrint("ESTIMATE RESPONSE :::  ${response.body}");
      ShowToastDialog.closeLoader();
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);
        controller.deliveryEstimates.value = map;
        setState(() {
          controller.activeCheckoutStep.value = 1;
        });
      } else {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constant.toast(map['message']);
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint("ERROR => $e");
    }
  }

  placeOrder({
    required OrderController controller,
  }) async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final accessToken = Preferences.getString(Preferences.accessTokenKey);

      Map payload = {
        "userType": "customer",
        "paymentInfo": {
          "amount": double.parse(
              "${controller.deliveryEstimates.value['service_charge'] + widget.cart['total_amount'] + controller.deliveryEstimates.value['delivery_fee'] - controller.couponAppliedAmount.value}"), // payable amount here
          "email_address":
              '${dashboardController.profileController.userData.value['email_address']}'
                  .trim(),
          "full_name":
              "${dashboardController.profileController.userData.value['first_name']} ${dashboardController.profileController.userData.value['last_name']}",
          "customer_id":
              "${dashboardController.profileController.userData.value['id']}",
          "phone_number":
              "${dashboardController.profileController.userData.value['phone_number']}",
          "title": "Order Purchase",
        },
        "orderInfo": {
          "amount": double.parse("${widget.cart['total_amount']}"),
          "items": widget.cart['items'],
          "customerId":
              "${dashboardController.profileController.userData.value['id']}",
          "vendorLocationId": widget.cart['vendor_location']['id'],
          "riderNote": controller.riderNote.value,
          "vendorNote": widget.cart['vendor_note'],
          "orderType": widget.cart['vendor_location']['vendor']
                      ['vendor_type'] ==
                  "restaurant"
              ? "restaurant_order"
              : "store_order",
          "deliveryType": controller.deliveryType.value,
          "paymentMethod": controller.selectedPaymentMethod.value,
          "deliveryFee": controller.deliveryEstimates.value['delivery_fee'],
          "deliveryTime": controller.deliveryEstimates.value['delivery_time'],
          "deliveryAddress":
              addressController.shippingModel.value.getFullAddress(),
          "deliveryAddrLat": "${addressController.location.value.latitude}",
          "deliveryAddrLng": "${addressController.location.value.longitude}",
          "riderCommission": double.parse(
              "${controller.deliveryEstimates.value['rider_commission'] ?? "0.0"}"),
          "serviceCharge": double.parse(
              "${controller.deliveryEstimates.value['service_charge'] ?? "1.0"}")
        },
      };

      final response = await APIService().orderWithCard(
        accessToken: accessToken,
        payload: payload,
      );
      debugPrint("PLACE ORDER RESPONSE :::  ${response.body}");
      ShowToastDialog.closeLoader();
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);
        // Now open payment link here
        Get.to(MercadoPagoScreen(
                initialURl:
                    map['data']['link'] ?? map['data']['authorization_url']))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            APIService()
                .getOrdersStreamed(
              accessToken: accessToken,
              customerId:
                  dashboardController.profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                dashboardController.orderController.myOrders.value =
                    map['data'];
                dashboardController.orderController.hasMoreOrders.value =
                    int.parse("${map['totalPages']}") >
                            int.parse("${map['currentPage']}")
                        ? true
                        : false;
                dashboardController.orderController.ordersCurrentPage.value =
                    int.parse("${map['currentPage']}");
              }
            });
            // Navigate to the Orders Screen from here
            dashboardController.selectedIndex.value = 3;
            Get.offAll(
              const DashBoardScreen(),
              transition: Transition.cupertino,
            );
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
      } else {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constant.toast(map['message']);
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint("ERROR => $e");
    }
  }

  showWalletSheet({
    required themeChange,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.25,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Container(
                      width: 134,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: ShapeDecoration(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "You have insufficient wallet balance. Click on the button below to topup your wallet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey900,
                      fontFamily: AppThemeData.regular,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: RoundedButtonFill(
                title: "Topup Wallet".tr,
                height: 5.5,
                color: AppThemeData.primary300,
                fontSizes: 16,
                onPress: () async {
                  dashboardController.selectedIndex.value = 2;
                  Get.off(
                    const DashBoardScreen(),
                    transition: Transition.cupertino,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSetWalletPINSheet({
    required themeChange,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: SetWalletPin(),
      ),
    );
  }
}
