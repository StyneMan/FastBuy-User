import 'package:customer/app/vendor_screens/all_vendors.dart';
import 'package:customer/app/vendor_screens/vendor_card.dart';
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
    return Container(
      color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GetX(
            init: VendorsController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "All Vendors",
                            style: TextStyle(
                              fontFamily: AppThemeData.semiBold,
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontSize: 18,
                            ),
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
                              fontFamily: AppThemeData.medium,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = controller.allvendors.value['data'][index];
                        debugPrint("VENDORS CHECK ::: ${item}");
                        return VendorCard(item: item);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.0),
                      itemCount: (controller.allvendors.value.isEmpty
                              ? []
                              : controller.allvendors.value['data'])
                          ?.length,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
