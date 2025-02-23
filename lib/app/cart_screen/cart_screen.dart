import 'package:customer/app/cart_screen/cart_card.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CartController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? Colors.transparent
                : const Color(0xFFFAF6F1),
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? Colors.transparent
                  : const Color(0xFFFAF6F1),
              title: Text(
                "My Cart".tr,
                style: TextStyle(
                  fontSize: 16,
                  color: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey900,
                  fontFamily: AppThemeData.regular,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: controller.cartData.value['data']?.isEmpty
                ? Constant.showEmptyView(message: "Cart is empty")
                : Obx(
                    () => ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemBuilder: (context, index) {
                        final item = controller.cartData.value['data'][index];
                        return CartCard(
                          item: item,
                          index: index,
                          controller: controller,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16.0,
                      ),
                      itemCount: controller.cartData.value['data']?.length,
                    ),
                  ),
          );
        });
  }
}
