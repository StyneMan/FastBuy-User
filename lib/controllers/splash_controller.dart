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
      } else {
        // await FirebaseAuth.instance.signOut();
        Preferences.setString(Preferences.accessTokenKey, "");
        Get.offAll(LoginScreen());
      }
    }
  }
}
