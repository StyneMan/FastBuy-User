import 'package:customer/controllers/reset_password_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  ResetPasswordScreen({
    super.key,
    required this.email,
  });

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ResetPasswordController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surfaceDark
                : AppThemeData.primary50,
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.primary50,
            ),
            body: Form(
              key: formkey,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                children: [
                  Text(
                    "Reset Password".tr,
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
                    "Enter your new password here".tr,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey500,
                      fontSize: 16,
                      fontFamily: AppThemeData.regular,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFieldWidget(
                    title: 'New Password'.tr,
                    controller: controller.passwordController.value,
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
                  TextFieldWidget(
                    title: 'Confirm Password'.tr,
                    controller: controller.confirmpasswordController.value,
                    hintText: 'Enter password'.tr,
                    obscureText: controller.confirmPasswordVisible.value,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Password confirmation is required";
                      }
                      if (value.toString() !=
                          controller.passwordController.value.text) {
                        return "Password does not match!";
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
                          controller.confirmPasswordVisible.value =
                              !controller.confirmPasswordVisible.value;
                        },
                        child: controller.confirmPasswordVisible.value
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
                  const SizedBox(
                    height: 32,
                  ),
                  RoundedButtonFill(
                    title: "Reset Password".tr,
                    color: AppThemeData.primary300,
                    textColor: AppThemeData.grey50,
                    onPress: () {
                      if (formkey.currentState!.validate()) {
                        controller.resetPassword(email: email);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
