import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class VendorNoteDialog extends StatelessWidget {
  final String cartId;
  VendorNoteDialog({
    super.key,
    required this.cartId,
  });

  final formkey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 16),
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldWidget(
                      title: 'Vendor note',
                      hintText: 'Enter message'.tr,
                      controller: noteController,
                      maxLine: 3,
                    ),
                    const SizedBox(
                      height: 9.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: RoundedButtonFill(
                        title: "Save".tr,
                        height: 5.5,
                        color: AppThemeData.primary300,
                        textColor: AppThemeData.grey50,
                        fontSizes: 16,
                        onPress: () async {
                          if (formkey.currentState!.validate()) {
                            try {
                              ShowToastDialog.showLoader("Please wait".tr);
                              Map _body = {
                                "vendor_note": noteController.text,
                              };

                              final accessToken = Preferences.getString(
                                Preferences.accessTokenKey,
                              );
                              final response = await APIService().updateCart(
                                payload: _body,
                                cartId: cartId,
                                accessToken: accessToken,
                              );

                              debugPrint(
                                  "VENDOR NOTE RESPONSE ::: ${response.body}");
                              ShowToastDialog.closeLoader();
                              if (response.statusCode >= 200 &&
                                  response.statusCode <= 299) {
                                Map<String, dynamic> map =
                                    jsonDecode(response.body);
                                Constant.toast(map['message']);
                                controller.refreshCart();
                                Get.back();
                              } else {
                                Map<String, dynamic> error =
                                    jsonDecode(response.body);
                                Constant.toast(error['message']);
                              }
                            } catch (e) {
                              ShowToastDialog.closeLoader();
                              debugPrint("$e");
                            }
                          }
                        },
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
}
