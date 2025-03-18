import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RateRiderDialog extends StatelessWidget {
  final String riderId;
  RateRiderDialog({
    super.key,
    required this.riderId,
  });

  final formkey = GlobalKey<FormState>();
  final messageController = TextEditingController();
  final controller = Get.find<MyProfileController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: const EdgeInsets.all(21),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        "What was your experience with this rider (Rider Name)?"),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Center(
                      child: RatingBar.builder(
                        initialRating: controller.ratingVal.value,
                        minRating: 1.0,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 36,
                        allowHalfRating: true,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 6.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: AppThemeData.warning300,
                        ),
                        onRatingUpdate: (double rate) {
                          controller.ratingVal.value = rate;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    TextFieldWidget(
                      title: 'Review message (Optional)',
                      hintText: 'Enter message'.tr,
                      controller: messageController,
                      maxLine: 3,
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: RoundedButtonFill(
                        title: "Save".tr,
                        height: 5.5,
                        color: AppThemeData.primary300,
                        textColor: AppThemeData.grey50,
                        fontSizes: 16,
                        onPress: () async {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  submitReview() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      Map _body = {
        "message": messageController.text,
        "reviewer_id": controller.userData.value['id'],
        "user_type": messageController.text,
        "rating": controller.ratingVal.value,
      };

      final accessToken = Preferences.getString(
        Preferences.accessTokenKey,
      );
      final response = await APIService().reviewRider(
        payload: _body,
        riderId: riderId,
        accessToken: accessToken,
      );

      debugPrint("rEVIEW RIDER RESPONSE ::: ${response.body}");
      ShowToastDialog.closeLoader();
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);
        Constant.toast(map['message']);
        Get.back();
      } else {
        Map<String, dynamic> error = jsonDecode(response.body);
        Constant.toast(error['message']);
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint("$e");
    }
  }
}
