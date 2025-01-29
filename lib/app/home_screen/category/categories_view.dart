import 'package:customer/app/home_screen/category_restaurant_screen.dart';
import 'package:customer/app/logistics_screens/logistics.dart';
import 'package:customer/app/vendor_screens/all_vendors.dart';
import 'package:customer/controllers/home_controller.dart';
import 'package:customer/models/vendor_category_model.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatelessWidget {
  final HomeController controller;
  const CategoriesView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      decoration: ShapeDecoration(
        color:
            themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Browse Categories",
                          style: TextStyle(
                            fontFamily: AppThemeData.semiBold,
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(const ViewAllCategoryScreen());
                      //   },
                      //   child: Text(
                      //     "See all",
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontFamily: AppThemeData.medium,
                      //       color: themeChange.getThem()
                      //           ? AppThemeData.primary300
                      //           : AppThemeData.primary300,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  // const GradientText(
                  //   'Best Servings Food',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontFamily: 'Inter Tight',
                  //     fontWeight: FontWeight.w800,
                  //   ),
                  //   gradient: LinearGradient(colors: [
                  //     Color(0xFF3961F1),
                  //     Color(0xFF11D0EA),
                  //   ]),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 5 / 6),
              itemCount: controller.vendorCategoryModel.length >= 8
                  ? 8
                  : controller.vendorCategoryModel.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                VendorCategoryModel vendorCategoryModel =
                    controller.vendorCategoryModel[index];
                return InkWell(
                  onTap: () {
                    if (vendorCategoryModel.title?.toLowerCase() ==
                        "send packages") {
                      Get.to(const LogisticScreen(), arguments: {
                        "vendorCategoryModel": vendorCategoryModel,
                        "dineIn": false
                      });
                    } else if (vendorCategoryModel.title?.toLowerCase() ==
                        "restaurants") {
                      Get.to(
                        const Vendors(
                          title: "Restaurants",
                          type: "restaurants",
                        ),
                        transition: Transition.cupertino,
                      );
                    } else if (vendorCategoryModel.title?.toLowerCase() ==
                        "grocery") {
                      Get.to(
                        const Vendors(
                          title: "Grocery Stores",
                          type: "stores",
                        ),
                        transition: Transition.cupertino,
                      );
                    }
                  },
                  child: Center(
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                vendorCategoryModel.photo.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "${vendorCategoryModel.title}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
