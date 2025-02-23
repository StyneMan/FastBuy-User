import 'package:customer/app/product_screens/product_info_screen.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/home_controller.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerView extends StatelessWidget {
  final HomeController controller;

  const BannerView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    print("BANNER CONTROLLER HERE ::: ${controller.banners.value}");

    return SizedBox(
      height: 200,
      child: PageView.builder(
        physics: const CarouselScrollPhysics(),
        controller: controller.pageController.value,
        scrollDirection: Axis.horizontal,
        itemCount: (controller.banners.value['data'] ?? [])?.length,
        padEnds: false,
        pageSnapping: true,
        onPageChanged: (value) {
          controller.currentPage.value = value;
        },
        itemBuilder: (BuildContext context, int index) {
          final bannerModel = controller.banners.value['data'][index];
          return InkWell(
            onTap: () async {
              if (bannerModel['banner_type'] == "vendor_banner") {
                // ShowToastDialog.showLoader("Please wait".tr);
                // VendorModel? vendorModel = await FireStoreUtils.getVendorById(
                //     bannerModel.redirect_id.toString());

                // if (vendorModel!.zoneId == Constant.selectedZone!.id) {
                //   ShowToastDialog.closeLoader();
                //   Get.to(const RestaurantDetailsScreen(),
                //       arguments: {"vendorModel": vendorModel});
                // } else {
                //   ShowToastDialog.closeLoader();
                //   ShowToastDialog.showToast(
                //       "Sorry, The Zone is not available in your area. change the other location first.");
                // }
              } else if (bannerModel['banner_type'] == "product_banner") {
                Get.to(
                  ProductInfoScreen(
                    product: bannerModel['product'],
                  ),
                  transition: Transition.cupertino,
                );
              } else if (bannerModel['banner_type'] == "external_link") {
                final uri = Uri.parse("${bannerModel['external_link']}");
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  ShowToastDialog.showToast("Could not launch");
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(24),
                ),
                child: NetworkImageWidget(
                  imageUrl: "${bannerModel['image_res']}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
