import 'package:customer/app/auth_screen/login_screen.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmpasswordController =
      TextEditingController().obs;

  RxBool passwordVisible = true.obs;
  RxBool confirmPasswordVisible = true.obs;
  resetPassword() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      // await FirebaseAuth.instance.sendPasswordResetEmail(
      //   email: emailEditingController.value.text,
      // );
      Future.delayed(const Duration(seconds: 2), () {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Password reset successfully. Login to continue');
        Get.to(
          LoginScreen(),
          transition: Transition.cupertino,
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ShowToastDialog.showToast('No user found for that email.');
      }
    }
  }
}
