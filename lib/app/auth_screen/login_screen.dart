import 'dart:io';

import 'package:customer/app/auth_screen/phone_number_screen.dart';
import 'package:customer/app/auth_screen/signup_screen.dart';
import 'package:customer/app/dash_board_screens/dash_board_screen.dart';
import 'package:customer/app/forgot_password_screen/forgot_password_screen.dart';
import 'package:customer/app/location_permission_screen/location_permission_screen.dart';
import 'package:customer/controllers/login_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_border.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surfaceDark
                : AppThemeData.primary50,
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.primary50,
              actions: [
                InkWell(
                  onTap: () async {
                    final lat = Preferences.getString(Preferences.currLatitude);
                    final lng = Preferences.getString(Preferences.currLatitude);
                    LocationPermission permission =
                        await Geolocator.checkPermission();
                    if (permission == LocationPermission.always ||
                        permission == LocationPermission.whileInUse) {
                      if (lat.isEmpty || lng.isEmpty) {
                        Get.offAll(const LocationPermissionScreen());
                      } else {
                        Get.offAll(const DashBoardScreen());
                      }
                    } else {
                      Get.offAll(const LocationPermissionScreen());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Guest mode".tr,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.primary300
                            : AppThemeData.primary300,
                        fontSize: 16,
                        fontFamily: AppThemeData.semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              color: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.primary50,
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back! 👋".tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.primary500,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          fontFamily: AppThemeData.semiBold,
                        ),
                      ),
                      Text(
                        "Log in to continue enjoying delicious food delivered to your doorstep."
                            .tr,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey400
                              : AppThemeData.grey500,
                          fontSize: 16,
                          fontFamily: AppThemeData.regular,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFieldWidget(
                        title: 'Email Address'.tr,
                        controller: controller.emailEditingController.value,
                        hintText: 'Enter email address'.tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                              .hasMatch(value!)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        prefix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            "assets/icons/ic_mail.svg",
                            colorFilter: ColorFilter.mode(
                              themeChange.getThem()
                                  ? AppThemeData.grey300
                                  : AppThemeData.grey600,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      TextFieldWidget(
                        title: 'Password'.tr,
                        controller: controller.passwordEditingController.value,
                        hintText: 'Enter password'.tr,
                        obscureText: controller.passwordVisible.value,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        prefix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            "assets/icons/ic_lock.svg",
                            colorFilter: ColorFilter.mode(
                              themeChange.getThem()
                                  ? AppThemeData.grey300
                                  : AppThemeData.grey600,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        suffix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: InkWell(
                            onTap: () {
                              controller.passwordVisible.value =
                                  !controller.passwordVisible.value;
                            },
                            child: controller.passwordVisible.value
                                ? SvgPicture.asset(
                                    "assets/icons/ic_password_show.svg",
                                    colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.grey300
                                          : AppThemeData.grey600,
                                      BlendMode.srcIn,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    "assets/icons/ic_password_close.svg",
                                    colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.grey300
                                          : AppThemeData.grey600,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Get.to(ForgotPasswordScreen());
                          },
                          child: Text(
                            "Forgot Password".tr,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: AppThemeData.secondary300,
                              color: themeChange.getThem()
                                  ? AppThemeData.secondary300
                                  : AppThemeData.secondary300,
                              fontSize: 14,
                              fontFamily: AppThemeData.regular,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RoundedButtonFill(
                        title: "Login".tr,
                        color: AppThemeData.primary300,
                        textColor: AppThemeData.grey50,
                        onPress: () async {
                          if (formkey.currentState!.validate()) {
                            controller.loginWithEmailAndPassword();
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          children: [
                            const Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Text(
                                "or".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey500
                                      : AppThemeData.grey400,
                                  fontSize: 16,
                                  fontFamily: AppThemeData.medium,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      RoundedButtonBorder(
                        borderColor: AppThemeData.secondary300,
                        title: "Continue with Mobile Number".tr,
                        textColor: AppThemeData.secondary300,
                        icon: SvgPicture.asset("assets/icons/ic_phone.svg"),
                        isRight: false,
                        onPress: () async {
                          Get.to(PhoneNumberScreen());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              color: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.primary50,
              padding:
                  EdgeInsets.symmetric(vertical: Platform.isAndroid ? 10 : 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Didn’t have an account?'.tr,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontFamily: AppThemeData.medium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const WidgetSpan(
                          child: SizedBox(
                            width: 10,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(SignupScreen());
                            },
                          text: 'Sign up'.tr,
                          style: TextStyle(
                              color: AppThemeData.primary300,
                              fontFamily: AppThemeData.bold,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: AppThemeData.primary300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
