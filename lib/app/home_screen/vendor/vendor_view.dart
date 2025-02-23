import 'package:customer/app/vendor_screens/all_vendors.dart';
import 'package:customer/app/vendor_screens/vendor_card.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/vendors_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class VendorView extends StatelessWidget {
  const VendorView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GetX(
          init: VendorsController(),
          builder: (controller) {
            debugPrint("VEND ::: ${controller.allvendors.value}");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "All Vendors",
                        style: TextStyle(
                          fontFamily: AppThemeData.semiBold,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(
                            const Vendors(title: "All Vendors", type: "all"),
                            transition: Transition.cupertino,
                          );
                        },
                        child: Text(
                          "See all",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.primary300
                                : AppThemeData.primary300,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                controller.allvendors.value.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:
                            Constant.showEmptyView(message: "No vendors found"),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item =
                              controller.allvendors.value['data'][index];
                          debugPrint("VENDORS CHECK ::: ${item}");
                          return Container(
                            padding: EdgeInsets.zero,
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey900
                                  : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: VendorCard(item: item),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 21.0),
                        itemCount: (controller.allvendors.value.isEmpty
                                ? []
                                : controller.allvendors.value['data'])
                            ?.length,
                      ),
                const SizedBox(
                  height: 24,
                ),
              ],
            );
          }),
    );
  }
}
