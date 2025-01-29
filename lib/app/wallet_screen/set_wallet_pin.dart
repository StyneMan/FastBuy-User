import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SetWalletPin extends StatefulWidget {
  const SetWalletPin({
    super.key,
  });

  @override
  State<SetWalletPin> createState() => _SetWalletPinState();
}

class _SetWalletPinState extends State<SetWalletPin> {
  final newPin = TextEditingController();
  final confirmPin = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final _profileController = Get.find<MyProfileController>();

  bool _hidePin = true;
  bool _hideConfirm = true;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Setup Wallet PIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontFamily: AppThemeData.regular,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFieldWidget(
                title: 'PIN'.tr,
                controller: newPin,
                hintText: 'Enter pin'.tr,
                obscureText: _hidePin,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "PIN is required";
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
                      setState(() {
                        _hidePin = !_hidePin;
                      });
                    },
                    child: _hidePin
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
                height: 16.0,
              ),
              TextFieldWidget(
                title: 'Confirm PIN'.tr,
                controller: confirmPin,
                hintText: 'Enter pin confirmation'.tr,
                obscureText: _hideConfirm,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "PIN confirmation is required";
                  }

                  if (value.toString() != newPin.text) {
                    return "PIN mismatch!";
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
                      setState(() {
                        _hideConfirm = !_hideConfirm;
                      });
                    },
                    child: _hideConfirm
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
            ],
          ),
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
            title: "Save PIN".tr,
            height: 5.5,
            color: AppThemeData.primary300,
            fontSizes: 16,
            onPress: () async {
              if (formKey.currentState!.validate()) {
                setupPin();
              }
            },
          ),
        ),
      ),
    );
  }

  setupPin() async {
    try {
      Get.back();
      ShowToastDialog.showLoader("Please wait".tr);
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      Map payload = {
        "new_pin": newPin.text,
      };

      final response = await APIService().setupWalletPIN(
        accessToken: accessToken,
        payload: payload,
      );
      debugPrint("SET WALLET PIN RESPONSE :::  ${response.body}");
      ShowToastDialog.closeLoader();
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);

        // Upddate profile here
        _profileController.userData.value = map['data'];
      } else {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constant.toast(map['message']);
      }
    } catch (e) {
      debugPrint("$e");
    }
  }
}
