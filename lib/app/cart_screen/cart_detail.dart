import 'package:customer/app/cart_screen/vendor_note_dialog.dart';
import 'package:customer/app/checkout_screens/checkout_screen.dart';
import 'package:customer/app/vendor_screens/vendor_detail.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_border.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:customer/widget/text_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartDetail extends StatefulWidget {
  final cart;
  // final int index;
  final bool hideActions;
  const CartDetail({
    super.key,
    required this.cart,
    // required this.index,
    this.hideActions = false,
  });

  @override
  State<CartDetail> createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  // var list = [];
  final controller = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    controller.currentCartItems.value = widget.cart['items'];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ITEMINSE :: ${widget.cart['items']}");
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Container(
                  width: 134,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: ShapeDecoration(
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Review Order".tr,
                      style: TextStyle(
                        fontSize: 18,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    controller.currentCartItems.value.isEmpty
                        ? Constant.showEmptyView(message: "No orders found.")
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, indx) {
                              final item =
                                  controller.currentCartItems.value[indx] ??
                                      widget.cart['items'][indx];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              "${item['product']['images'][0]}",
                                              fit: BoxFit.cover,
                                              width: 48,
                                              height: 56,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${item['name']}".tr,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey50
                                                      : AppThemeData.grey900,
                                                  fontFamily:
                                                      AppThemeData.regular,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "₦${Constant.formatNumber(item['amount'])}",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              deleteItem(indx);
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.delete,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                          ),
                                          Text(
                                            "${item['extras']?.length} ${item['extras']?.length > 1 ? "selections" : "selection"}",
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 21.0,
                            ),
                            itemCount: controller.currentCartItems.value.length,
                          ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextDivider(
                      text: Chip(
                        label: InkWell(
                          onTap: () {
                            Get.to(
                              VendorDetail(
                                item: widget.cart['vendor_location'],
                              ),
                              transition: Transition.cupertino,
                            );
                          },
                          child: Text(
                            "Add more items".tr,
                            style: TextStyle(
                              fontSize: 11,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.regular,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.036,
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return VendorNoteDialog(
                              cartId: widget.cart['id'],
                            );
                          },
                        );
                      },
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
                              widget.cart['vendor_note'].isNotEmpty
                                  ? Text(
                                      "Vendor Note: ".tr,
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
                                      "Leave a note for the vendor".tr,
                                      textAlign: TextAlign.start,
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
                          widget.cart['vendor_note'].isNotEmpty
                              ? Text(
                                  "${widget.cart['vendor_note']}".tr,
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
                    const SizedBox(
                      height: 16.0,
                    ),
                    widget.hideActions
                        ? const SizedBox()
                        : RoundedButtonFill(
                            title: "Proceed to Checkout".tr,
                            height: 5.5,
                            color: AppThemeData.primary300,
                            textColor: AppThemeData.grey50,
                            fontSizes: 16,
                            onPress: () {
                              Get.back();
                              Get.to(
                                CheckoutScreen(
                                  cart: widget.cart,
                                  // index: widget.index,
                                ),
                                transition: Transition.cupertino,
                              );
                            },
                          ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    widget.hideActions
                        ? const SizedBox()
                        : RoundedButtonBorder(
                            title: "Clear Order",
                            onPress: () {
                              clearAllItems(
                                controller: controller,
                                cartId: widget.cart['id'],
                              );
                            },
                            height: 5.5,
                            fontSizes: 16,
                            textColor: AppThemeData.primary300,
                            borderColor: AppThemeData.primary300,
                          ),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteItem(indx) async {
    try {
      // ShowToastDialog.showLoader("Please wait...".tr);
      final item = controller.currentCartItems.value[indx];
      //     controller.cartData.value['data'][widget.index]['items'][indx];
      var lst = controller.currentCartItems.value
          .where((elem) => elem['id'] != item['id'])
          .toList();
      // setState(() {
      controller.currentCartItems.value = lst;
      // });

      debugPrint("FILTERED  LIST ::: $lst");

      // controller.cartData.value['data'][widget.index]['items'] = lst;
      final token = Preferences.getString(Preferences.accessTokenKey);
      final resp = await APIService().removeCartItem(
        accessToken: token,
        cartItemId: item['id'],
      );
      debugPrint("RESPONSE DELETE CART ITEM ::: ${resp.body}");
      // Npw refresh cart here
      controller.refreshCart();
    } catch (e) {
      debugPrint("$e");
    }
  }

  clearAllItems(
      {required CartController controller, required String cartId}) async {
    try {
      // controller.cartData.value['data'][widget.index]['items'] = lst;
      final token = Preferences.getString(Preferences.accessTokenKey);
      final resp = await APIService().clearAllCartItems(
        accessToken: token,
        cartId: cartId,
      );
      debugPrint("RESPONSE DELETE CART ::: ${resp.body}");
      // Npw refresh cart here
      controller.refreshCart();
    } catch (e) {
      debugPrint("$e");
    }
  }
}
