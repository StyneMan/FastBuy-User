import 'package:customer/app/product_screens/product_card.dart';
import 'package:customer/app/vendor_screens/vendor_card.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/search_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine number of columns dynamically based on screen size
    int crossAxisCount = screenWidth > 800
        ? 3 // Desktop
        : screenWidth > 800
            ? 2
            : 2; // Otther Phones

    // Calculate item width based on screen size
    double itemWidth = screenWidth / crossAxisCount;

    // Set item height dynamically (e.g., making height 1.2 times the width)
    double itemHeight = itemWidth * 1.4; // Adjust this factor as needed

    return GetX(
        init: SearchScreenController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.surface,
              centerTitle: false,
              titleSpacing: 0,
              title: Text(
                "Search Vendors & Products".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: AppThemeData.medium,
                  fontSize: 16,
                  color: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey900,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(55),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFieldWidget(
                    hintText:
                        'Search the stores, restaurants, products, meals'.tr,
                    prefix: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SvgPicture.asset("assets/icons/ic_search.svg"),
                    ),
                    controller: null,
                    onchange: (value) {
                      controller.onSearchTextChanged(value);
                    },
                  ),
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          controller.vendorSearchList.isEmpty
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Vendors".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        fontSize: 16,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(),
                                    ),
                                  ],
                                ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.vendorSearchList.length,
                            itemBuilder: (context, index) {
                              final vendorModel =
                                  controller.vendorSearchList[index];
                              return VendorCard(item: vendorModel);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 16.0,
                            ),
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          controller.productSearchList.isEmpty
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Products".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: AppThemeData.semiBold,
                                        fontSize: 16,
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey50
                                            : AppThemeData.grey900,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(),
                                    ),
                                  ],
                                ),
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio:
                                  itemWidth / itemHeight, // Dynamic height
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.productSearchList.length,
                            itemBuilder: (context, index) {
                              final productModel =
                                  controller.productSearchList[index];

                              debugPrint("proDCt iTEM ::: $productModel");

                              return ProductCard(
                                product: productModel,
                              );
                            },
                          ),
                          // ListView.builder(
                          //   shrinkWrap: true,
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   itemCount: controller.productSearchList.length,
                          //   itemBuilder: (context, index) {
                          //     final productModel =
                          //         controller.productSearchList[index];

                          //     debugPrint("proDCt iTEM ::: $productModel");

                          //     return ProductCard(
                          //       product: productModel,
                          //     );
                          //   },
                          // )
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
