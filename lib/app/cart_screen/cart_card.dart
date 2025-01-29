import 'package:customer/app/cart_screen/cart_detail.dart';
import 'package:customer/app/checkout_screens/checkout_screen.dart';
import 'package:customer/app/vendor_screens/vendor_detail.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/round_button_border.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartCard extends StatelessWidget {
  final item;
  final int index;
  const CartCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: Responsive.width(100, context),
      decoration: ShapeDecoration(
        color:
            themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                          '${item['vendor']['logo']}',
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
                          "${item['vendor']['name']}".tr,
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
                              "${item['items']?.length} ${item['items']?.length > 1 ? "items" : "item"}"
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
                              "₦${Constant.formatNumber(item['total_amount'])}"
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
                onTap: item['items']?.length < 1
                    ? null
                    : () {
                        orderBottomSheet(context, item);
                      },
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, left: 8.0, top: 2.0),
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
          const SizedBox(
            height: 8.0,
          ),
          const Divider(),
          const SizedBox(
            height: 16.0,
          ),
          RoundedButtonFill(
            onPress: () {
              if (item['items']?.length > 0) {
                Get.to(
                  CheckoutScreen(
                    cart: item,
                    index: index,
                  ),
                  transition: Transition.cupertino,
                );
              } else {
                Get.to(
                  VendorDetail(
                    item: item['vendor'],
                  ),
                  transition: Transition.cupertino,
                );
              }
            },
            title: item['items']?.length > 0 ? "Checkout" : "Add Items",
            color: AppThemeData.primary300,
            textColor: AppThemeData.grey900,
          ),
          const SizedBox(
            height: 16.0,
          ),
          RoundedButtonBorder(
            onPress: () {},
            title: "Remove Item",
            borderColor: AppThemeData.primary400,
            textColor: AppThemeData.primary400,
          ),
          const SizedBox(
            height: 8.0,
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
          // list: cart['items'],
          index: index,
        ),
      ),
    );
  }
}
