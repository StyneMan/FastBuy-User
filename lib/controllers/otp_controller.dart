import 'dart:convert';

import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  Rx<TextEditingController> otpController = TextEditingController().obs;

  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;
  RxString emailAddress = "".obs;
  RxString verificationId = "".obs;
  RxInt resendToken = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;

    if (argumentData != null) {
      countryCode.value = argumentData['countryCode'];
      phoneNumber.value = argumentData['phoneNumber'];
      emailAddress.value = argumentData['emailAddress'];
      verificationId.value = argumentData['verificationId'];
    }
    isLoading.value = false;
    update();
  }

  sendOTP() async {
    try {
      isLoading.value = true;
      Map body = {
        "email_address": emailAddress.value,
      };

      final resp = await APIService().sendOTP(body: body);
      debugPrint(resp.body);
      isLoading.value = false;
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        ShowToastDialog.showToast(map['message']);
      } else {
        Map<String, dynamic> errMap = jsonDecode(resp.body);
        ShowToastDialog.showToast(errMap['message']);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }

  verifyOTP() async {
    try {
      isLoading.value = true;
      Map body = {
        "email_address": emailAddress.value,
        "code": otpController.value.text,
        "use_case": "account_verification"
      };

      final resp = await APIService().verifyOTP(body: body);
      debugPrint(resp.body);
      isLoading.value = false;
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        ShowToastDialog.showToast(map['message']);
      } else {
        Map<String, dynamic> errMap = jsonDecode(resp.body);
        ShowToastDialog.showToast(errMap['message']);
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
