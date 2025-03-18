import 'dart:convert';

import 'package:customer/app/dash_board_screens/dash_board_screen.dart';
import 'package:customer/app/forgot_password_screen/reset_password_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/dash_board_controller.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/controllers/otp_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String type, email, phone, region;
  final Map? payload;
  OtpScreen({
    super.key,
    this.type = "signup",
    this.email = "",
    this.phone = "",
    this.region = "",
    this.payload,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  var isCompleted = false;
  final _controller = Get.find<OtpController>();
  final _profileController = Get.find<MyProfileController>();
  final _dashboardController = Get.put(DashBoardController());

  _sendOTP() async {
    if (widget.type == "phone" || widget.phone.isNotEmpty) {
      try {
        ShowToastDialog.showLoader("Please wait".tr);
        final codeResp = await parse(
          widget.phone,
          region: widget.region,
        );

        Map body = {
          "phone_number": "${codeResp['national_number']}",
          "intl_phone_number": "${codeResp['e164']}",
        };

        final resp = await APIService().loginPhone(body);
        debugPrint(resp.body);
        ShowToastDialog.closeLoader();
        if (resp.statusCode >= 200 && resp.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          ShowToastDialog.showToast(map['message']);
        } else {
          Map<String, dynamic> errMap = jsonDecode(resp.body);
          ShowToastDialog.showToast(errMap['message']);
        }
      } catch (e) {
        ShowToastDialog.closeLoader();
        debugPrint(e.toString());
      }
    } else {
      try {
        ShowToastDialog.showLoader("Please wait".tr);
        Map body = {
          "email_address": widget.email,
        };

        final resp = await APIService().sendOTP(body: body);
        debugPrint(resp.body);
        ShowToastDialog.closeLoader();
        if (resp.statusCode >= 200 && resp.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          ShowToastDialog.showToast(map['message']);
        } else {
          Map<String, dynamic> errMap = jsonDecode(resp.body);
          ShowToastDialog.showToast(errMap['message']);
        }
      } catch (e) {
        ShowToastDialog.closeLoader();
        debugPrint(e.toString());
      }
    }
  }

  _verifyOTP() async {
    try {
      if (widget.type == "phone" || widget.phone.isNotEmpty) {
        ShowToastDialog.showLoader("Please wait".tr);
        final codeResp = await parse(
          widget.phone,
          region: widget.region,
        );

        Map body = {
          "phone_number": "${codeResp['national_number']}".trim(),
          "code": _otpController.text,
        };

        final resp = await APIService().verifPhoneOTP(body: body);
        debugPrint(resp.body);
        ShowToastDialog.closeLoader();
        if (resp.statusCode >= 200 && resp.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          Constant.toast(map['message']);
          if (map.containsKey("accessToken") && map['user'] != null) {
            //Store access token here
            Preferences.setString(
                Preferences.accessTokenKey, map['accessToken']);
            _profileController.setProfile(map['user']);

            try {
              String token = await NotificationService.getToken();
              debugPrint(":::::::TOKEN:::::: $token");
              Map payload = {
                "token": token,
              };
              var tokenResp = await APIService().updateFCMToken(
                  accessToken: map['accessToken'], body: payload);
              debugPrint("UPDATE FCM RESPONSE ::: ${tokenResp.body}");
              if (tokenResp.statusCode >= 200 && tokenResp.statusCode <= 299) {
                Map<String, dynamic> fcmMap = jsonDecode(tokenResp.body);
                _profileController.setProfile(fcmMap['user']);
                // Now navigate to dashboard from here
              } else {
                Map<String, dynamic> errorMap = jsonDecode(resp.body);
                Constant.toast(errorMap['message']);
              }
            } catch (e) {
              debugPrint("$e");
            }

            Get.off(
              const DashBoardScreen(),
              transition: Transition.cupertino,
            );
          }
        } else {
          Map<String, dynamic> errMap = jsonDecode(resp.body);
          Constant.toast(errMap['message']);
        }
      } else if (widget.type == "password") {
        ShowToastDialog.showLoader("Please wait".tr);
        Map body = {
          "email_address": widget.email,
          "code": _otpController.text,
          // "use_case": "account_verification"
        };

        final resp = await APIService().verifyOTP(body: body);
        debugPrint(resp.body);
        ShowToastDialog.closeLoader();
        if (resp.statusCode >= 200 && resp.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          Constant.toast(map['message']);
          Get.off(
            ResetPasswordScreen(
              email: widget.email,
            ),
            transition: Transition.cupertino,
          );
        } else {
          Map<String, dynamic> errMap = jsonDecode(resp.body);
          Constant.toast(errMap['message']);
        }
      } else {
        ShowToastDialog.showLoader("Please wait".tr);
        Map body = {
          "email_address": widget.email,
          "code": _otpController.text,
          "use_case": "account_verification"
        };

        final resp = await APIService().verifyOTP(body: body);
        debugPrint(resp.body);
        ShowToastDialog.closeLoader();
        if (resp.statusCode >= 200 && resp.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          Constant.toast(map['message']);
          if (map.containsKey("accessToken") && map['user'] != null) {
            //Store access token here
            Preferences.setString(
                Preferences.accessTokenKey, map['accessToken']);
            _profileController.setProfile(map['user']);

            // Now navigate to dashboard from here
            Get.off(
              const DashBoardScreen(),
              transition: Transition.cupertino,
            );
          }
        } else {
          Map<String, dynamic> errMap = jsonDecode(resp.body);
          Constant.toast(errMap['message']);
        }
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint(e.toString());
    }
  }

  placeOrderWallet() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      Map body = {
        ...?widget.payload,
        "wallet_pin": _otpController.text,
      };

      final resp = await APIService().orderWithWallet(
        payload: body,
        accessToken: accessToken,
      );
      debugPrint(resp.body);

      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        APIService()
            .getOrdersStreamed(
          accessToken: accessToken,
          customerId: _profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            _dashboardController.orderController.myOrders.value = map['data'];
            _dashboardController.orderController.hasMoreOrders.value =
                int.parse("${map['totalPages']}") >
                        int.parse("${map['currentPage']}")
                    ? true
                    : false;
            _dashboardController.orderController.ordersCurrentPage.value =
                int.parse("${map['currentPage']}");
          }
        });
        APIService()
            .getWalletStreamed(
          accessToken: accessToken,
          customerId: _profileController.userData.value['id'],
        )
            .listen((onData) {
          // debugPrint("MY WALLET  :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            _dashboardController.walletController.userWallet.value = map;
          }
        });
        ShowToastDialog.closeLoader();
        Constant.toast(map['message']);
        _dashboardController.selectedIndex.value = 3;
        Get.offAll(
          const DashBoardScreen(),
          transition: Transition.cupertino,
        );
      } else {
        Map<String, dynamic> errMap = jsonDecode(resp.body);
        Constant.toast(errMap['message']);
        ShowToastDialog.closeLoader();
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeChange.getThem()
            ? AppThemeData.surfaceDark
            : AppThemeData.surface,
      ),
      body: _controller.isLoading.value
          ? Constant.loader()
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.type == "phone"
                          ? "Verify Your Number 📱".tr
                          : widget.type == "wallet"
                              ? "Enter Wallet PIN"
                              : widget.type == "password"
                                  ? "Verify OTP code"
                                  : "Verify Email Address",
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontSize: 22,
                        fontFamily: AppThemeData.semiBold,
                      ),
                    ),
                    Text(
                      widget.type == "phone"
                          ? "Enter the OTP sent to your mobile number. ${Constant.maskingString(widget.phone, 3)}"
                              .tr
                          : widget.type == "wallet"
                              ? "Enter your wallet pin to proceed"
                              : "Enter the OTP sent to your email address ${widget.email}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey200
                            : AppThemeData.grey700,
                        fontSize: 16,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: PinCodeTextField(
                        length: 4,
                        appContext: context,
                        keyboardType: TextInputType.phone,
                        enablePinAutofill: true,
                        obscureText: widget.type == "wallet" ? true : false,
                        hintCharacter: "-",
                        textStyle: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.regular,
                        ),
                        pinTheme: PinTheme(
                          fieldHeight: 50,
                          fieldWidth: 56,
                          inactiveFillColor: themeChange.getThem()
                              ? AppThemeData.grey900
                              : AppThemeData.grey50,
                          selectedFillColor: themeChange.getThem()
                              ? AppThemeData.grey900
                              : AppThemeData.grey50,
                          activeFillColor: themeChange.getThem()
                              ? AppThemeData.grey900
                              : AppThemeData.grey50,
                          selectedColor: themeChange.getThem()
                              ? AppThemeData.grey900
                              : AppThemeData.grey50,
                          activeColor: themeChange.getThem()
                              ? AppThemeData.primary300
                              : AppThemeData.primary300,
                          inactiveColor: themeChange.getThem()
                              ? AppThemeData.grey900
                              : AppThemeData.grey50,
                          disabledColor: themeChange.getThem()
                              ? AppThemeData.grey900
                              : AppThemeData.grey50,
                          shape: PinCodeFieldShape.box,
                          errorBorderColor: themeChange.getThem()
                              ? AppThemeData.grey600
                              : AppThemeData.grey300,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        cursorColor: AppThemeData.primary300,
                        enableActiveFill: true,
                        controller: _otpController,
                        onCompleted: (v) async {
                          setState(() {
                            isCompleted = true;
                          });
                        },
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    RoundedButtonFill(
                      title: widget.type == "wallet"
                          ? "Pay Now"
                          : "Verify & Next".tr,
                      color: AppThemeData.primary300,
                      textColor: AppThemeData.grey50,
                      onPress: () async {
                        if (isCompleted) {
                          if (widget.type == "wallet") {
                            // Pay with wallet here
                            if (widget.payload == null) {
                              Constant.toast("Payload not provided");
                            } else {
                              placeOrderWallet();
                            }
                          } else {
                            _verifyOTP();
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    widget.type == "wallet"
                        ? const SizedBox()
                        : Text.rich(
                            textAlign: TextAlign.start,
                            TextSpan(
                              text: "${'Did’t receive any code? '.tr} ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey100
                                    : AppThemeData.grey800,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _sendOTP();
                                    },
                                  text: 'Send Again'.tr,
                                  style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.primary300
                                          : AppThemeData.primary300,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: AppThemeData.medium,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppThemeData.primary300),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
    );
  }
}
