import 'package:customer/app/vendor_screens/vendor_card.dart';
import 'package:customer/controllers/vendors_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NearbyVendorView extends StatelessWidget {
  const NearbyVendorView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GetX(
          init: VendorsController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text(
                    "Nearby Vendors",
                    style: TextStyle(
                      fontFamily: AppThemeData.semiBold,
                      color: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey900,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: controller.nearbyVendors.value.isEmpty ||
                          controller.nearbyVendors.value['data'].length < 1
                      ? const Center(
                          child: Text(
                              "No nearby vendors found. Change your location"),
                        )
                      : ListView.separated(
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final item =
                                controller.allvendors.value['data'][index];
                            debugPrint("VENDORS CHECK ::: $item");
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: VendorCard(item: item),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 16.0),
                          itemCount: (controller.nearbyVendors.value.isEmpty
                                  ? []
                                  : controller.nearbyVendors.value['data'])
                              ?.length,
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            );
          }),
    );
  }
}
