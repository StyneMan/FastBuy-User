import 'package:customer/app/address_screens/address_list_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/logistics_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/select_field_widget.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class CheckParcelRates extends StatelessWidget {
  CheckParcelRates({super.key});

  var formkey = GlobalKey<FormState>();
  final logisticsController = Get.find<LogisticsController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Obx(
      () => LoadingOverlayPro(
        isLoading: logisticsController.isFetchingCost.value,
        backgroundColor: Colors.black45,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        child: Scaffold(
          backgroundColor: themeChange.getThem()
              ? AppThemeData.surfaceDark
              : AppThemeData.surface,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(
              "Check Rates".tr,
              style: TextStyle(
                fontSize: 16,
                color: themeChange.getThem()
                    ? AppThemeData.grey50
                    : AppThemeData.grey900,
                fontFamily: AppThemeData.regular,
                fontWeight: FontWeight.w400,
              ),
            ),
            centerTitle: true,
          ),
          body: GetX(
            init: AddressListController(),
            builder: (controller) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Timeline.tileBuilder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        theme: TimelineThemeData(
                          nodePosition: 0,
                          // indicatorPosition: 0,
                        ),
                        builder: TimelineTileBuilder.connected(
                          contentsAlign: ContentsAlign.basic,
                          indicatorBuilder: (context, index) {
                            return SvgPicture.asset(
                              "assets/icons/ic_location.svg",
                            );
                          },
                          connectorBuilder: (context, index, connectorType) {
                            return const DashedLineConnector(
                              color: AppThemeData.grey300,
                              gap: 3,
                            );
                          },
                          contentsBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: index == 0
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Sender Address",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.semiBold,
                                                  fontSize: 16,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.primary300
                                                      : AppThemeData.primary300,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () {
                                                    logisticsController
                                                        .estimateData
                                                        .clear();
                                                    Get.to(
                                                      AddressListScreen(),
                                                      transition:
                                                          Transition.cupertino,
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 0.0,
                                                      vertical: 1.0,
                                                    ),
                                                  ),
                                                  child: Obx(
                                                    () => Text(
                                                      controller.shippingModel
                                                              .value
                                                              .getFullAddress()
                                                              .isEmpty
                                                          ? "Specify your pickup address"
                                                          : controller
                                                              .shippingModel
                                                              .value
                                                              .getFullAddress(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Receiver Address",
                                          // "${controller.orderModel.value.address!.addressAs}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.semiBold,
                                            fontSize: 16,
                                            color: themeChange.getThem()
                                                ? AppThemeData.primary300
                                                : AppThemeData.primary300,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              logisticsController.estimateData
                                                  .clear();
                                              Get.to(
                                                AddressListScreen(
                                                  receiver: "receiver",
                                                ),
                                                transition:
                                                    Transition.cupertino,
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 0.0,
                                                vertical: 1.0,
                                              ),
                                            ),
                                            child: Obx(
                                              () => Text(
                                                controller.receivingModel.value
                                                        .getFullAddress()
                                                        .isEmpty
                                                    ? "Specify delivery address"
                                                    : controller
                                                        .receivingModel.value
                                                        .getFullAddress(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            );
                          },
                          itemCount: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Package Weight".tr,
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
                        hintText: "Enter package weight",
                        controller:
                            logisticsController.weightEditingController.value,
                        textInputType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$'),
                          ),
                        ],
                        onchange: (value) {
                          // Reset estimate here
                          logisticsController.estimateData.clear();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "Weight is required";
                          }
                          return null;
                        },
                        prefix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            "assets/icons/ic_map_draw.svg",
                            colorFilter: ColorFilter.mode(
                              themeChange.getThem()
                                  ? AppThemeData.grey300
                                  : AppThemeData.grey600,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        suffix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "kg".tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.regular,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "Package Dimension".tr,
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
                        controller: logisticsController
                            .dimensionEditingController.value,
                        hintText: "Enter package dimension",
                        textInputType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$')),
                        ],
                        onchange: (value) {
                          // Reset estimate here
                          logisticsController.estimateData.clear();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "Dimension is required";
                          }
                          return null;
                        },
                        prefix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            "assets/icons/ic_scan_code.svg",
                            colorFilter: ColorFilter.mode(
                              themeChange.getThem()
                                  ? AppThemeData.grey300
                                  : AppThemeData.grey600,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        suffix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "cm".tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.regular,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Shipping".tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      SelectFieldWidget(
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "Shipping type is required";
                          }
                          return null;
                        },
                        items: const ["Regular", "Cargo", "Express"],
                        hintText: "Select shipping",
                        controller:
                            logisticsController.shippingEditingController.value,
                        onSelected: (e) {
                          logisticsController.estimateData.clear();
                          logisticsController.selectedShipping.value =
                              "$e".toLowerCase();
                          logisticsController
                              .shippingEditingController.value.text = e;
                        },
                      ),
                      const SizedBox(height: 21.0),
                      logisticsController.estimateData.value.isEmpty
                          ? const SizedBox()
                          : Text(
                              "Result",
                              // "${controller.orderModel.value.address!.addressAs}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppThemeData.semiBold,
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                                color: themeChange.getThem()
                                    ? AppThemeData.primary300
                                    : AppThemeData.primary300,
                              ),
                            ),
                      const SizedBox(height: 10.0),
                      logisticsController.estimateData.value.isEmpty
                          ? const SizedBox()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Delivery Time Estimate".tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                        fontFamily: AppThemeData.regular,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "${logisticsController.estimateData.value['delivery_time']}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                        fontFamily: AppThemeData.regular,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Estimated Cost".tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                        fontFamily: AppThemeData.regular,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "₦${Constant.formatNumber(logisticsController.estimateData.value['total_cost'])}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Container(
            color: themeChange.getThem()
                ? AppThemeData.grey800
                : AppThemeData.grey100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RoundedButtonFill(
                title: "Estimate Now".tr,
                height: 5.5,
                color: AppThemeData.primary300,
                fontSizes: 16,
                onPress: () async {
                  // if (widget.controller.location.value.latitude == null ||
                  //     widget.controller.location.value.longitude == null) {
                  //   ShowToastDialog.showToast("Please select Location".tr);
                  // }
                  if (formkey.currentState!.validate()) {
                    // saveAddress(controller: widget.controller);
                    logisticsController.calculateCost();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
