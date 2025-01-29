import 'dart:convert';

import 'package:customer/app/auth_screen/otp_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:get/get.dart';

class PhoneNumberController extends GetxController {
  Rx<TextEditingController> phoneNUmberEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> countryCodeEditingController =
      TextEditingController().obs;

  RxString code = "NG".obs;

  @override
  void onInit() {
    super.onInit();
    countryCodeEditingController.value.text = '+234';
  }

  sendCode() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);

      final codeResp = await parse(
        phoneNUmberEditingController.value.text,
        region: code.value,
      );
      debugPrint("UEIWD ::: $codeResp");
      Map body = {
        "phone_number": "${codeResp['national_number']}",
        "intl_phone_number": "${codeResp['e164']}",
      };

      final resp = await APIService().loginPhone(body);
      debugPrint(resp.body);
      ShowToastDialog.closeLoader();
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        // all good here
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast(map['message']);

        Get.to(
          OtpScreen(
            type: "phone",
            region: code.value,
            phone: phoneNUmberEditingController.value.text,
          ),
          arguments: {
            "emailAddress": phoneNUmberEditingController.value.text,
          },
        );
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
