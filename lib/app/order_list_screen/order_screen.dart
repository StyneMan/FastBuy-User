import 'dart:convert';

import 'package:customer/app/auth_screen/login_screen.dart';
import 'package:customer/app/order_list_screen/order_details_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/controllers/order_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:customer/utils/preferences.dart';
import 'package:customer/widget/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});

  final _profileController = Get.find<MyProfileController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OrderController(),
        builder: (controller) {
          // debugPrint("CHECKITO :: ${controller.myOrders.value}");
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surfaceDark
                : const Color(0xFFFAF6F1),
            body: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
              child: controller.isLoading.value
                  ? Constant.loader()
                  : _profileController.userData.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/login.gif",
                                height: 120,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Please Log In to Continue".tr,
                                style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey100
                                        : AppThemeData.grey800,
                                    fontSize: 22,
                                    fontFamily: AppThemeData.semiBold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "You’re not logged in. Please sign in to access your account and explore all features."
                                    .tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey500,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RoundedButtonFill(
                                title: "Log in".tr,
                                width: 55,
                                height: 5.5,
                                color: AppThemeData.primary300,
                                textColor: AppThemeData.grey50,
                                onPress: () async {
                                  Get.offAll(LoginScreen());
                                },
                              ),
                            ],
                          ),
                        )
                      : DefaultTabController(
                          length: 4,
                          child: Column(
                            children: [
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 16),
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //         child: Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           children: [
                              //             Text(
                              //               "My Order".tr,
                              //               style: TextStyle(
                              //                 fontSize: 24,
                              //                 color: themeChange.getThem()
                              //                     ? AppThemeData.grey50
                              //                     : AppThemeData.grey900,
                              //                 fontFamily: AppThemeData.semiBold,
                              //                 fontWeight: FontWeight.w500,
                              //               ),
                              //             ),
                              //             Text(
                              //               "Keep track your 'delivered', 'in progress' and 'cancelled' orders all in one place."
                              //                   .tr,
                              //               style: TextStyle(
                              //                 color: themeChange.getThem()
                              //                     ? AppThemeData.grey50
                              //                     : AppThemeData.grey900,
                              //                 fontFamily: AppThemeData.regular,
                              //                 fontWeight: FontWeight.w400,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              const SizedBox(
                                height: 16,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 10,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey800
                                              : AppThemeData.grey100,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(120),
                                          ),
                                        ),
                                        child: TabBar(
                                          indicator: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ), // Creates border
                                            color: AppThemeData.primary300,
                                          ),
                                          labelColor: AppThemeData.grey50,
                                          isScrollable: true,
                                          tabAlignment: TabAlignment.start,
                                          indicatorWeight: 0.5,
                                          unselectedLabelColor:
                                              themeChange.getThem()
                                                  ? AppThemeData.grey50
                                                  : AppThemeData.grey900,
                                          dividerColor: Colors.transparent,
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          tabs: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 18,
                                              ),
                                              child: Tab(
                                                text: 'All'.tr,
                                              ),
                                            ),
                                            Tab(
                                              text: 'In Progress'.tr,
                                            ),
                                            Tab(
                                              text: 'Delivered'.tr,
                                            ),
                                            Tab(
                                              text: 'Cancelled'.tr,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          children: [
                                            controller.myOrders.isEmpty
                                                ? const SizedBox()
                                                : controller.myOrders
                                                        .value['data']?.isEmpty
                                                    ? Constant.showEmptyView(
                                                        message:
                                                            "No orders found"
                                                                .tr)
                                                    : RefreshIndicator(
                                                        onRefresh: () =>
                                                            controller
                                                                .getOrder(),
                                                        child: ListView.builder(
                                                          itemCount: controller
                                                              .myOrders
                                                              .value['data']
                                                              ?.length,
                                                          shrinkWrap: true,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          itemBuilder:
                                                              (context, index) {
                                                            // OrderModel orderModel =
                                                            //     controller
                                                            //         .allList[index];
                                                            final item = controller
                                                                    .myOrders
                                                                    .value[
                                                                'data'][index];
                                                            return itemView(
                                                              themeChange,
                                                              context,
                                                              item,
                                                              controller,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                            (controller.myInprogressOrders
                                                            .value['data'] ??
                                                        [])
                                                    ?.isEmpty
                                                ? Constant.showEmptyView(
                                                    message:
                                                        "No orders found".tr)
                                                : RefreshIndicator(
                                                    onRefresh: () =>
                                                        controller.getOrder(),
                                                    child: ListView.builder(
                                                      itemCount: controller
                                                          .myInprogressOrders
                                                          .value['data']
                                                          ?.length,
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder:
                                                          (context, index) {
                                                        // OrderModel orderModel =
                                                        //     controller
                                                        //         .allList[index];
                                                        final item = controller
                                                            .myInprogressOrders
                                                            .value['data'][index];
                                                        return itemView(
                                                          themeChange,
                                                          context,
                                                          item,
                                                          controller,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                            (controller.myDeliveredOrders
                                                            .value['data'] ??
                                                        [])
                                                    ?.isEmpty
                                                ? Constant.showEmptyView(
                                                    message: "No orders found")
                                                : RefreshIndicator(
                                                    onRefresh: () =>
                                                        controller.getOrder(),
                                                    child: ListView.builder(
                                                      itemCount: controller
                                                          .myDeliveredOrders
                                                          .value['data']
                                                          ?.length,
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder:
                                                          (context, index) {
                                                        // OrderModel orderModel =
                                                        //     controller
                                                        //         .allList[index];
                                                        final item = controller
                                                            .myDeliveredOrders
                                                            .value['data'][index];
                                                        return itemView(
                                                          themeChange,
                                                          context,
                                                          item,
                                                          controller,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                            (controller.myCancelledOrders
                                                            .value['data'] ??
                                                        [])
                                                    ?.isEmpty
                                                ? Constant.showEmptyView(
                                                    message: "No orders found")
                                                : RefreshIndicator(
                                                    onRefresh: () =>
                                                        controller.getOrder(),
                                                    child: ListView.builder(
                                                      itemCount: controller
                                                          .myCancelledOrders
                                                          .value['data']
                                                          ?.length,
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final item = controller
                                                            .myCancelledOrders
                                                            .value['data'][index];
                                                        return itemView(
                                                          themeChange,
                                                          context,
                                                          item,
                                                          controller,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
            ),
          );
        });
  }

  itemView(DarkThemeProvider themeChange, BuildContext context, var item,
      OrderController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: ShapeDecoration(
          color: themeChange.getThem()
              ? AppThemeData.grey900
              : AppThemeData.grey50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: Stack(
                      children: [
                        NetworkImageWidget(
                          imageUrl: item['vendor'] == null
                              ? "https://i.imgur.com/ZmYTJoA.png"
                              : "${item['vendor']['logo']}",
                          fit: BoxFit.cover,
                          height: Responsive.height(10, context),
                          width: Responsive.width(20, context),
                        ),
                        Container(
                          height: Responsive.height(10, context),
                          width: Responsive.width(20, context),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(0.00, 1.00),
                              end: const Alignment(0, -1),
                              colors: [
                                Colors.black.withOpacity(0),
                                AppThemeData.grey900
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item['order_status']}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Constant.statusColor(
                                status: "${item['order_status']}"),
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          item['vendor'] == null
                              ? "FastBuy Logistics"
                              : "${item['vendor']['name']}",
                          style: TextStyle(
                            fontSize: 16,
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontFamily: AppThemeData.medium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${DateFormat("EEE, dd/MMM/y hh:mm a").format(DateTime.parse("${item['created_at']}"))}",
                          // Constant.timestampToDateTime(orderModel.createdAt!),
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.grey300
                                : AppThemeData.grey600,
                            fontFamily: AppThemeData.medium,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                itemCount: item['items'].length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, ind) {
                  // CartProductModel cartProduct = orderModel.products![index];
                  final elem = item['items'][ind];
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${elem['name']}",
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontFamily: AppThemeData.regular,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        item['order_type'] == "parcel_order"
                            ? "${elem['weight']} kg"
                            : "₦${Constant.formatNumber(elem['amount'])}",
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: MySeparator(
                    color: themeChange.getThem()
                        ? AppThemeData.grey700
                        : AppThemeData.grey200),
              ),
              Row(
                children: [
                  item['order_status'] == "completed" &&
                          item['order_type'] != "parcel_order"
                      ? Expanded(
                          child: InkWell(
                            onTap: () {
                              reorder(
                                controller: controller,
                                item: item,
                              );
                            },
                            child: Text(
                              "Reorder".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.primary300
                                      : AppThemeData.primary300,
                                  fontFamily: AppThemeData.semiBold,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                        )
                      : item['order_status'] == "rider_picked_order" ||
                              item['order_status'] == "in_delivery" ||
                              item['order_status'] == "rider_arrived_customer"
                          ? Expanded(
                              child: InkWell(
                                onTap: () {
                                  // Get.to(const LiveTrackingScreen(),
                                  //     arguments: {"orderModel": orderModel});
                                },
                                child: Text(
                                  "Track Order".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.primary300
                                        : AppThemeData.primary300,
                                    fontFamily: AppThemeData.semiBold,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          OrderDetailsScreen(
                            item: item,
                          ),
                          arguments: {"orderModel": item},
                        );
                      },
                      child: Text(
                        "View Details".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.semiBold,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  reorder({
    required item,
    required OrderController controller,
  }) async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      debugPrint("ITEM CHECKITOLOA ::: ${item['items']}");
      List<Map<String, dynamic>> items = [];
      for (var k = 0; k < item['items'].length; k++) {
        final elem = item['items'][k];
        debugPrint("ELEM AT ::: ${elem}");
        items.add({
          "name": elem['name'],
          "amount": elem['product']['sale_amount'],
          "product_id": elem['product']['id'],
          "selections": elem['selections'],
          "total_amount": elem['total_amount']
        });
      }

      Map payload = {
        "total_amount": item['total_amount'],
        "vendor_id": item['vendor']['id'],
        "items": items,
        "vendor_note": item['vendor_note'],
      };
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      final resp = await APIService().reorderToCart(
        accessToken: accessToken,
        payload: payload,
      );
      ShowToastDialog.closeLoader();
      debugPrint("ADD TO CART RESPONSE ::: ${resp.body}");
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast("${map['message']}");
        // Show SnackBar with extended duration
        controller.cartController.currentCartItems.value = map['data']['items'];
        controller.cartController.isInCart.value = true;
        controller.cartController.refreshCart();
        controller.cartController.currCartItem = map['data'];
      } else {
        Map<String, dynamic> errMap = jsonDecode(resp.body);
        Constant.toast("${errMap['message']}");
      }
    } catch (e) {
      debugPrint("ERROR : $e");
      ShowToastDialog.closeLoader();
    }
  }
}
