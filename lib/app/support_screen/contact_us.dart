import 'package:customer/controllers/support_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SupportController>(
        init: SupportController(),
        builder: (controller) {
          return LoadingOverlayPro(
            isLoading: controller.isLoading.value,
            backgroundColor: Colors.black45,
            progressIndicator: const CircularProgressIndicator.adaptive(),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                titleSpacing: 0,
                backgroundColor: themeChange.getThem()
                    ? AppThemeData.surfaceDark
                    : AppThemeData.surface,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Support".tr,
                        style: TextStyle(
                          fontSize: 24,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.semiBold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Do you have any issues or questions? Feel free to reach out to us"
                            .tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        title: 'Subject'.tr,
                        textInputType: TextInputType.emailAddress,
                        controller: controller.subjectController.value,
                        hintText: 'Enter subject'.tr,
                      ),
                      TextFieldWidget(
                        title: 'Message'.tr,
                        textInputType: TextInputType.multiline,
                        maxLine: 5,
                        controller: controller.messageController.value,
                        hintText: 'Type message'.tr,
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                color: themeChange.getThem()
                    ? AppThemeData.grey900
                    : AppThemeData.grey50,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: RoundedButtonFill(
                    title: "Send Message".tr,
                    height: 5.5,
                    color: AppThemeData.primary300,
                    textColor: AppThemeData.grey50,
                    fontSizes: 16,
                    onPress: () async {
                      controller.saveSupport();
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
