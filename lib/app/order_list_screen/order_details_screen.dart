import 'dart:convert';

import 'package:customer/app/order_list_screen/live_tracking_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/order_details_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:customer/utils/preferences.dart';
import 'package:customer/widget/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class OrderDetailsScreen extends StatelessWidget {
  final item;
  const OrderDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OrderDetailsController(),
        builder: (controller) {
          return controller.isLoading.value
              ? const SizedBox()
              : Scaffold(
                  backgroundColor: themeChange.getThem()
                      ? AppThemeData.surfaceDark
                      : AppThemeData.surface,
                  appBar: AppBar(
                    backgroundColor: themeChange.getThem()
                        ? AppThemeData.surfaceDark
                        : AppThemeData.surface,
                    centerTitle: false,
                    titleSpacing: 0,
                    title: Text(
                      "Order Details".tr,
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
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item['order_id']}".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        fontSize: 18,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RoundedButtonFill(
                                title:
                                    "${item['order_status'].toString().toLowerCase().contains('arrived') ? "Arrived" : item['order_status']}"
                                        .tr,
                                color: Constant.statusColor(
                                  status: "${item['order_status']}",
                                ),
                                width: 32,
                                height: 4.5,
                                radius: 10,
                                textColor: Constant.statusText(
                                  status: item['order_status'].toString(),
                                ),
                                onPress: () async {},
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          item['delivery_type'] == "pickup"
                              ? Container(
                                  decoration: ShapeDecoration(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900
                                        : AppThemeData.grey50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${item['vendor']['name']} ${item['vendor_location']['branch_name']}",
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
                                              Text(
                                                "${item['vendor_location']['street']}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  fontSize: 14,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey300
                                                      : AppThemeData.grey600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        item['order_status'] == "pending" ||
                                                item['order_status'] ==
                                                    "rejected" ||
                                                item['order_status'] ==
                                                    "completed"
                                            ? const SizedBox()
                                            : InkWell(
                                                onTap: () {
                                                  Constant.makePhoneCall(
                                                    item['vendor_location'][
                                                            'intl_phone_format']
                                                        .toString(),
                                                  );
                                                },
                                                child: Container(
                                                  width: 42,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey700
                                                              : AppThemeData
                                                                  .grey200),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              120),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      "assets/icons/ic_phone_call.svg",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        item['order_status'] == "pending" ||
                                                item['order_status'] ==
                                                    "rejected" ||
                                                item['order_status'] ==
                                                    "completed"
                                            ? const SizedBox()
                                            : const SizedBox()
                                        // InkWell(
                                        //     onTap: () async {
                                        //       // ShowToastDialog.showLoader(
                                        //       //     "Please wait".tr);

                                        //       // UserModel? customer =
                                        //       //     await FireStoreUtils
                                        //       //         .getUserProfile(
                                        //       //             controller
                                        //       //                 .orderModel
                                        //       //                 .value
                                        //       //                 .authorID
                                        //       //                 .toString());
                                        //       // UserModel? restaurantUser =
                                        //       //     await FireStoreUtils
                                        //       //         .getUserProfile(
                                        //       //             controller
                                        //       //                 .orderModel
                                        //       //                 .value
                                        //       //                 .vendor!
                                        //       //                 .author
                                        //       //                 .toString());
                                        //       // VendorModel? vendorModel =
                                        //       //     await FireStoreUtils
                                        //       //         .getVendorById(
                                        //       //             restaurantUser!
                                        //       //                 .vendorID
                                        //       //                 .toString());
                                        //       // ShowToastDialog.closeLoader();

                                        //       // Get.to(
                                        //       //   const ChatScreen(),
                                        //       //   arguments: {
                                        //       //     "customerName":
                                        //       //         '${customer!.fullName()}',
                                        //       //     "restaurantName":
                                        //       //         vendorModel!.title,
                                        //       //     "orderId": controller
                                        //       //         .orderModel.value.id,
                                        //       //     "restaurantId":
                                        //       //         restaurantUser.id,
                                        //       //     "customerId": customer.id,
                                        //       //     "customerProfileImage":
                                        //       //         customer
                                        //       //             .profilePictureURL,
                                        //       //     "restaurantProfileImage":
                                        //       //         vendorModel.photo,
                                        //       //     "token": restaurantUser
                                        //       //         .fcmToken,
                                        //       //     "chatType": "restaurant",
                                        //       //   },
                                        //       // );
                                        //     },
                                        //     // child: Container(
                                        //     //   width: 42,
                                        //     //   height: 42,
                                        //     //   decoration: ShapeDecoration(
                                        //     //     shape:
                                        //     //         RoundedRectangleBorder(
                                        //     //       side: BorderSide(
                                        //     //           width: 1,
                                        //     //           color: themeChange
                                        //     //                   .getThem()
                                        //     //               ? AppThemeData
                                        //     //                   .grey700
                                        //     //               : AppThemeData
                                        //     //                   .grey200),
                                        //     //       borderRadius:
                                        //     //           BorderRadius.circular(
                                        //     //               120),
                                        //     //     ),
                                        //     //   ),
                                        //     //   child: Padding(
                                        //     //     padding:
                                        //     //         const EdgeInsets.all(
                                        //     //             8.0),
                                        //     //     child: SvgPicture.asset(
                                        //     //       "assets/icons/ic_wechat.svg",
                                        //     //     ),
                                        //     //   ),
                                        //     // ),
                                        //   )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: ShapeDecoration(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey900
                                        : AppThemeData.grey50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        Timeline.tileBuilder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          theme: TimelineThemeData(
                                            nodePosition: 0,
                                            // indicatorPosition: 0,
                                          ),
                                          builder:
                                              TimelineTileBuilder.connected(
                                            contentsAlign: ContentsAlign.basic,
                                            indicatorBuilder: (context, index) {
                                              return SvgPicture.asset(
                                                "assets/icons/ic_location.svg",
                                              );
                                            },
                                            connectorBuilder: (context, index,
                                                connectorType) {
                                              return const DashedLineConnector(
                                                color: AppThemeData.grey300,
                                                gap: 3,
                                              );
                                            },
                                            contentsBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10,
                                                ),
                                                child: index == 0
                                                    ? Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  item['order_type'] ==
                                                                          "parcel_order"
                                                                      ? "${item['customer']['first_name']} ${item['customer']['last_name']}"
                                                                          .capitalize!
                                                                      : "${item['vendor']['name']} ${item['vendor_location']['branch_name']}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppThemeData
                                                                            .semiBold,
                                                                    fontSize:
                                                                        16,
                                                                    color: themeChange.getThem()
                                                                        ? AppThemeData
                                                                            .primary300
                                                                        : AppThemeData
                                                                            .primary300,
                                                                  ),
                                                                ),
                                                                item['order_type'] ==
                                                                        "parcel_order"
                                                                    ? Text(
                                                                        "${item['pickup_address']}"
                                                                            .trimLeft(),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              AppThemeData.medium,
                                                                          fontSize:
                                                                              14,
                                                                          color: themeChange.getThem()
                                                                              ? AppThemeData.grey300
                                                                              : AppThemeData.grey600,
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        "${item['vendor_location']['street']}",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              AppThemeData.medium,
                                                                          fontSize:
                                                                              14,
                                                                          color: themeChange.getThem()
                                                                              ? AppThemeData.grey300
                                                                              : AppThemeData.grey600,
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                          ),
                                                          item['order_status'] == "pending" ||
                                                                  item['order_status'] ==
                                                                      "rejected" ||
                                                                  item['order_status'] ==
                                                                      "completed"
                                                              ? const SizedBox()
                                                              : InkWell(
                                                                  onTap: () {
                                                                    if (item[
                                                                            'order_type'] ==
                                                                        "parcel_order") {
                                                                      Constant
                                                                          .makePhoneCall(
                                                                        item['rider']['intl_phone_format']
                                                                            .toString(),
                                                                      );
                                                                    } else {
                                                                      Constant
                                                                          .makePhoneCall(
                                                                        item['vendor_location']['intl_phone_format']
                                                                            .toString(),
                                                                      );
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 42,
                                                                    height: 42,
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        side:
                                                                            BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: themeChange.getThem()
                                                                              ? AppThemeData.grey700
                                                                              : AppThemeData.grey200,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          120,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                        8.0,
                                                                      ),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "assets/icons/ic_phone_call.svg",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          item['order_status'] == "pending" ||
                                                                  item['order_status'] ==
                                                                      "rejected" ||
                                                                  item['order_status'] ==
                                                                      "completed"
                                                              ? const SizedBox()
                                                              : const SizedBox(),
                                                        ],
                                                      )
                                                    : Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${item['delivery_address']}",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .semiBold,
                                                              fontSize: 16,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData
                                                                      .primary300
                                                                  : AppThemeData
                                                                      .primary300,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              );
                                            },
                                            itemCount: 2,
                                          ),
                                        ),
                                        item['order_status'] == "rejected"
                                            ? const SizedBox()
                                            : Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: MySeparator(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData.grey700
                                                          : AppThemeData
                                                              .grey200,
                                                    ),
                                                  ),
                                                  item['order_status'] ==
                                                          "completed"
                                                      ? Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              "assets/icons/ic_check_small.svg",
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "${item['rider']['first_name']} ${item['rider']['last_name']}"
                                                                  .capitalize!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                color: themeChange.getThem()
                                                                    ? AppThemeData
                                                                        .grey100
                                                                    : AppThemeData
                                                                        .grey800,
                                                                fontFamily:
                                                                    AppThemeData
                                                                        .semiBold,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "Order Delivered."
                                                                  .tr,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                color: themeChange.getThem()
                                                                    ? AppThemeData
                                                                        .grey100
                                                                    : AppThemeData
                                                                        .grey800,
                                                                fontFamily:
                                                                    AppThemeData
                                                                        .regular,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : item['order_status'] ==
                                                                  "ready_for_delivery" ||
                                                              item['order_status'] ==
                                                                  "in_delivery"
                                                          ? Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    "${item['rider']['photo_url']}",
                                                                    width: 48,
                                                                    height: 48,
                                                                    errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) =>
                                                                        SvgPicture
                                                                            .asset(
                                                                      "assets/icons/ic_timer.svg",
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    "Your order has been processed and assigned to a rider"
                                                                        .tr,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style:
                                                                        TextStyle(
                                                                      color: themeChange.getThem()
                                                                          ? AppThemeData
                                                                              .warning400
                                                                          : AppThemeData
                                                                              .warning400,
                                                                      fontFamily:
                                                                          AppThemeData
                                                                              .semiBold,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : item['rider'] !=
                                                                  null
                                                              ? Row(
                                                                  children: [
                                                                    ClipOval(
                                                                      child:
                                                                          NetworkImageWidget(
                                                                        imageUrl:
                                                                            "${item['rider']['photo_url']}",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height:
                                                                            Responsive.height(
                                                                          5,
                                                                          context,
                                                                        ),
                                                                        width: Responsive
                                                                            .width(
                                                                          10,
                                                                          context,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "${item['rider']['first_name']} ${item['rider']['last_name']}".capitalize!,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                                              fontFamily: AppThemeData.semiBold,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "${item['rider']['email_address']}",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: themeChange.getThem() ? AppThemeData.success400 : AppThemeData.success400,
                                                                              fontFamily: AppThemeData.regular,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        // Call Rider
                                                                        Constant
                                                                            .makePhoneCall(
                                                                          "${item['rider']['intl_phone_format']}",
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            42,
                                                                        height:
                                                                            42,
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(
                                                                              width: 1,
                                                                              color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              120,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            "assets/icons/ic_phone_call.svg",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    // InkWell(
                                                                    //   onTap:
                                                                    //       () async {
                                                                    //     // ShowToastDialog.showLoader(
                                                                    //     //     "Please wait".tr);

                                                                    //     // UserModel? customer = await FireStoreUtils.getUserProfile(controller
                                                                    //     //     .orderModel
                                                                    //     //     .value
                                                                    //     //     .authorID
                                                                    //     //     .toString());
                                                                    //     // UserModel? restaurantUser = await FireStoreUtils.getUserProfile(controller
                                                                    //     //     .orderModel
                                                                    //     //     .value
                                                                    //     //     .driverID
                                                                    //     //     .toString());

                                                                    //     // ShowToastDialog
                                                                    //     //     .closeLoader();

                                                                    //     // Get.to(
                                                                    //     //     const ChatScreen(),
                                                                    //     //     arguments: {
                                                                    //     //       "customerName": '${customer!.fullName()}',
                                                                    //     //       "restaurantName": restaurantUser!.fullName(),
                                                                    //     //       "orderId": controller.orderModel.value.id,
                                                                    //     //       "restaurantId": restaurantUser.id,
                                                                    //     //       "customerId": customer.id,
                                                                    //     //       "customerProfileImage": customer.profilePictureURL,
                                                                    //     //       "restaurantProfileImage": restaurantUser.profilePictureURL,
                                                                    //     //       "token": restaurantUser.fcmToken,
                                                                    //     //       "chatType": "Driver",
                                                                    //     //     });
                                                                    //   },
                                                                    //   child:
                                                                    //       Container(
                                                                    //     width:
                                                                    //         42,
                                                                    //     height:
                                                                    //         42,
                                                                    //     decoration:
                                                                    //         ShapeDecoration(
                                                                    //       shape:
                                                                    //           RoundedRectangleBorder(
                                                                    //         side:
                                                                    //             BorderSide(
                                                                    //           width: 1,
                                                                    //           color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                                                                    //         ),
                                                                    //         borderRadius:
                                                                    //             BorderRadius.circular(
                                                                    //           120,
                                                                    //         ),
                                                                    //       ),
                                                                    //     ),
                                                                    //     child:
                                                                    //         Padding(
                                                                    //       padding: const EdgeInsets
                                                                    //           .all(
                                                                    //           8.0),
                                                                    //       child:
                                                                    //           SvgPicture.asset(
                                                                    //         "assets/icons/ic_wechat.svg",
                                                                    //       ),
                                                                    //     ),
                                                                    //   ),
                                                                    // )
                                                                  ],
                                                                )
                                                              : const SizedBox(),
                                                ],
                                              ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Your Order".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: AppThemeData.semiBold,
                              fontSize: 16,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: (item['items'] ?? [])?.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, inx) {
                                  final elem = item['items'][inx];
                                  debugPrint("ELEM CHECKIDON ::: $elem");
                                  // CartProductModel cartProductModel =
                                  //     controller.orderModel.value.products![index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(14),
                                            ),
                                            child: Stack(
                                              children: [
                                                NetworkImageWidget(
                                                  imageUrl: item[
                                                              'order_type'] ==
                                                          'parcel_order'
                                                      ? "${elem['images'][0]}"
                                                      : "${elem['product']['images'][0]}",
                                                  height: Responsive.height(
                                                      8, context),
                                                  width: Responsive.width(
                                                      16, context),
                                                  fit: BoxFit.cover,
                                                ),
                                                Container(
                                                  height: Responsive.height(
                                                      8, context),
                                                  width: Responsive.width(
                                                      16, context),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: const Alignment(
                                                        -0.00,
                                                        -1.00,
                                                      ),
                                                      end:
                                                          const Alignment(0, 1),
                                                      colors: [
                                                        Colors.black
                                                            .withOpacity(0),
                                                        const Color(0xFF111827)
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${elem['name']}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppThemeData
                                                                  .regular,
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey50
                                                              : AppThemeData
                                                                  .grey900,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "x 1",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey50
                                                            : AppThemeData
                                                                .grey900,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                item['order_type'] ==
                                                        'parcel_order'
                                                    ? const SizedBox()
                                                    : elem['product'][
                                                                'sale_amount'] ==
                                                            elem['product']
                                                                ['amount']
                                                        ? Text(
                                                            "₦${Constant.formatNumber(elem['product']['sale_amount'])}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .grey50
                                                                  : AppThemeData
                                                                      .grey900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          )
                                                        : Row(
                                                            children: [
                                                              Text(
                                                                "₦${Constant.formatNumber(elem['product']['sale_amount'])}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: themeChange.getThem()
                                                                      ? AppThemeData
                                                                          .grey50
                                                                      : AppThemeData
                                                                          .grey900,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "₦${Constant.formatNumber(elem['product']['amount'])}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  decorationColor: themeChange.getThem()
                                                                      ? AppThemeData
                                                                          .grey500
                                                                      : AppThemeData
                                                                          .grey400,
                                                                  color: themeChange.getThem()
                                                                      ? AppThemeData
                                                                          .grey500
                                                                      : AppThemeData
                                                                          .grey400,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // cartProductModel.variantInfo == null ||
                                      //         cartProductModel.variantInfo!
                                      //             .variantOptions!.isEmpty
                                      //     ? Container()
                                      // :
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              item['order_type'] ==
                                                      'parcel_order'
                                                  ? []
                                                  : [
                                                      item['order_type'] ==
                                                              'store_order'
                                                          ? (item['variations'] ??
                                                                          [])
                                                                      ?.length >
                                                                  0
                                                              ? Text(
                                                                  "Variations",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppThemeData
                                                                            .semiBold,
                                                                    color: themeChange.getThem()
                                                                        ? AppThemeData
                                                                            .grey300
                                                                        : AppThemeData
                                                                            .grey600,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                )
                                                              : const SizedBox()
                                                          : (item['addOns'] ??
                                                                          [])
                                                                      ?.length >
                                                                  0
                                                              ? Text(
                                                                  "Extras",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppThemeData
                                                                            .semiBold,
                                                                    color: themeChange.getThem()
                                                                        ? AppThemeData
                                                                            .grey300
                                                                        : AppThemeData
                                                                            .grey600,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      item['order_type'] ==
                                                              'store_order'
                                                          ? Wrap(
                                                              spacing: 6.0,
                                                              runSpacing: 6.0,
                                                              children:
                                                                  List.generate(
                                                                (elem['variations'] ??
                                                                        [])
                                                                    ?.length,
                                                                (i) {
                                                                  return Container(
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      color: themeChange.getThem()
                                                                          ? AppThemeData
                                                                              .grey800
                                                                          : AppThemeData
                                                                              .grey100,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            5,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        "${elem['variations'][i]['name']} : ${elem['variations'][i]['price']}",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              AppThemeData.medium,
                                                                          color: themeChange.getThem()
                                                                              ? AppThemeData.grey500
                                                                              : AppThemeData.grey400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).toList(),
                                                            )
                                                          : item['order_type'] ==
                                                                  'restaurant_order'
                                                              ? Wrap(
                                                                  spacing: 6.0,
                                                                  runSpacing:
                                                                      6.0,
                                                                  children: List
                                                                      .generate(
                                                                    (elem['addOns'] ??
                                                                            [])
                                                                        ?.length,
                                                                    (i) {
                                                                      return Container(
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          color: themeChange.getThem()
                                                                              ? AppThemeData.grey800
                                                                              : AppThemeData.grey100,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                16,
                                                                            vertical:
                                                                                5,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "${elem['addOns'][i]['name']} : ${elem['addOns'][i]['price']}",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: AppThemeData.medium,
                                                                              color: themeChange.getThem() ? AppThemeData.grey500 : AppThemeData.grey400,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).toList(),
                                                                )
                                                              : const SizedBox(),
                                                    ],
                                        ),
                                      ),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Total Amount",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppThemeData.semiBold,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey300
                                                        : AppThemeData.grey600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "₦${Constant.formatNumber(item['total_amount'])}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.primary300
                                                      : AppThemeData.primary300,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: MySeparator(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey700
                                          : AppThemeData.grey200,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          Text(
                            "Bill Details".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: AppThemeData.semiBold,
                              fontSize: 16,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Responsive.width(100, context),
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 14),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Sub Total".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "₦${Constant.formatNumber(item['total_amount'])}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  item['delivery_type'] == "pickup"
                                      ? const SizedBox()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Delivery Fee".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppThemeData.regular,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey300
                                                      : AppThemeData.grey600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "₦${Constant.formatNumber(item['delivery_fee'])}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey50
                                                    : AppThemeData.grey900,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MySeparator(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey700
                                        : AppThemeData.grey200,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Coupon Discount".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "- ₦${Constant.formatNumber(item['coupon_discount'])}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.danger300
                                              : AppThemeData.danger300,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Service Charge".tr,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppThemeData.regular,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey300
                                                    : AppThemeData.grey600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "₦${Constant.formatNumber(item['service_charge'])}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MySeparator(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey700
                                        : AppThemeData.grey200,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Amount Paid".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "₦${Constant.formatNumber(item['service_charge'] + item['delivery_fee'] + item['total_amount'] - item['coupon_discount'])}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          Text(
                            "Order Details".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: AppThemeData.semiBold,
                              fontSize: 16,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Responsive.width(100, context),
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 14,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Delivery type".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item['delivery_type'] == "pickup"
                                            ? "Pickup".tr
                                            : "Standard".tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.medium,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Payment Method".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${item['payment_method']}".capitalize!,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.regular,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey50
                                              : AppThemeData.grey900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Date and Time".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('EEE MMM, d. y hh:mm a')
                                            .format(DateTime.parse(
                                                item['created_at'])),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.regular,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey300
                                              : AppThemeData.grey600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  "${item['shipping_type']}".isEmpty ||
                                          item['shipping_type'] == null
                                      ? const SizedBox()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Shipping Type".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.regular,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData.grey300
                                                          : AppThemeData
                                                              .grey600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "${item['shipping_type']}"
                                                  .capitalize!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppThemeData.regular,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey50
                                                    : AppThemeData.grey900,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Delivery Address".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey300
                                                : AppThemeData.grey600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${item['delivery_address']}"
                                              .trimLeft()
                                              .capitalize!,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          item['order_type'] == 'parcel_order'
                              ? const SizedBox()
                              : item['vendor_note']?.isEmpty
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Vendor Note".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.semiBold,
                                            fontSize: 16,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                          ),
                                        ),
                                        Container(
                                          width: Responsive.width(100, context),
                                          decoration: ShapeDecoration(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey900
                                                : AppThemeData.grey50,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 14),
                                            child: Text(
                                              "${item['vendor_note']}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppThemeData.regular,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey50
                                                    : AppThemeData.grey900,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          const SizedBox(
                            height: 21,
                          ),
                          item['rider_note']?.isEmpty
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rider Note".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        fontSize: 16,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                      ),
                                    ),
                                    Container(
                                      width: Responsive.width(100, context),
                                      decoration: ShapeDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey900
                                            : AppThemeData.grey50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 14),
                                        child: Text(
                                          "${item['rider_note']}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.regular,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey50
                                                : AppThemeData.grey900,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: item['order_status'] == "in_delivery" ||
                          item['order_status'] == "completed" ||
                          item['order_status'] == "rider_arrived_customer" ||
                          item['order_status'] == "rider_picked_order"
                      ? Container(
                          color: themeChange.getThem()
                              ? AppThemeData.grey900
                              : AppThemeData.grey50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child:
                                item['order_status'] == "rider_picked_order" ||
                                        item['order_status'] == "in_delivery" ||
                                        item['order_status'] ==
                                            "rider_arrived_customer"
                                    ? RoundedButtonFill(
                                        title: "Track Order".tr,
                                        height: 5.5,
                                        color: AppThemeData.warning300,
                                        textColor: AppThemeData.grey900,
                                        onPress: () async {
                                          Get.to(
                                            const LiveTrackingScreen(),
                                            arguments: {"orderModel": item},
                                          );
                                        },
                                      )
                                    : item['order_type'] == "parcel_order"
                                        ? const SizedBox()
                                        : RoundedButtonFill(
                                            title: "Reorder".tr,
                                            height: 5.5,
                                            color: AppThemeData.primary300,
                                            textColor: AppThemeData.grey50,
                                            onPress: () async {
                                              // add back to cart
                                              reorder(
                                                item: item,
                                                controller: controller,
                                              );
                                            },
                                          ),
                          ),
                        )
                      : const SizedBox(),
                );
        });
  }

  reorder({
    required item,
    required OrderDetailsController controller,
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
