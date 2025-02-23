import 'package:customer/app/dash_board_screens/dash_board_screen.dart';
import 'package:customer/app/logistics_screens/logistic_model.dart';
import 'package:customer/app/order_list_screen/order_details_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/dash_board_controller.dart';
import 'package:customer/controllers/logistics_controller.dart';
import 'package:customer/controllers/order_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:customer/widget/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LogisticScreen extends StatefulWidget {
  const LogisticScreen({super.key});

  @override
  State<LogisticScreen> createState() => _LogisticScreenState();
}

class _LogisticScreenState extends State<LogisticScreen> {
  final orderController = Get.find<OrderController>();
  final dashboardController = Get.find<DashBoardController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          themeChange.getThem() ? Colors.transparent : const Color(0xFFFAF6F1),
      appBar: AppBar(
        backgroundColor: themeChange.getThem()
            ? Colors.transparent
            : const Color(0xFFFAF6F1),
        automaticallyImplyLeading: true,
      ),
      body: GetX(
          init: LogisticsController(),
          builder: (controller) {
            return Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Parcel & Logistics".tr,
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
                        "Speed, Safety, and Satisfaction—Delivered.".tr,
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
                      const SizedBox(
                        height: 6,
                      ),
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4 / 3,
                        ),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                logisticActions[index].component,
                                transition: Transition.cupertino,
                              );
                            },
                            child: Container(
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
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    logisticActions[index].icon,
                                    Text(
                                      logisticActions[index].title.tr,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                        fontFamily: AppThemeData.regular,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        itemCount: logisticActions.length,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Order History",
                            style: TextStyle(
                              fontFamily: AppThemeData.semiBold,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontSize: 18,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              dashboardController.selectedIndex.value = 3;
                              Get.to(
                                const DashBoardScreen(),
                                transition: Transition.cupertino,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "View All",
                                style: TextStyle(
                                  fontFamily: AppThemeData.semiBold,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      orderController.myParcelOrders.value.isEmpty
                          ? const SizedBox(
                              height: 200,
                              child: Center(child: Text("No orders found")),
                            )
                          : ListView.builder(
                              // itemCount: orderController
                              //     .myParcelOrders.value['data']?.length,
                              itemCount: orderController
                                          .myParcelOrders.value['data'] ==
                                      null
                                  ? 0
                                  : (orderController.myParcelOrders
                                              .value['data'].length >
                                          3
                                      ? 3
                                      : orderController.myParcelOrders
                                          .value['data'].length), // Limit to 5
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                // OrderModel orderModel =
                                //     controller
                                //         .allList[index];
                                final item = orderController
                                    .myParcelOrders.value['data'][index];
                                return itemView(
                                  themeChange,
                                  context,
                                  item,
                                  orderController,
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
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
                  item['order_status'] == "completed"
                      ? Expanded(
                          child: InkWell(
                            onTap: () {
                              // for (var element in orderModel.products!) {
                              //   controller.addToCart(cartProductModel: element);
                              //   ShowToastDialog.showToast(
                              //       "Item Added In a cart");
                              // }
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
                      : item['order_status'] == "ready_for_delivery" ||
                              item['order_status'] == "in_delivery"
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
                        // Get.off(const OrderPlacingScreen(), arguments: {"orderModel": orderModel});
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
}
