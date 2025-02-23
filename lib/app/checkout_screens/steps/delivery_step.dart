import 'package:customer/app/address_screens/address_list_screen.dart';
import 'package:customer/app/cart_screen/cart_detail.dart';
import 'package:customer/app/checkout_screens/rider_note_dialog.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/order_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

typedef void InitCallback(String value);

class DeliveryStep extends StatefulWidget {
  final cart;
  // final int index;
  final InitCallback onSelectDelivery;
  const DeliveryStep({
    super.key,
    required this.cart,
    // required this.index,
    required this.onSelectDelivery,
  });

  @override
  State<DeliveryStep> createState() => _DeliveryStepState();
}

class _DeliveryStepState extends State<DeliveryStep> {
  final controller = Get.find<OrderController>();
  final addressController = Get.find<AddressListController>();
  String delType = "delivery";
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Obx(
      () => ListView(
        padding: const EdgeInsets.all(2.0),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21.0),
              color: AppThemeData.primary100,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        delType = "delivery";
                        // controller.deliveryType.value == "delivery";
                      });
                      widget.onSelectDelivery("delivery");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21.0),
                        border: Border.all(
                          color: delType.toLowerCase() == "delivery"
                              ? AppThemeData.grey50
                              : Colors.transparent,
                        ),
                        color: delType.toLowerCase() == "delivery"
                            ? AppThemeData.primary400
                            : Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Delivery",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontFamily: AppThemeData.regular,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        delType = "pickup";
                        // controller.deliveryType.value == "pickup";
                      });
                      widget.onSelectDelivery("pickup");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: delType.toLowerCase() == "pickup"
                              ? AppThemeData.grey50
                              : Colors.transparent,
                        ),
                        color: delType.toLowerCase() == "pickup"
                            ? AppThemeData.primary400
                            : Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Pickup",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontFamily: AppThemeData.regular,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: Responsive.width(100, context),
            padding: const EdgeInsets.all(16.0),
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
                Text(
                  "Order Summary".tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontFamily: AppThemeData.bold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                              color: Colors.white,
                              child: Image.network(
                                '${widget.cart['vendor_location']['vendor']['logo']}',
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.cart['vendor_location']['vendor']['name']} ${widget.cart['vendor_location']['branch_name']}"
                                    .tr,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.regular,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${widget.cart['items']?.length} ${widget.cart['items']?.length > 1 ? "items" : "item"}"
                                        .tr,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                      fontFamily: AppThemeData.regular,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  const Icon(Icons.circle, size: 8.0),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    "₦${Constant.formatNumber(widget.cart['total_amount'])}"
                                        .tr,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: widget.cart['items']?.length < 1
                          ? null
                          : () {
                              orderBottomSheet(context, widget.cart);
                            },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8.0, top: 2.0),
                        child: Text(
                          "View".tr,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.primary500,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppThemeData.semiBold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          delType == "pickup"
              ? const SizedBox()
              : Container(
                  width: Responsive.width(100, context),
                  padding: const EdgeInsets.all(16.0),
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
                      Text(
                        "Delivery Information".tr,
                        style: TextStyle(
                          fontSize: 17,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.bike_scooter),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Get.to(
                                  AddressListScreen(),
                                  transition: Transition.cupertino,
                                );
                              },
                              child: Text(
                                addressController.shippingModel.value
                                        .getFullAddress()
                                        .isEmpty
                                    ? "Specify your delivery address"
                                    : addressController.shippingModel.value
                                        .getFullAddress(),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: Responsive.width(100, context),
            padding: const EdgeInsets.all(16.0),
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
                Text(
                  "Rider Note".tr,
                  style: TextStyle(
                    fontSize: 17,
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontFamily: AppThemeData.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RiderNoteDialog();
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.storefront),
                          const SizedBox(
                            width: 8.0,
                          ),
                          controller.riderNote.value.isNotEmpty
                              ? Text(
                                  "Rider Note: ".tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Text(
                                  "Leave a note for the rider".tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      controller.riderNote.value.isNotEmpty
                          ? Text(
                              controller.riderNote.value.tr,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                                fontFamily: AppThemeData.regular,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  orderBottomSheet(BuildContext context, cart) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: CartDetail(
          cart: cart,
          // index: widget.index,
          hideActions: true,
        ),
      ),
    );
  }
}
