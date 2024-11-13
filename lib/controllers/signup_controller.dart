import 'package:customer/app/auth_screen/otp_screen.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/models/user_model.dart';
import 'package:flutter/material.dart';
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
    signUp();
  }

  signUp() async {
    ShowToastDialog.showLoader("Please wait".tr);
    Future.delayed(const Duration(seconds: 3), () {
      ShowToastDialog.closeLoader();
      Get.to(
        const OtpScreen(
          type: "signup",
        ),
        arguments: {
          "countryCode": countryCodeEditingController.value.text,
          "phoneNumber": phoneNUmberEditingController.value.text,
          "verificationId": "1234",
          "emailAddress": emailEditingController.value.text,
        },
      );
    });
    ShowToastDialog.closeLoader();
  }
}
