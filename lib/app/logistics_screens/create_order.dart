import 'dart:convert';

import 'package:customer/app/auth_screen/otp_screen.dart';
import 'package:customer/app/dash_board_screens/dash_board_screen.dart';
import 'package:customer/app/logistics_screens/form-steps/step1.dart';
import 'package:customer/app/logistics_screens/form-steps/step2.dart';
import 'package:customer/app/wallet_screen/set_wallet_pin.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/dash_board_controller.dart';
import 'package:customer/controllers/logistics_controller.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/controllers/order_controller.dart';
import 'package:customer/controllers/wallet_controller.dart';
import 'package:customer/payment/MercadoPagoScreen.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:provider/provider.dart';

import 'form-steps/step3.dart';
import 'form-steps/step4.dart';

class CreateParcelOrder extends StatefulWidget {
  const CreateParcelOrder({super.key});

  @override
  State<CreateParcelOrder> createState() => _CreateParcelOrderState();
}

class _CreateParcelOrderState extends State<CreateParcelOrder> {
  var formkey = GlobalKey<FormState>();
  final addressController = Get.find<AddressListController>();
  final orderController = Get.find<OrderController>();
  final walletController = Get.find<WalletController>();
  final profileController = Get.find<MyProfileController>();
  final dashboardController = Get.find<DashBoardController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeChange.getThem()
          ? AppThemeData.surfaceDark
          : AppThemeData.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "New Parcel Order".tr,
          style: TextStyle(
            fontSize: 16,
            color: themeChange.getThem()
                ? AppThemeData.grey50
                : AppThemeData.grey900,
            fontFamily: AppThemeData.regular,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: GetX(
        init: LogisticsController(),
        builder: (controller) {
          return LoadingOverlayPro(
            isLoading: controller.isFetchingCost.value,
            backgroundColor: Colors.black45,
            progressIndicator: const CircularProgressIndicator.adaptive(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyStepper(
                  activeStep: controller.activeStep.value,
                  lineStyle: const LineStyle(lineWidth: 50.0),
                  stepShape: StepShape.circle,
                  stepBorderRadius: 15,
                  borderThickness: 3,
                  enableStepTapping: false,
                  padding: const EdgeInsets.all(5.0),
                  stepRadius: 28,
                  finishedStepBorderColor: AppThemeData.secondary300,
                  finishedStepTextColor: AppThemeData.success600,
                  finishedStepBackgroundColor: AppThemeData.success500,
                  activeStepIconColor: Colors.deepOrange,
                  activeStepBackgroundColor: AppThemeData.primary400,
                  unreachedStepBackgroundColor: const Color(0xFFFFF8EF),
                  showLoadingAnimation: false,
                  steps: const [
                    EasyStep(
                      customStep: ClipOval(
                        child: Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ),
                      ),
                      customTitle: Text(
                        'Sender',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipOval(
                        child: Icon(
                          CupertinoIcons.person_alt,
                          color: Colors.white,
                        ),
                      ),
                      customTitle: Text(
                        'Receiver',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipOval(
                        child: Icon(
                          CupertinoIcons.bag_badge_plus,
                          color: Colors.white,
                        ),
                      ),
                      customTitle: Text(
                        'Package',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipOval(
                        child: Icon(
                          CupertinoIcons.money_dollar,
                          color: Colors.white,
                        ),
                      ),
                      customTitle: Text(
                        'Payment',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  onStepReached: (index) =>
                      setState(() => controller.activeStep.value = index),
                ),
                Expanded(
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: controller.activeStep.value == 0
                              ? SenderForm(
                                  controller: controller,
                                  addressController: addressController,
                                )
                              : controller.activeStep.value == 1
                                  ? ReceiverForm(controller: controller)
                                  : controller.activeStep.value == 2
                                      ? PackageForm(controller: controller)
                                      : PaymentForm(
                                          controller: controller,
                                          onSelectPayment: (value) {
                                            orderController
                                                .selectedPaymentMethod
                                                .value = value;
                                          },
                                        ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: SizedBox(),
                              ),
                              Expanded(
                                child: RoundedButtonFill(
                                  title: "Back".tr,
                                  color: AppThemeData.primary300,
                                  textColor: AppThemeData.grey50,
                                  onPress: controller.activeStep.value == 0
                                      ? null
                                      : () async {
                                          if (controller.activeStep.value > 0) {
                                            controller.activeStep.value =
                                                controller.activeStep.value - 1;
                                          }
                                        },
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: RoundedButtonFill(
                                  title: controller.activeStep.value == 3
                                      ? "Confirm Order"
                                      : "Next".tr,
                                  icon: const Icon(
                                      Icons.arrow_forward_ios_outlined),
                                  color: AppThemeData.primary300,
                                  textColor: AppThemeData.grey50,
                                  onPress: () async {
                                    if (formkey.currentState!.validate()) {
                                      if (controller.activeStep.value == 2) {
                                        if (controller
                                            .addedPackages.value.isEmpty) {
                                          Constant.toast("Package not saved");
                                        } else if (controller
                                            .selectedShipping.value.isEmpty) {
                                          Constant.toast(
                                              "Shipping type not selected");
                                        } else {
                                          // Init fetch charge here
                                          await controller.calculateCost();
                                        }
                                      } else if (controller.activeStep.value ==
                                          0) {
                                        if (addressController
                                                .shippingModel.value.location ==
                                            null) {
                                          Constant.toast(
                                              "Pickup address is required!");
                                        } else {
                                          controller.activeStep.value =
                                              controller.activeStep.value + 1;
                                        }
                                      } else if (controller.activeStep.value ==
                                          1) {
                                        if (addressController.receivingModel
                                                .value.location ==
                                            null) {
                                          Constant.toast(
                                              "Receiver's address is required!");
                                        } else {
                                          controller.activeStep.value =
                                              controller.activeStep.value + 1;
                                        }
                                      } else {
                                        // Handle order placement here
                                        if (orderController
                                                .selectedPaymentMethod.value ==
                                            'wallet') {
                                          // Now check for wallet balance and the rest...
                                          if (walletController
                                                  .userWallet.value['balance'] <
                                              (controller.estimateData
                                                  .value['total_cost'])) {
                                            showWalletSheet(
                                              themeChange: themeChange,
                                            );
                                          } else {
                                            // Check if wallet pin is set
                                            if (walletController
                                                    .profileController
                                                    .userData
                                                    .value['wallet_pin'] ==
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
                                                          "${controller.estimateData.value['total_cost']}"), // payable amount here
                                                      "email_address":
                                                          '${profileController.userData.value['email_address']} ',
                                                      "full_name":
                                                          "${profileController.userData.value['first_name']} ${profileController.userData.value['last_name']}",
                                                      "customer_id":
                                                          "${profileController.userData.value['id']}",
                                                      "phone_number":
                                                          "${profileController.userData.value['phone_number']}",
                                                      "title": "Order Purchase",
                                                    },
                                                    "orderInfo": {
                                                      "amount": controller
                                                          .estimateData
                                                          .value['cost'],
                                                      "items": controller
                                                          .addedPackages.value,
                                                      "customerId":
                                                          "${profileController.userData.value['id']}",
                                                      "vendorId": null,
                                                      "riderNote": controller
                                                          .riderNote.value,
                                                      "vendorNote": null,
                                                      "orderType":
                                                          "parcel_order",
                                                      "deliveryType":
                                                          "delivery",
                                                      "paymentMethod":
                                                          orderController
                                                              .selectedPaymentMethod
                                                              .value,
                                                      "deliveryFee": controller
                                                              .estimateData
                                                              .value[
                                                          'delivery_fee'],
                                                      "deliveryTime": controller
                                                              .estimateData
                                                              .value[
                                                          'delivery_time'],
                                                      "deliveryAddress":
                                                          addressController
                                                              .receivingModel
                                                              .value
                                                              .getFullAddress(),
                                                      "deliveryAddrLat":
                                                          "${addressController.location2.value.latitude}",
                                                      "deliveryAddrLng":
                                                          "${addressController.location2.value.longitude}",
                                                      "pickupAddress":
                                                          addressController
                                                              .shippingModel
                                                              .value
                                                              .getFullAddress(),
                                                      "pickupAddrLat":
                                                          "${addressController.location.value.latitude}",
                                                      "pickupAddrLng":
                                                          "${addressController.location.value.longitude}",
                                                      "receiver": {
                                                        "name": controller
                                                            .receiverNameEditingController
                                                            .value
                                                            .text,
                                                        "phone": controller
                                                            .receiverPhoneEditingController
                                                            .value
                                                            .text,
                                                        "email": controller
                                                            .receiverEmailEditingController
                                                            .value
                                                            .text,
                                                        "address":
                                                            addressController
                                                                .receivingModel
                                                                .value
                                                                .getFullAddress(),
                                                      },
                                                      "riderCommission":
                                                          double.parse(
                                                              "${controller.estimateData.value['rider_commission'] ?? "0.0"}"),
                                                    },
                                                  },
                                                ),
                                                transition:
                                                    Transition.cupertino,
                                              );
                                            }
                                          }
                                        } else {
                                          // Init payment here
                                          placeOrder(controller: controller);
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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

  placeOrder({
    required LogisticsController controller,
  }) async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final accessToken = Preferences.getString(Preferences.accessTokenKey);

      Map payload = {
        "userType": "customer",
        "paymentInfo": {
          "amount": double.parse(
              "${controller.estimateData.value['total_cost']}"), // payable amount here
          "email_address":
              '${profileController.userData.value['email_address']}',
          "full_name":
              "${profileController.userData.value['first_name']} ${profileController.userData.value['last_name']}",
          "customer_id": "${profileController.userData.value['id']}",
          "phone_number": "${profileController.userData.value['phone_number']}",
          "title": "Order Purchase",
        },
        "orderInfo": {
          "amount": controller.estimateData.value['cost'],
          "items": controller.addedPackages.value,
          "customerId": "${profileController.userData.value['id']}",
          "vendorId": null,
          "riderNote": controller.riderNote.value,
          "vendorNote": null,
          "orderType": "parcel_order",
          "deliveryType": "delivery",
          "paymentMethod": orderController.selectedPaymentMethod.value,
          "deliveryFee": controller.estimateData.value['delivery_fee'],
          "deliveryTime": controller.estimateData.value['delivery_time'],
          "deliveryAddress":
              addressController.receivingModel.value.getFullAddress(),
          "deliveryAddrLat": "${addressController.location2.value.latitude}",
          "deliveryAddrLng": "${addressController.location2.value.longitude}",
          "pickupAddress":
              addressController.shippingModel.value.getFullAddress(),
          "pickupAddrLat": "${addressController.location.value.latitude}",
          "pickupAddrLng": "${addressController.location.value.longitude}",
          "receiver": {
            "name": controller.receiverNameEditingController.value.text,
            "phone": controller.receiverPhoneEditingController.value.text,
            "email": controller.receiverEmailEditingController.value.text,
            "address": addressController.receivingModel.value.getFullAddress(),
          },
          "riderCommission": double.parse(
              "${controller.estimateData.value['rider_commission'] ?? "0.0"}"),
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
              customerId: profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                orderController.myOrders.value = map;
              }
            });
            // Navigate to the Orders Screen from here
            dashboardController.selectedIndex.value = 3;
            Get.off(
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
}
