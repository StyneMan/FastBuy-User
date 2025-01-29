import 'dart:convert';

import 'package:customer/app/auth_screen/otp_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  Rx<TextEditingController> emailEditingController =
      TextEditingController().obs;

  forgotPassword() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      Map paayload = {
        "email_address": emailEditingController.value.text,
      };

      final resp = await APIService().forgotPass(paayload);
      debugPrint("${resp.body}");
      ShowToastDialog.closeLoader();
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast(map['message']);
        Get.to(
          OtpScreen(
            type: "password",
            email: emailEditingController.value.text,
          ),
        );
      } else {
        Map<String, dynamic> errMap = jsonDecode(resp.body);
        Constant.toast(errMap['message']);
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
    }
  }
}
