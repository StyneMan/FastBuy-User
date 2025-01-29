import 'dart:convert';

import 'package:customer/app/auth_screen/otp_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/models/user_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  Rx<TextEditingController> firstNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> lastNameEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> emailEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> phoneNUmberEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> countryCodeEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> passwordEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> conformPasswordEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> referralCodeEditingController =
      TextEditingController().obs;

  RxBool passwordVisible = true.obs;
  RxBool conformPasswordVisible = true.obs;

  RxString code = "NG".obs;
  RxString type = "".obs;

  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    getArgument();
    countryCodeEditingController.value.text = '+234';
    super.onInit();
  }

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      type.value = argumentData['type'];
      userModel.value = argumentData['userModel'];
      if (type.value == "mobileNumber") {
        phoneNUmberEditingController.value.text =
            userModel.value.phoneNumber.toString();
        countryCodeEditingController.value.text =
            userModel.value.countryCode.toString();
      }
    }
  }

  signUpWithEmailAndPassword() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final codeResp = await parse(
        phoneNUmberEditingController.value.text,
        region: code.value,
      );

      Map body = {
        "first_name": firstNameEditingController.value.text.trim(),
        "last_name": lastNameEditingController.value.text.trim(),
        "email_address": emailEditingController.value.text,
        "password": passwordEditingController.value.text,
        "intl_phone_format": "${codeResp['e164']}",
        "phone_number": "${codeResp['national_number']}",
        "iso_code": countryCodeEditingController.value.text,
        "country_code": code.value,
      };

      var resp = await APIService().signup(body);
      debugPrint(resp.body);
      ShowToastDialog.closeLoader();
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        // all good here
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast(map['message']);
        if (!map.containsKey('user') && map['user'] == null) {
          // Prompt user to verify account first
          Get.to(
            OtpScreen(
              type: "signup",
              email: emailEditingController.value.text,
            ),
            arguments: {
              "emailAddress": emailEditingController.value.text,
            },
          );
        }
        // Constant.toast(errorMap['message']);
      } else {
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        Constant.toast(errorMap['message']);
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint(e.toString());
    }
  }
}
