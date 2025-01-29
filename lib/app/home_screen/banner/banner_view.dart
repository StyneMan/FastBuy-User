import 'package:customer/controllers/home_controller.dart';
import 'package:customer/models/BannerModel.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:flutter/material.dart';

class BannerView extends StatelessWidget {
  final HomeController controller;

  const BannerView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    print("BANNER CONTROLLER HERE ::: ${controller.bannerModel}");

    return SizedBox(
      height: 150,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: controller.pageController.value,
        scrollDirection: Axis.horizontal,
        itemCount: controller.bannerModel.length,
        padEnds: false,
        pageSnapping: true,
        onPageChanged: (value) {
          controller.currentPage.value = value;
        },
        itemBuilder: (BuildContext context, int index) {
          BannerModel bannerModel = controller.bannerModel.value[index];
          return InkWell(
            onTap: () async {
              if (bannerModel.redirect_type == "store") {
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
              } else if (bannerModel.redirect_type == "product") {
                // ShowToastDialog.showLoader("Please wait".tr);
                // ProductModel? productModel =
                //     await FireStoreUtils.getProductById(
                //         bannerModel.redirect_id.toString());
                // VendorModel? vendorModel = await FireStoreUtils.getVendorById(
                //     productModel!.vendorID.toString());

                // if (vendorModel!.zoneId == Constant.selectedZone!.id) {
                //   ShowToastDialog.closeLoader();
                //   Get.to(const RestaurantDetailsScreen(),
                //       arguments: {"vendorModel": vendorModel});
                // } else {
                //   ShowToastDialog.closeLoader();
                //   ShowToastDialog.showToast(
                //       "Sorry, The Zone is not available in your area. change the other location first.");
                // }
              } else if (bannerModel.redirect_type == "external_link") {
                // final uri = Uri.parse(bannerModel.redirect_id.toString());
                // if (await canLaunchUrl(uri)) {
                //   await launchUrl(uri);
                // } else {
                //   ShowToastDialog.showToast("Could not launch");
                // }
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: NetworkImageWidget(
                  imageUrl: bannerModel.photo.toString(),
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
