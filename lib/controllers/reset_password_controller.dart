import 'dart:convert';

import 'package:customer/app/auth_screen/login_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmpasswordController =
      TextEditingController().obs;

  RxBool passwordVisible = true.obs;
  RxBool confirmPasswordVisible = true.obs;

  resetPassword({required String email}) async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);

      Map payload = {
        "email_address": email,
        "new_password": passwordController.value.text,
        "confirm_password": confirmpasswordController.value.text,
      };

      final resp = await APIService().resetPassword(body: payload);
      ShowToastDialog.closeLoader();
      debugPrint("${resp.body}");
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        ShowToastDialog.showToast(map['message']);
        Get.to(
          LoginScreen(),
          transition: Transition.cupertino,
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
