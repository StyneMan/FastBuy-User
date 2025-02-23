import 'dart:convert';

import 'package:customer/app/vendor_screens/vendor_detail.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/favourite_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:customer/widget/restaurant_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class VendorCard extends StatefulWidget {
  final item;
  const VendorCard({
    super.key,
    required this.item,
  });

  @override
  State<VendorCard> createState() => _VendorCardState();
}

class _VendorCardState extends State<VendorCard> {
  bool _isTempLiked = false;
  final addressController = Get.put(AddressListController());

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      decoration: ShapeDecoration(
        color:
            themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.to(
            VendorDetail(item: widget.item),
            transition: Transition.cupertino,
          );
        },
        child: GetX(
            init: FavouriteController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            RestaurantImageView(
                              images: widget.item['vendor']['cover'],
                            ),
                            Container(
                              height: Responsive.height(20, context),
                              width: Responsive.width(100, context),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(-0.00, -1.00),
                                  end: const Alignment(0, 1),
                                  colors: [
                                    Colors.black.withOpacity(0),
                                    const Color(0xFF111827)
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Obx(
                                () => InkWell(
                                  onTap: () async {
                                    try {
                                      // Persist UI first
                                      if (_isTempLiked) {
                                        setState(() {
                                          _isTempLiked = false;
                                        });
                                      } else {
                                        setState(() {
                                          _isTempLiked = true;
                                        });
                                      }
                                      // ShowToastDialog.showLoader(
                                      //     "Please wait".tr);
                                      final String accessToken =
                                          Preferences.getString(
                                              Preferences.accessTokenKey);
                                      final resp =
                                          await APIService().addFavourite(
                                        accessToken: accessToken,
                                        branchId: widget.item['id'],
                                      );
                                      // ShowToastDialog.closeLoader();
                                      debugPrint(
                                          "FAVOURITE RESPONSE ::: ${resp.body}");
                                      if (resp.statusCode >= 200 &&
                                          resp.statusCode <= 299) {
                                        Map<String, dynamic> map =
                                            jsonDecode(resp.body);
                                        setState(() {
                                          _isTempLiked = _isTempLiked;
                                        });
                                        controller.refreshData();
                                      }
                                    } catch (e) {
                                      debugPrint("$e");
                                      // ShowToastDialog.closeLoader();
                                    }
                                  },
                                  child:
                                      (controller.favouriteList.value.isNotEmpty
                                                      ? controller.favouriteList
                                                          .value['data']
                                                      : [])
                                                  ?.where((p0) =>
                                                      p0['branchId'] ==
                                                      widget.item['id'])
                                                  .isNotEmpty ||
                                              _isTempLiked
                                          ? SvgPicture.asset(
                                              "assets/icons/ic_like_fill.svg",
                                            )
                                          : SvgPicture.asset(
                                              "assets/icons/ic_like.svg",
                                            ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(Responsive.width(-3, context),
                            Responsive.height(17.5, context)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: ShapeDecoration(
                                color: themeChange.getThem()
                                    ? AppThemeData.primary600
                                    : AppThemeData.primary50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(120),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_star.svg",
                                      colorFilter: ColorFilter.mode(
                                          AppThemeData.primary300,
                                          BlendMode.srcIn),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.item['rating']}",
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.primary300
                                            : AppThemeData.primary300,
                                        fontFamily: AppThemeData.semiBold,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                color: AppThemeData.primary300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(120),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_map_distance.svg",
                                      colorFilter: const ColorFilter.mode(
                                        AppThemeData.secondary400,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${Constant.getDistance(
                                        lat1: "${widget.item['lat']}",
                                        lng1: "${widget.item['lng']}",
                                        lat2:
                                            "${addressController.location.value.latitude ?? 6.18333300}",
                                        lng2:
                                            "${addressController.location.value.longitude ?? 6.2123}",
                                      )} ${Constant.distanceType}",
                                      style: const TextStyle(
                                        color: AppThemeData.secondary400,
                                        fontFamily: AppThemeData.semiBold,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.item['vendor']['name']} ${widget.item['branch_name']}",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: AppThemeData.semiBold,
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                          ),
                        ),
                        Text(
                          widget.item['street'].toString(),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: AppThemeData.medium,
                            fontWeight: FontWeight.w500,
                            color: themeChange.getThem()
                                ? AppThemeData.grey400
                                : AppThemeData.grey400,
                          ),
                        )
                      ],
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
