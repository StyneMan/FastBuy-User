import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/controllers/vendors_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final product;
  const ProductDetail({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var controllr;
  int quantity = 1;
  int oldQuantity = 1;
  int total = 0;

  final vendorController = Get.find<VendorsController>();
  final cartController = Get.find<CartController>();
  final Map<Map<String, dynamic>, bool> _selectedItems = {};
  var _selectedItemsList = [];

  @override
  void initState() {
    super.initState();
    controllr = PageController(initialPage: 0);
    setState(() {
      total = widget.product['sale_amount'];
    });
    // Initialize all items as unselected
    for (var item in vendorController.packOptions.value) {
      _selectedItems[item] = false;
    }
  }

  // Getter to retrieve only selected items
  List<Map<String, dynamic>> get _selectedList {
    setState(() {
      _selectedItemsList = _selectedItems.entries
          .where((entry) => entry.value) // Only include selected items
          .map((entry) => {
                "name": entry.key['name'], // Extract the name
                "value": entry.key['cost'], // Extract the cost
              })
          .toList();
    });
    return _selectedItems.entries
        .where((entry) => entry.value) // Only include selected items
        .map((entry) => entry.key) // Get the item (key)
        .toList();
  }

  int incrementor(int quant) {
    if (widget.product['is_variable'] || widget.product['variations'] != null) {
      // setState(() {
      //   total = quant * 1;
      // });
      return 0;
    } else {
      // setState(() {
      //   total = quant * widget.product['sale_amount'];
      // });
      int q = quant - oldQuantity;
      int result = q * widget.product['sale_amount'] as int;
      debugPrint("QUANTITY ::: $oldQuantity");
      debugPrint("QUANT ::: $quant");
      debugPrint("RESL ::: $result");
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 225,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: controllr,
                onPageChanged: (int value) {
                  controllr.jumpToPage(value);
                },
                itemCount: widget.product['images'].length,
                itemBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.275,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    image: DecorationImage(
                      image: NetworkImage("${widget.product['images'][index]}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.product['name']}".tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "₦${Constant.formatNumber(widget.product['sale_amount'])}"
                                .tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          widget.product['sale_amount'] !=
                                  widget.product['amount']
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 8.0),
                                    Text(
                                      " ₦${Constant.formatNumber(widget.product['amount'])}"
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
                  Html(
                    data: widget.product['description'],
                    shrinkWrap: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(
                    () => ExpansionPanelList(
                      elevation: 0,
                      expandedHeaderPadding: const EdgeInsets.all(0.0),
                      expandIconColor: AppThemeData.primary400,
                      expansionCallback: (int index, bool isExpanded) {
                        vendorController.isOptionsExpanded.value =
                            !vendorController.isOptionsExpanded.value;
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(
                                "Packing Options".tr,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(0.0),
                              dense: true,
                            );
                          },
                          backgroundColor: Colors.transparent,
                          body: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: vendorController
                                      .packOptions.value?.length,
                                  itemBuilder: (context, index) {
                                    final item = vendorController
                                        .packOptions.value[index];
                                    return CheckboxListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            item['name'],
                                            style: TextStyle(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey50
                                                  : AppThemeData.grey900,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "₦${Constant.formatNumber(item['cost'])}",
                                            style: TextStyle(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey50
                                                  : AppThemeData.grey900,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(0.0),
                                      value: _selectedItems[item],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _selectedItems[item] = value ?? false;

                                          // Recalculate total
                                          if (value == true) {
                                            // Add the item's cost to the total
                                            total += item['cost'] as int;
                                          } else {
                                            // Subtract the item's cost from the total
                                            total -= item['cost'] as int;
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          isExpanded: vendorController.isOptionsExpanded.value,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Expanded(
            //   flex: 1,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Container(
            //         padding: const EdgeInsets.all(8.0),
            //         decoration: BoxDecoration(
            //           color: quantity == 1
            //               ? AppThemeData.primary100
            //               : AppThemeData.primary400,
            //           borderRadius: BorderRadius.circular(8.0),
            //         ),
            //         child: InkWell(
            //           onTap: quantity == 1
            //               ? null
            //               : () {
            //                   if (quantity > 1) {
            //                     setState(() {
            //                       oldQuantity = quantity;
            //                       quantity = quantity - 1;
            //                       total = total + incrementor(quantity);
            //                     });
            //                   }
            //                 },
            //           child: const Icon(
            //             CupertinoIcons.minus,
            //             size: 19,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 4,
            //       ),
            //       Expanded(
            //         child: Text(
            //           "$quantity".tr,
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 18,
            //             color: themeChange.getThem()
            //                 ? AppThemeData.grey50
            //                 : AppThemeData.grey900,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 4,
            //       ),
            //       Container(
            //         padding: const EdgeInsets.all(8.0),
            //         decoration: BoxDecoration(
            //           color: AppThemeData.primary400,
            //           borderRadius: BorderRadius.circular(8.0),
            //         ),
            //         child: InkWell(
            //           onTap: () {
            //             setState(() {
            //               oldQuantity = quantity;
            //               quantity = quantity + 1;
            //               total = total + incrementor(quantity) as int;
            //             });
            //           },
            //           child: const Icon(
            //             CupertinoIcons.add,
            //             size: 19,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   width: 16,
            // ),
            Expanded(
              flex: 2,
              child: RoundedButtonFill(
                title: "Add ₦${Constant.formatNumber(total)} to cart".tr,
                height: 5.5,
                color: AppThemeData.primary300,
                fontSizes: 16,
                onPress: () {
                  addToCart();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  addToCart() async {
    try {
      Get.back();
      ShowToastDialog.showLoader("Please wait".tr);
      Map payload = {
        "total_amount": total,
        "vendor_id": widget.product['vendor']['id'],
        "item": {
          "name": widget.product['name'],
          "amount": widget.product['sale_amount'],
          "product_id": widget.product['id'],
          "selections": _selectedItemsList,
          "images": widget.product['images']
        }
      };
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      final resp = await APIService().addToCart(
        accessToken: accessToken,
        payload: payload,
      );
      ShowToastDialog.closeLoader();
      debugPrint("ADD TO CART RESPONSE ::: ${resp.body}");
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast("${map['message']}");
        // Show SnackBar with extended duration
        cartController.currentCartItems.value = map['data']['items'];
        cartController.refreshCart();
      } else {
        Map<String, dynamic> errMap = jsonDecode(resp.body);
        Constant.toast("${errMap['message']}");
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint("$e");
    }
  }
}
