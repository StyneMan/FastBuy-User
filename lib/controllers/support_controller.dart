import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SupportController extends GetxController {
  final profileController = Get.find<MyProfileController>();
  RxBool isLoading = false.obs;

  Rx<TextEditingController> subjectController = TextEditingController().obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
  }

  saveSupport() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      isLoading.value = true;
      Map _body = {
        "subject": subjectController.value.text,
        "message": messageController.value.text,
        "email_address": profileController.userData.value['email_address'],
        "first_name": profileController.userData.value['first_name'],
        "last_name": profileController.userData.value['last_name'],
        "support_type": "customer",
      };

      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      final response = await APIService().saveSupport(
        payload: _body,
        accessToken: accessToken,
      );

      debugPrint("SUPPORT RESPONSE ::: ${response.body}");
      ShowToastDialog.closeLoader();
      isLoading.value = false;
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constant.toast(map['message']);

        Get.back(result: true);
      } else {
        Map<String, dynamic> error = jsonDecode(response.body);
        Constant.toast(error['message']);
      }
    } catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      if (kDebugMode) {
        print("ERROR PROFILE UPDDATE :: $e");
      }
    }
  }

  final ImagePicker _imagePicker = ImagePicker();
  RxString profileImage = "".obs;

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      profileImage.value = image.path;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }
}
