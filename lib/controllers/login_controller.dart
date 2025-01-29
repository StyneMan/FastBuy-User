import 'dart:convert';

import 'package:customer/app/auth_screen/otp_screen.dart';
import 'package:customer/app/dash_board_screens/dash_board_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Inject ProfileController
  final MyProfileController _profileController =
      Get.find<MyProfileController>();

  Rx<TextEditingController> emailEditingController =
      TextEditingController().obs;
  Rx<TextEditingController> passwordEditingController =
      TextEditingController().obs;

  RxBool passwordVisible = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  loginWithEmailAndPassword() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      Map body = {
        "email_address": emailEditingController.value.text,
        "password": passwordEditingController.value.text,
      };

      var resp = await APIService().login(body);
      debugPrint(resp.body);
      ShowToastDialog.closeLoader();
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        // all good here
        Map<String, dynamic> map = jsonDecode("${resp.body}");
        Constant.toast(map['message']);

        if (map.containsKey('user') && map['user'] != null) {
          // Go to dashboard here and persist token and user data here
          Preferences.setString(Preferences.accessTokenKey, map['accessToken']);
          Constant.toast(map['message']);
          //Store access token her
          _profileController.setProfile(map['user']);

          // Now navigate to dashboard from here
          Get.off(
            const DashBoardScreen(),
            transition: Transition.cupertino,
          );
        } else {
          // Prompt user to verify account first
          debugPrint(
              "EMAIL ADDRESS CHECK ::: ${emailEditingController.value.text}");
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
      } else {
        Map<String, dynamic> errorMap = jsonDecode("${resp.body}");
        Constant.toast(errorMap['message']);
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint(e.toString());
    }
  }
}
