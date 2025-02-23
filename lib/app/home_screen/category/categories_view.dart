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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          controller.vendorCategoryModel.length >= 8
              ? 8
              : controller.vendorCategoryModel.length,
          (index) {
            VendorCategoryModel vendorCategoryModel =
                controller.vendorCategoryModel[index];
            return SizedBox(
              width: 100,
              child: Container(
                decoration: ShapeDecoration(
                  color: themeChange.getThem()
                      ? AppThemeData.grey900
                      : AppThemeData.grey50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: InkWell(
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
                      height: 75,
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(2.0),
                      child: ClipOval(
                        child: Image.asset(
                          vendorCategoryModel.photo.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
