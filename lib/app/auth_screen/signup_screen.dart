import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/signup_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SignupController(),
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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create an Account".tr,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.secondary300,
                            fontSize: 22,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          "Sign up to start your food adventure with FastBuy"
                              .tr,
                          style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey400
                                  : AppThemeData.grey500,
                              fontSize: 16,
                              fontFamily: AppThemeData.regular),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldWidget(
                                title: 'First Name'.tr,
                                controller:
                                    controller.firstNameEditingController.value,
                                hintText: 'Enter First Name'.tr,
                                prefix: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_user.svg",
                                    colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.grey300
                                          : AppThemeData.grey600,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "First name is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFieldWidget(
                                title: 'Last Name'.tr,
                                controller:
                                    controller.lastNameEditingController.value,
                                hintText: 'Enter Last Name'.tr,
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "Last name is required";
                                  }
                                  return null;
                                },
                                prefix: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_user.svg",
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
                          ],
                        ),
                        TextFieldWidget(
                          title: 'Email Address'.tr,
                          textInputType: TextInputType.emailAddress,
                          controller: controller.emailEditingController.value,
                          hintText: 'Enter Email Address'.tr,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                                    '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
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
                          title: 'Phone Number'.tr,
                          controller:
                              controller.phoneNUmberEditingController.value,
                          hintText: 'Enter Phone Number'.tr,
                          enable: controller.type.value == "mobileNumber"
                              ? false
                              : true,
                          textInputType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "Phone number is required";
                            }
                            return null;
                          },
                          prefix: CountryCodePicker(
                            enabled: controller.type.value == "mobileNumber"
                                ? false
                                : true,
                            onChanged: (value) {
                              controller.countryCodeEditingController.value
                                  .text = value.dialCode.toString();
                              controller.code.value = value.code.toString();
                            },
                            dialogTextStyle: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppThemeData.medium),
                            dialogBackgroundColor: themeChange.getThem()
                                ? AppThemeData.grey800
                                : AppThemeData.grey100,
                            initialSelection: controller
                                .countryCodeEditingController.value.text,
                            comparator: (a, b) =>
                                b.name!.compareTo(a.name.toString()),
                            textStyle: TextStyle(
                                fontSize: 14,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                                fontFamily: AppThemeData.medium),
                            searchDecoration: InputDecoration(
                                iconColor: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900),
                            searchStyle: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppThemeData.medium),
                          ),
                        ),
                        controller.type.value == "mobileNumber"
                            ? const SizedBox()
                            : Column(
                                children: [
                                  TextFieldWidget(
                                    title: 'Password'.tr,
                                    controller: controller
                                        .passwordEditingController.value,
                                    hintText: 'Enter Password'.tr,
                                    obscureText:
                                        controller.passwordVisible.value,
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
                                                !controller
                                                    .passwordVisible.value;
                                          },
                                          child: controller
                                                  .passwordVisible.value
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
                                                )),
                                    ),
                                  ),
                                  // TextFieldWidget(
                                  //   title: 'Confirm Password'.tr,
                                  //   controller: controller
                                  //       .conformPasswordEditingController.value,
                                  //   hintText: 'Enter Confirm Password'.tr,
                                  //   validator: (value) {
                                  //     if (value.toString().isEmpty) {
                                  //       return "Password confirmation is required";
                                  //     }
                                  //     return null;
                                  //   },
                                  //   obscureText:
                                  //       controller.conformPasswordVisible.value,
                                  //   prefix: Padding(
                                  //     padding: const EdgeInsets.all(12),
                                  //     child: SvgPicture.asset(
                                  //       "assets/icons/ic_lock.svg",
                                  //       colorFilter: ColorFilter.mode(
                                  //         themeChange.getThem()
                                  //             ? AppThemeData.grey300
                                  //             : AppThemeData.grey600,
                                  //         BlendMode.srcIn,
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   suffix: Padding(
                                  //     padding: const EdgeInsets.all(12),
                                  //     child: InkWell(
                                  //         onTap: () {
                                  //           controller.conformPasswordVisible
                                  //                   .value =
                                  //               !controller
                                  //                   .conformPasswordVisible
                                  //                   .value;
                                  //         },
                                  //         child: controller
                                  //                 .conformPasswordVisible.value
                                  //             ? SvgPicture.asset(
                                  //                 "assets/icons/ic_password_show.svg",
                                  //                 colorFilter: ColorFilter.mode(
                                  //                   themeChange.getThem()
                                  //                       ? AppThemeData.grey300
                                  //                       : AppThemeData.grey600,
                                  //                   BlendMode.srcIn,
                                  //                 ),
                                  //               )
                                  //             : SvgPicture.asset(
                                  //                 "assets/icons/ic_password_close.svg",
                                  //                 colorFilter: ColorFilter.mode(
                                  //                   themeChange.getThem()
                                  //                       ? AppThemeData.grey300
                                  //                       : AppThemeData.grey600,
                                  //                   BlendMode.srcIn,
                                  //                 ),
                                  //               )),
                                  //   ),
                                  // ),
                                ],
                              ),
                        TextFieldWidget(
                          title: 'Referral Code(Optional)'.tr,
                          controller:
                              controller.referralCodeEditingController.value,
                          hintText: 'Referral Code(Optional)'.tr,
                        ),
                        RoundedButtonFill(
                          title: "Signup".tr,
                          color: AppThemeData.primary300,
                          textColor: AppThemeData.grey50,
                          onPress: () {
                            if (formkey.currentState!.validate()) {
                              controller.signUpWithEmailAndPassword();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
