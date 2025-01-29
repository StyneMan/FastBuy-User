import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/models/user_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final profileController = Get.find<MyProfileController>();
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;

  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> countryCodeController =
      TextEditingController(text: "+234").obs;

  final cloudinary = Cloudinary.full(
    apiKey: '833281127161936',
    apiSecret: 'oLfUxTbYmdoQJwKGd64hje3m_Sc',
    cloudName: 'dgmelutoi',
  );

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    if (profileController.userData.value.isNotEmpty) {
      firstNameController.value.text =
          profileController.userData.value['first_name'].toString();
      lastNameController.value.text =
          profileController.userData.value['last_name'].toString();
      emailController.value.text =
          profileController.userData.value['email_address'].toString();
      phoneNumberController.value.text =
          profileController.userData.value['phone_number'].toString();
      countryCodeController.value.text =
          profileController.userData.value['iso_code'].toString();
      profileImage.value =
          profileController.userData.value['photo_url'].toString();
    }

    isLoading.value = false;
  }

  saveData() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      if (Constant().hasValidUrl(profileImage.value) == false &&
          profileImage.value.isNotEmpty) {
        // Upload image to cloudinary temporarily here

        final resp = await cloudinary.uploadResource(
          CloudinaryUploadResource(
            uploadPreset: 'ml_default',
            filePath: File(profileImage.value).path,
            fileBytes: File(profileImage.value).readAsBytesSync(),
            resourceType: CloudinaryResourceType.image,
            progressCallback: (count, total) {
              // print('Uploading image from file with progress: $count/$total');
            },
          ),
        );

        if (resp.isSuccessful) {
          // print('Get your image from with ${resp.secureUrl}');

          Map _body = {
            "first_name": firstNameController.value.text,
            "last_name": lastNameController.value.text,
            "photo_url": "${resp.secureUrl}",
          };

          final accessToken = Preferences.getString(Preferences.accessTokenKey);
          final response = await APIService().updateProfile(
            payload: _body,
            accessToken: accessToken,
          );

          debugPrint("PROFILE UPDATE RESPONSE ::: ${response.body}");
          ShowToastDialog.closeLoader();
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(response.body);
            profileController.userData.value = map['user'];
            Constant.toast(map['message']);
            Get.back(result: true);
          } else {
            Map<String, dynamic> error = jsonDecode(response.body);
            Constant.toast(error['message']);
          }
        }
      } else {
        Map _body = {
          "first_name": firstNameController.value.text,
          "last_name": lastNameController.value.text,
        };

        final accessToken = Preferences.getString(Preferences.accessTokenKey);
        final response = await APIService().updateProfile(
          payload: _body,
          accessToken: accessToken,
        );

        debugPrint("PROFILE UPDATE RESPONSE ::: ${response.body}");
        ShowToastDialog.closeLoader();
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(response.body);
          Constant.toast(map['message']);
          profileController.userData.value = map['user'];
          Get.back(result: true);
        } else {
          Map<String, dynamic> error = jsonDecode(response.body);
          Constant.toast(error['message']);
        }
      }
    } catch (e) {
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
