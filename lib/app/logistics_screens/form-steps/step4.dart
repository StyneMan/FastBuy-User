import 'dart:io';

import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/logistics_controller.dart';
import 'package:customer/controllers/order_controller.dart';
import 'package:customer/controllers/wallet_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/widget/shimmer/banner_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

typedef void InitCallback(String value);

class PaymentForm extends StatelessWidget {
  final LogisticsController controller;
  final InitCallback onSelectPayment;
  PaymentForm({
    super.key,
    required this.onSelectPayment,
    required this.controller,
  });

  final orderController = Get.find<OrderController>();
  final walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Obx(
      () => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        children: [
          controller.isFetchingCost.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                      width: 144,
                      child: BannerShimmer(),
                    ),
                    const SizedBox(
                      height: 20,
                      width: 200,
                      child: BannerShimmer(),
                    ),
                    const SizedBox(height: 16.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                              width: 90,
                              child: BannerShimmer(),
                            ),
                            SizedBox(
                              height: 20,
                              width: 100,
                              child: BannerShimmer(),
                            ),
                          ],
                        ),
                        SizedBox(width: 21.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                              width: 90,
                              child: BannerShimmer(),
                            ),
                            SizedBox(
                              height: 20,
                              width: 128,
                              child: BannerShimmer(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 6 / 6,
                        crossAxisSpacing: 4.0,
                      ),
                      itemCount: 3,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => const BannerShimmer(),
                    ),
                    const SizedBox(height: 10.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 90,
                          child: BannerShimmer(),
                        ),
                        SizedBox(
                          height: 20,
                          width: 128,
                          child: BannerShimmer(),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Responsive.width(double.infinity, context),
                      decoration: ShapeDecoration(
                        color: themeChange.getThem()
                            ? AppThemeData.grey900
                            : AppThemeData.grey50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return packageCard(
                                context,
                                themeChange,
                                index,
                                controller.addedPackages.value[index],
                              );
                            },
                            itemCount: controller.addedPackages.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      width: Responsive.width(double.infinity, context),
                      decoration: ShapeDecoration(
                        color: themeChange.getThem()
                            ? AppThemeData.grey900
                            : AppThemeData.grey50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Service Charge".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.regular,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                "₦${controller.estimateData.value['service_charge']}"
                                    .tr,
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
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Delivery Time".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.regular,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                "${controller.estimateData.value['delivery_time']}"
                                    .tr,
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
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total Cost".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppThemeData.regular,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                "₦${Constant.formatNumber(controller.estimateData.value['total_cost'])}"
                                    .tr,
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
                    ),
                  ],
                ),
          const SizedBox(height: 16.0),
          Text(
            "Payment Method".tr,
            style: TextStyle(
              fontSize: 14,
              color: themeChange.getThem()
                  ? AppThemeData.grey50
                  : AppThemeData.grey900,
              fontFamily: AppThemeData.regular,
              fontWeight: FontWeight.w700,
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              // Create a RadioListTile for option 1
              RadioListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                title: const Text(
                  'Pay with Wallet',
                ), // Display the title for option 1
                subtitle: Text(
                  '₦${Constant.formatNumber(walletController.userWallet.value['balance'] ?? 0.0)}',
                ), // Display a subtitle for option 1
                value: "wallet", // Assign a value of 1 to this option
                groupValue: orderController.selectedPaymentMethod.value,
                onChanged: (value) {
                  onSelectPayment("$value");
                },
              ),

              // Create a RadioListTile for option 2
              RadioListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                title: const Text(
                  'Pay with Card',
                ), // Display the title for option 2
                // subtitle: const Text(
                //     'Subtitle for Option 2'), // Display a subtitle for option 2
                value: "card",
                groupValue: orderController.selectedPaymentMethod.value,
                onChanged: (value) {
                  onSelectPayment("$value");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  packageCard(BuildContext context, themeChange, int index, var item) =>
      Container(
        padding: const EdgeInsets.only(
          left: 16.0,
          bottom: 16.0,
          top: 5.0,
        ),
        width: Responsive.width(100, context),
        decoration: ShapeDecoration(
          color: themeChange.getThem()
              ? AppThemeData.grey900
              : AppThemeData.grey50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Text(
                        "Package Name".tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${item['name']}".tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Weight".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${item['weight']} kg".tr,
                      style: TextStyle(
                        fontSize: 16,
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
                  width: 18.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dimension".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${item['dimen']} cm".tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Images".tr,
              style: TextStyle(
                fontSize: 14,
                color: themeChange.getThem()
                    ? AppThemeData.grey50
                    : AppThemeData.grey900,
                fontFamily: AppThemeData.regular,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 6 / 6,
                crossAxisSpacing: 6.0,
              ),
              itemCount: item['images'].length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  "${item['images'][index]}",
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
}
