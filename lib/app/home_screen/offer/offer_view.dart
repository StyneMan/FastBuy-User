import 'package:customer/controllers/home_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfferView extends StatelessWidget {
  final HomeController controller;

  const OfferView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
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
                      "Available Offers",
                      style: TextStyle(
                        fontFamily: AppThemeData.semiBold,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Get.to(const DiscountVendorsScreen(), arguments: {
                      //   "vendorList": controller.couponRestaurantList,
                      //   "couponList": controller.couponList,
                      //   "title": "Discount Vendors"
                      // });
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
              // const GradientText(
              //   'Save Upto 50% Off',
              //   style: TextStyle(
              //     fontSize: 21,
              //     fontFamily: 'Inter Tight',
              //     fontWeight: FontWeight.w800,
              //   ),
              //   gradient: LinearGradient(colors: [
              //     Color(0xFF39F1C5),
              //     Color(0xFF97EA11),
              //   ]),
              // ),
            ],
          ),
        ),
        // Container(
        //     decoration: ShapeDecoration(
        //       color: themeChange.getThem()
        //           ? AppThemeData.grey900
        //           : AppThemeData.grey50,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(24),
        //       ),
        //     ),
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.width * 0.32,
        //     child: 2 > 1
        //         ? const Center(child: Text("No offers available"))
        //         : ListView.builder(
        //             shrinkWrap: true,
        //             scrollDirection: Axis.horizontal,
        //             physics: const BouncingScrollPhysics(),
        //             itemCount: controller.couponRestaurantList.length >= 15
        //                 ? 15
        //                 : controller.couponRestaurantList.length,
        //             itemBuilder: (context, index) {
        //               VendorModel vendorModel =
        //                   controller.couponRestaurantList[index];
        //               CouponModel offerModel = controller.couponList[index];
        //               return InkWell(
        //                 onTap: () {
        //                   Get.to(const RestaurantDetailsScreen(),
        //                       arguments: {"vendorModel": vendorModel});
        //                 },
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(right: 10),
        //                   child: SizedBox(
        //                     width: Responsive.width(34, context),
        //                     child: ClipRRect(
        //                       borderRadius:
        //                           const BorderRadius.all(Radius.circular(10)),
        //                       child: Stack(
        //                         children: [
        //                           NetworkImageWidget(
        //                             imageUrl: vendorModel.photo.toString(),
        //                             fit: BoxFit.cover,
        //                             height: Responsive.height(100, context),
        //                             width: Responsive.width(100, context),
        //                           ),
        //                           Container(
        //                             decoration: BoxDecoration(
        //                               gradient: LinearGradient(
        //                                 begin: const Alignment(-0.00, -1.00),
        //                                 end: const Alignment(0, 1),
        //                                 colors: [
        //                                   Colors.black.withOpacity(0),
        //                                   AppThemeData.grey900
        //                                 ],
        //                               ),
        //                             ),
        //                           ),
        //                           Align(
        //                             alignment: Alignment.bottomCenter,
        //                             child: Padding(
        //                               padding: const EdgeInsets.symmetric(
        //                                   vertical: 10),
        //                               child: Column(
        //                                 mainAxisSize: MainAxisSize.min,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.center,
        //                                 children: [
        //                                   Text(
        //                                     vendorModel.title.toString(),
        //                                     textAlign: TextAlign.start,
        //                                     maxLines: 1,
        //                                     style: TextStyle(
        //                                       fontSize: 18,
        //                                       overflow: TextOverflow.ellipsis,
        //                                       fontFamily: AppThemeData.semiBold,
        //                                       color: themeChange.getThem()
        //                                           ? AppThemeData.grey50
        //                                           : AppThemeData.grey50,
        //                                     ),
        //                                   ),
        //                                   const SizedBox(
        //                                     height: 5,
        //                                   ),
        //                                   RoundedButtonFill(
        //                                     title:
        //                                         "${offerModel.discountType == "Fix Price" ? "${Constant.currencyModel!.symbol}" : ""}${offerModel.discount}${offerModel.discountType == "Percentage" ? "% off".tr : "off".tr}",
        //                                     color: Colors.primaries[Random()
        //                                         .nextInt(
        //                                             Colors.primaries.length)],
        //                                     textColor: AppThemeData.grey50,
        //                                     width: 20,
        //                                     height: 3.5,
        //                                     onPress: () async {},
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             })),
        // const SizedBox(
        //   height: 20,
        // ),
      ],
    );
  }
}
