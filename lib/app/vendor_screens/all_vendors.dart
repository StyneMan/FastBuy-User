import 'package:customer/app/vendor_screens/vendor_card.dart';
import 'package:customer/controllers/vendors_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Vendors extends StatefulWidget {
  final String title;
  final String type;
  const Vendors({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  State<Vendors> createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> {
  // final vendorController = Get.find<VendorsController>();
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          themeChange.getThem() ? Colors.transparent : const Color(0xFFFAF6F1),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: themeChange.getThem()
            ? Colors.transparent
            : const Color(0xFFFAF6F1),
        title: Text(
          widget.title.tr,
          style: TextStyle(
            fontSize: 16,
            color: themeChange.getThem()
                ? AppThemeData.grey50
                : AppThemeData.grey900,
            fontFamily: AppThemeData.regular,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: GetX(
        init: VendorsController(),
        builder: (controller) {
          if (widget.type == "restaurants") {
            return controller.restaurantVendors.value.isEmpty
                ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Text(
                        "No restaurants found".tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PreferredSize(
                        preferredSize: const Size.fromHeight(55),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFieldWidget(
                            hintText: 'Search restaurants'.tr,
                            prefix: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SvgPicture.asset(
                                  "assets/icons/ic_search.svg"),
                            ),
                            controller: null,
                            onchange: (value) {
                              // controller.onSearchTextChanged(value);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          itemBuilder: (context, index) {
                            final item = controller
                                .restaurantVendors.value['data'][index];
                            debugPrint("VENDDORS CHECK ::: ${item}");
                            return VendorCard(item: item);
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16.0),
                          itemCount:
                              (controller.restaurantVendors.value['data'] ?? [])
                                  ?.length,
                        ),
                      ),
                    ],
                  );
          } else if (widget.type == "stores") {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(55),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFieldWidget(
                      hintText: 'Search for stores in your area'.tr,
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SvgPicture.asset("assets/icons/ic_search.svg"),
                      ),
                      controller: null,
                      onchange: (value) {
                        // controller.onSearchTextChanged(value);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      final item = controller.storeVendors.value['data'][index];
                      return VendorCard(item: item);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16.0),
                    itemCount:
                        (controller.storeVendors.value['data'] ?? [])?.length,
                  ),
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PreferredSize(
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
                      // controller.onSearchTextChanged(value);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final item = controller.allvendors.value['data'][index];
                    return VendorCard(item: item);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16.0),
                  itemCount:
                      (controller.allvendors.value['data'] ?? [])?.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
