import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/order_controller.dart';
import 'package:customer/controllers/wallet_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

typedef void InitCallback(String value);

class PaymentStep extends StatelessWidget {
  final InitCallback onSelectPayment;
  final OrderController controller;
  final cart;
  final int index;
  PaymentStep({
    super.key,
    required this.onSelectPayment,
    required this.controller,
    required this.cart,
    required this.index,
  });

  final couponEditController = TextEditingController();
  final walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Obx(
      () => ListView(
        padding: const EdgeInsets.all(2.0),
        children: [
          Container(
            width: Responsive.width(100, context),
            padding: const EdgeInsets.all(16.0),
            decoration: ShapeDecoration(
              color: themeChange.getThem()
                  ? AppThemeData.grey900
                  : AppThemeData.grey50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Summary".tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontFamily: AppThemeData.bold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sub-total (${cart['items']?.length} ${cart['items']?.length > 1 ? "items" : "item"})"
                          .tr,
                      style: TextStyle(
                        fontSize: 15,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "₦${Constant.formatNumber(cart['total_amount'])}".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                controller.deliveryType.value == "pickup"
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Delivery Fee".tr,
                            style: TextStyle(
                              fontSize: 15,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.regular,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            "₦${Constant.formatNumber(controller.deliveryEstimates.value['delivery_fee'])}"
                                .tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: Responsive.width(100, context),
            padding: const EdgeInsets.all(16.0),
            decoration: ShapeDecoration(
              color: themeChange.getThem()
                  ? AppThemeData.grey900
                  : AppThemeData.grey50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Use Coupon".tr,
                  style: TextStyle(
                    fontSize: 17,
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontFamily: AppThemeData.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFieldWidget(
                  hintText: "Enter promo code",
                  controller: couponEditController,
                  prefix: const Icon(Icons.discount),
                  suffix: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      applyCoupon();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppThemeData.primary400,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    child: Text(
                      "Apply Code".tr,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: Responsive.width(100, context),
            padding: const EdgeInsets.all(16.0),
            decoration: ShapeDecoration(
              color: themeChange.getThem()
                  ? AppThemeData.grey900
                  : AppThemeData.grey50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Method".tr,
                  style: TextStyle(
                    fontSize: 17,
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontFamily: AppThemeData.bold,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Amount".tr,
                      style: TextStyle(
                        fontSize: 15,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "₦${Constant.formatNumber(cart['total_amount'] + controller.deliveryEstimates.value['delivery_fee'])}"
                          .tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Service Charge".tr,
                      style: TextStyle(
                        fontSize: 15,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "₦${Constant.formatNumber(controller.deliveryEstimates.value['service_charge'])}"
                          .tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Divider(),
                const SizedBox(
                  height: 16.0,
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Amount To Pay".tr,
                        style: TextStyle(
                          fontSize: 15,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "₦${Constant.formatNumber(controller.deliveryEstimates.value['service_charge'] + cart['total_amount'] + controller.deliveryEstimates.value['delivery_fee'] - controller.couponAppliedAmount.value)}"
                            .tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 21.0,
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    // Create a RadioListTile for option 1
                    RadioListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 0.0),
                      title: const Text(
                        'Pay with Wallet',
                      ), // Display the title for option 1
                      subtitle: Text(
                        '₦${Constant.formatNumber(walletController.userWallet.value['balance'] ?? 0.0)}',
                      ), // Display a subtitle for option 1
                      value: "wallet", // Assign a value of 1 to this option
                      groupValue: controller.selectedPaymentMethod.value,
                      onChanged: (value) {
                        onSelectPayment("$value");
                      },
                    ),

                    // Create a RadioListTile for option 2
                    RadioListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 0.0),
                      title: const Text(
                        'Pay with Card',
                      ), // Display the title for option 2
                      // subtitle: const Text(
                      //     'Subtitle for Option 2'), // Display a subtitle for option 2
                      value: "card",
                      groupValue: controller.selectedPaymentMethod.value,
                      onChanged: (value) {
                        onSelectPayment("$value");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  applyCoupon() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final accessToken = Preferences.getString(Preferences.accessTokenKey);

      Map payload = {
        "code": couponEditController.text,
        "vendorId": cart['vendor']['id'],
        "total_amount": cart['total_amount'],
      };

      final response = await APIService().applyCoupon(
        accessToken: accessToken,
        payload: payload,
      );
      debugPrint("PLACE ORDER RESPONSE :::  ${response.body}");
      ShowToastDialog.closeLoader();
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constant.toast(map['message']);
        controller.couponAppliedId.value = map['data']['id'];
        controller.couponAppliedAmount.value = map['data']['deduct'].toDouble();
      } else {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constant.toast(map['message']);
      }
    } catch (e) {
      debugPrint("$e");
      ShowToastDialog.closeLoader();
    }
  }
}
