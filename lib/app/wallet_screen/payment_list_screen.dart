import 'package:customer/app/wallet_screen/wallet_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/wallet_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PaymentListScreen extends StatelessWidget {
  PaymentListScreen({super.key});

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetX(
          init: WalletController(),
          builder: (controller) {
            return Padding(
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
                            title: 'Amount',
                            hintText: 'Enter Amount'.tr,
                            controller: controller.topUpAmountController.value,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    decimal: true, signed: true),
                            prefix: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "₦",
                                //Constant.currencyModel!.symbol.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey100
                                      : AppThemeData.primary100,
                                ),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-9]'),
                              ),
                            ],
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Amount is required";
                              }

                              if (int.parse(value.toString()) < 500) {
                                return "Minimum amount is ₦500";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 9.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: RoundedButtonFill(
                              title: "Continue".tr,
                              height: 5.5,
                              color: AppThemeData.primary300,
                              textColor: AppThemeData.grey50,
                              fontSizes: 16,
                              onPress: () async {
                                if (formkey.currentState!.validate()) {
                                  Get.back();
                                  controller.initiatePayment(
                                    context: context,
                                    amount: controller
                                        .topUpAmountController.value.text,
                                  );
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
            );
          }),
    );
  }

  cardDecoration(WalletController controller, PaymentGateway value, themeChange,
      String image) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: InkWell(
          onTap: () {
            controller.selectedPaymentMethod.value = value.name;
          },
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(value.name == "payFast" ? 0 : 8.0),
                  child: Image.asset(
                    image,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  value.name.capitalizeString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: AppThemeData.medium,
                    fontSize: 16,
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Radio(
                value: value.name,
                groupValue: controller.selectedPaymentMethod.value,
                activeColor: themeChange.getThem()
                    ? AppThemeData.primary300
                    : AppThemeData.primary300,
                onChanged: (value) {
                  controller.selectedPaymentMethod.value = value.toString();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
