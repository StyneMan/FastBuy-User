import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/app/address_screens/address_list_screen.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/logistics_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ReceiverForm extends StatelessWidget {
  final LogisticsController controller;
  ReceiverForm({
    super.key,
    required this.controller,
  });

  final addressController = Get.find<AddressListController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Obx(
      () => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        children: [
          Text(
            "Receiver Name".tr,
            style: TextStyle(
              fontSize: 14,
              color: themeChange.getThem()
                  ? AppThemeData.grey50
                  : AppThemeData.grey900,
              fontFamily: AppThemeData.regular,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextFieldWidget(
            hintText: "Enter receiver name",
            controller: controller.receiverNameEditingController.value,
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Receiver name is required";
              }
              return null;
            },
            prefix: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                "assets/icons/ic_user.svg",
                colorFilter: ColorFilter.mode(
                  themeChange.getThem()
                      ? AppThemeData.grey300
                      : AppThemeData.grey600,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Receiver Phone".tr,
            style: TextStyle(
              fontSize: 14,
              color: themeChange.getThem()
                  ? AppThemeData.grey50
                  : AppThemeData.grey900,
              fontFamily: AppThemeData.regular,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextFieldWidget(
            hintText: "Enter receiver phone",
            controller: controller.receiverPhoneEditingController.value,
            textInputType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Phone number is required";
              }
              return null;
            },
            prefix: CountryCodePicker(
              enabled: true,
              onChanged: (value) {
                controller.receivercountryCodeEditingController.value.text =
                    value.dialCode.toString();
              },
              dialogTextStyle: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey900,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppThemeData.medium),
              dialogBackgroundColor: themeChange.getThem()
                  ? AppThemeData.grey800
                  : AppThemeData.grey100,
              initialSelection:
                  controller.receivercountryCodeEditingController.value.text,
              comparator: (a, b) => b.name!.compareTo(a.name.toString()),
              textStyle: TextStyle(
                  fontSize: 14,
                  color: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey900,
                  fontFamily: AppThemeData.medium),
              searchDecoration: InputDecoration(
                  iconColor: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey900),
              searchStyle: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey900,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppThemeData.medium),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Receiver Email".tr,
            style: TextStyle(
              fontSize: 14,
              color: themeChange.getThem()
                  ? AppThemeData.grey50
                  : AppThemeData.grey900,
              fontFamily: AppThemeData.regular,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextFieldWidget(
            controller: controller.receiverEmailEditingController.value,
            hintText: 'Enter email address'.tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                  .hasMatch(value!)) {
                return 'Enter a valid email address';
              }
              return null;
            },
            prefix: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                "assets/icons/ic_mail.svg",
                colorFilter: ColorFilter.mode(
                  themeChange.getThem()
                      ? AppThemeData.grey300
                      : AppThemeData.grey600,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Receiver Address".tr,
            style: TextStyle(
              fontSize: 14,
              color: themeChange.getThem()
                  ? AppThemeData.grey50
                  : AppThemeData.grey900,
              fontFamily: AppThemeData.regular,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/ic_location.svg",
                colorFilter: ColorFilter.mode(
                  themeChange.getThem()
                      ? AppThemeData.grey300
                      : AppThemeData.grey600,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Get.to(
                      AddressListScreen(
                        receiver: "receiver",
                      ),
                      transition: Transition.cupertino,
                    );
                  },
                  child: Text(
                    addressController.receivingModel.value
                            .getFullAddress()
                            .isEmpty
                        ? "Specify your delivery address"
                        : addressController.receivingModel.value
                            .getFullAddress(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
