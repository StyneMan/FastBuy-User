import 'package:customer/app/product_screens/product_detail.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final product;
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      height: 400,
      decoration: ShapeDecoration(
        color:
            themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextButton(
        onPressed: () {
          productBottomSheet(context, product);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0.0),
          foregroundColor: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Image.network(
                    "${product['images'][0]}",
                    height: 144,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: -4.0,
                  right: 0.0,
                  child: Chip(
                    label: Text(
                      "${product['category']['name']}".tr,
                      style: TextStyle(
                        fontSize: 10,
                        color: themeChange.getThem()
                            ? AppThemeData.primary400
                            : AppThemeData.secondary400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    padding: const EdgeInsets.all(0.0),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 4.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${product['name']}".tr,
                        style: TextStyle(
                          fontSize: 15,
                          color: themeChange.getThem()
                              ? AppThemeData.primary400
                              : AppThemeData.secondary400,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "₦${Constant.formatNumber(product['sale_amount'])}".tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      product['sale_amount'] != product['amount']
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 8.0),
                                Text(
                                  " ₦${Constant.formatNumber(product['amount'])}"
                                      .tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    fontStyle: FontStyle.italic,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey300
                                        : AppThemeData.grey500,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  productBottomSheet(BuildContext context, product) {
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
        child: ProductDetail(
          product: product,
        ),
      ),
    );
  }
}
