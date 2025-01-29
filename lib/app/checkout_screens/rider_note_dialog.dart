import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/logistics_controller.dart';
import 'package:customer/controllers/order_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RiderNoteDialog extends StatelessWidget {
  final bool isParcel;
  RiderNoteDialog({super.key, this.isParcel = false});

  final formkey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  final controller = Get.find<OrderController>();
  final parcelcontroller = Get.find<LogisticsController>();

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
                      title: 'Rider note',
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
                            ShowToastDialog.showLoader("Please wait".tr);
                            Future.delayed(const Duration(seconds: 2), () {
                              if (isParcel) {
                                parcelcontroller.riderNote.value =
                                    noteController.text;
                              } else {
                                controller.riderNote.value =
                                    noteController.text;
                              }

                              ShowToastDialog.closeLoader();
                              Get.back();
                            });
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
