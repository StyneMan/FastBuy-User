import 'dart:convert';

import 'package:customer/app/product_screens/product_card.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/widget/shimmer/product_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  final String? categoryId;
  final String branchId;
  const ProductList({
    super.key,
    this.categoryId,
    required this.branchId,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return FutureBuilder(
        future: APIService().getVendorLocationProducts(
          branchId: branchId,
          page: 1,
          categoryId: categoryId,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.data != null) {
            final resp = snapshot.data;
            debugPrint("RESPONSE OF PRODUCTS ::: ${resp?.body}");
            Map<String, dynamic> map = jsonDecode("${resp?.body}");
            final products = map['data'];

            if ((products ?? [])?.length == 0 || map['totalItems'] == 0) {
              return Center(
                  child: Column(
                children: [
                  const SizedBox(height: 48.0),
                  Image.asset("assets/images/empty.png"),
                  Text(
                    "No product found".tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey900,
                      fontFamily: AppThemeData.regular,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ));
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4.8 / 6.8,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                  itemCount: (products ?? [])?.length ?? 0,
                )
              ],
            );
          }

          return const ProductShimmer();
        });
  }
}
