import 'dart:async';
import 'dart:convert';

import 'package:customer/app/auth_screen/login_screen.dart';
import 'package:customer/app/dash_board_screens/dash_board_screen.dart';
import 'package:customer/app/on_boarding_screen.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final _profileController = Get.find<MyProfileController>();
  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  redirectScreen() async {
    if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey) == false) {
      Get.offAll(const OnBoardingScreen());
    } else {
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      if (accessToken.isNotEmpty) {
        // Now get user profile again
        try {
          var resp = await APIService().getProfile(accessToken: accessToken);
          if (resp.statusCode >= 200 && resp.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(resp.body);
            _profileController.setProfile(map);
            Get.offAll(const DashBoardScreen());
          } else if (resp.statusCode == 401) {
            // Session expired. logout user now
            Preferences.setString(Preferences.accessTokenKey, "");
            Get.offAll(LoginScreen());
          }
        } catch (e) {
          debugPrint(e.toString());
        }

        // await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        //     .then((value) async {
        //   if (value != null) {
        //     UserModel userModel = value;
        //     log(userModel.toJson().toString());
        //     if (userModel.role == Constant.userRoleCustomer) {
        //       if (userModel.active == true) {
        //         userModel.fcmToken = await NotificationService.getToken();
        //         await FireStoreUtils.updateUser(userModel);
        //         if (userModel.shippingAddress != null &&
        //             userModel.shippingAddress!.isNotEmpty) {
        //           if (userModel.shippingAddress!
        //               .where((element) => element.isDefault == true)
        //               .isNotEmpty) {
        //             Constant.selectedLocation = userModel.shippingAddress!
        //                 .where((element) => element.isDefault == true)
        //                 .single;
        //           } else {
        //             Constant.selectedLocation =
        //                 userModel.shippingAddress!.first;
        //           }
        //           Get.offAll(const DashBoardScreen());
        //         } else {
        //           Get.offAll(const LocationPermissionScreen());
        //         }
        //       } else {
        //         await FirebaseAuth.instance.signOut();
        //         Get.offAll(LoginScreen());
        //       }
        //     } else {
        //       await FirebaseAuth.instance.signOut();
        //       Get.offAll(LoginScreen());
        //     }
        //   }
        // });
      } else {
        // await FirebaseAuth.instance.signOut();
        Preferences.setString(Preferences.accessTokenKey, "");
        Get.offAll(LoginScreen());
      }
    }
  }
}
