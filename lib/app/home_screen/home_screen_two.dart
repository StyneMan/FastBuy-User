import 'package:badges/badges.dart' as badges;
import 'package:customer/app/address_screens/address_list_screen.dart';
import 'package:customer/app/auth_screen/login_screen.dart';
import 'package:customer/app/cart_screen/cart_screen.dart';
import 'package:customer/app/home_screen/banner/banner_view.dart';
import 'package:customer/app/home_screen/offer/offer_view.dart';
import 'package:customer/app/home_screen/vendor/nearby_vendor_view.dart';
import 'package:customer/app/location_permission_screen/location_permission_screen.dart';
import 'package:customer/app/search_screen/search_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/controllers/dash_board_controller.dart';
import 'package:customer/controllers/home_controller.dart';
import 'package:customer/controllers/my_profile_controller.dart';

import 'package:customer/models/user_model.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:customer/widget/gradiant_text.dart';
import 'package:customer/widget/place_picker_osm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:provider/provider.dart';

import 'category/categories_view.dart';
import 'vendor/vendor_view.dart';

class HomeScreenTwo extends StatelessWidget {
  HomeScreenTwo({super.key});

  final _profileController = Get.find<MyProfileController>();
  final _cartController = Get.find<CartController>();
  // final _vendorController = Get.find<VendorsController>();
  final _addressController = Get.find<AddressListController>();

  @override
  Widget build(BuildContext context) {
    // Constant.selectedLocation.address = "";
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.getThem()
              ? AppThemeData.surfaceDark
              : const Color(0xFFFAF6F1),
          body: controller.isLoading.value
              ? Constant.loader()
              : _addressController.location.value.latitude == null ||
                      _addressController.location.value.longitude == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/location.gif",
                            height: 120,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Select your location".tr,
                            style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey100
                                    : AppThemeData.grey800,
                                fontSize: 22,
                                fontFamily: AppThemeData.semiBold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "You need to set your location to enjoy the best of FastBuy."
                                .tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey500,
                                fontSize: 16,
                                fontFamily: AppThemeData.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RoundedButtonFill(
                            title: "Set Location".tr,
                            width: 55,
                            height: 5.5,
                            color: AppThemeData.primary300,
                            textColor: AppThemeData.grey50,
                            onPress: () async {
                              Get.offAll(
                                const LocationPermissionScreen(),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).viewPadding.top,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        DashBoardController
                                            dashBoardController =
                                            Get.put(DashBoardController());
                                        if (Constant.walletSetting == false) {
                                          dashBoardController
                                              .selectedIndex.value = 3;
                                        } else {
                                          dashBoardController
                                              .selectedIndex.value = 4;
                                        }
                                      },
                                      child: ClipOval(
                                        child: NetworkImageWidget(
                                          imageUrl:
                                              "${_profileController.userData.value['photo_url']}",
                                          height: 40,
                                          width: 40,
                                          errorWidget: Image.asset(
                                            Constant.userPlaceHolder,
                                            fit: BoxFit.cover,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _profileController
                                                  .userData.value.isEmpty
                                              ? InkWell(
                                                  onTap: () {
                                                    Get.offAll(LoginScreen());
                                                  },
                                                  child: Text(
                                                    "Login".tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppThemeData.medium,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData.grey50
                                                          : AppThemeData
                                                              .grey900,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  "${_profileController.userData.value['first_name']} ${_profileController.userData.value['last_name']}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                          InkWell(
                                            onTap: () async {
                                              if (_profileController
                                                  .userData.value.isNotEmpty) {
                                                Get.to(AddressListScreen())!
                                                    .then(
                                                  (value) {
                                                    if (value != null) {
                                                      ShippingAddress
                                                          addressModel = value;
                                                      // Constant.selectedLocation =
                                                      //     addressModel;
                                                      controller.getData();
                                                    }
                                                  },
                                                );
                                              } else {
                                                Constant.checkPermission(
                                                    onTap: () async {
                                                      ShowToastDialog
                                                          .showLoader(
                                                              "Please wait".tr);
                                                      ShippingAddress
                                                          addressModel =
                                                          ShippingAddress();
                                                      try {
                                                        await Geolocator
                                                            .requestPermission();
                                                        await Geolocator
                                                            .getCurrentPosition();
                                                        ShowToastDialog
                                                            .closeLoader();
                                                        if (Constant
                                                                .selectedMapType ==
                                                            'osm') {
                                                          Get.to(() =>
                                                                  const LocationPicker())
                                                              ?.then((value) {
                                                            if (value != null) {
                                                              ShippingAddress
                                                                  addressModel =
                                                                  ShippingAddress();
                                                              addressModel
                                                                      .addressAs =
                                                                  "Home";
                                                              addressModel
                                                                      .locality =
                                                                  value
                                                                      .displayName!
                                                                      .toString();
                                                              addressModel
                                                                      .location =
                                                                  UserLocation(
                                                                      latitude:
                                                                          value
                                                                              .lat,
                                                                      longitude:
                                                                          value
                                                                              .lon);
                                                              // Constant.selectedLocation =
                                                              //     addressModel;
                                                              controller
                                                                  .getData();
                                                            }
                                                          });
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      PlacePicker(
                                                                apiKey: Constant
                                                                    .mapAPIKey,
                                                                onPlacePicked:
                                                                    (result) {
                                                                  // result.latLng.
                                                                  debugPrint(
                                                                      "Place picked: ${result.formattedAddress}");

                                                                  ShippingAddress
                                                                      addressModel =
                                                                      ShippingAddress();

                                                                  // controller
                                                                  //         .localityEditingController
                                                                  //         .value
                                                                  //         .text =
                                                                  //     result
                                                                  //         .formattedAddress!
                                                                  //         .toString();
                                                                  // controller
                                                                  //         .location
                                                                  //         .value =
                                                                  //     UserLocation(
                                                                  //   latitude: result
                                                                  //       .latLng
                                                                  //       ?.latitude,
                                                                  //   longitude: result
                                                                  //       .latLng
                                                                  //       ?.longitude,
                                                                  // );

                                                                  addressModel
                                                                          .addressAs =
                                                                      "Home";
                                                                  addressModel
                                                                          .locality =
                                                                      result
                                                                          .formattedAddress!
                                                                          .toString();
                                                                  addressModel
                                                                          .location =
                                                                      UserLocation(
                                                                    latitude: result
                                                                        .latLng
                                                                        ?.latitude,
                                                                    longitude: result
                                                                        .latLng
                                                                        ?.longitude,
                                                                  );
                                                                  // Constant.selectedLocation =
                                                                  //     addressModel;
                                                                  controller
                                                                      .getData();
                                                                  Get.back();
                                                                },
                                                                initialLocation:
                                                                    const LatLng(
                                                                  6.465422,
                                                                  3.406448,
                                                                ),
                                                                searchInputConfig:
                                                                    const SearchInputConfig(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        8.0,
                                                                  ),
                                                                  autofocus:
                                                                      false,
                                                                  textDirection:
                                                                      TextDirection
                                                                          .ltr,
                                                                ),
                                                                searchInputDecorationConfig:
                                                                    const SearchInputDecorationConfig(
                                                                  hintText:
                                                                      "Search for a building, street or ...",
                                                                ),
                                                                // useCurrentLocation: true,
                                                                // selectInitialPosition: true,
                                                                usePinPointingSearch:
                                                                    true,
                                                                // usePlaceDetailSearch: true,
                                                                // zoomGesturesEnabled: true,
                                                                // zoomControlsEnabled: true,
                                                                // resizeToAvoidBottomInset:
                                                                // false, // only works in page mode, less flickery, remove if wrong offsets
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      } catch (e) {
                                                        await placemarkFromCoordinates(
                                                                19.228825,
                                                                72.854118)
                                                            .then(
                                                                (valuePlaceMaker) {
                                                          Placemark placeMark =
                                                              valuePlaceMaker[
                                                                  0];
                                                          addressModel
                                                                  .addressAs =
                                                              "Home";
                                                          addressModel
                                                                  .location =
                                                              UserLocation(
                                                                  latitude:
                                                                      19.228825,
                                                                  longitude:
                                                                      72.854118);
                                                          String
                                                              currentLocation =
                                                              "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                                                          addressModel
                                                                  .locality =
                                                              currentLocation;
                                                        });

                                                        // Constant.selectedLocation =
                                                        //     addressModel;
                                                        ShowToastDialog
                                                            .closeLoader();
                                                        controller.getData();
                                                      }
                                                    },
                                                    context: context);
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  CupertinoIcons.location_solid,
                                                  color:
                                                      AppThemeData.primary400,
                                                  size: 14,
                                                ),
                                                Expanded(
                                                  child: Text.rich(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: _addressController
                                                              .shippingModel
                                                              .value
                                                              .getFullAddress(),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                AppThemeData
                                                                    .medium,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey50
                                                                : AppThemeData
                                                                    .grey900,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        WidgetSpan(
                                                          child: SvgPicture.asset(
                                                              "assets/icons/ic_down.svg"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 48,
                                    ),
                                    Obx(
                                      () => _cartController
                                              .cartData.value.isNotEmpty
                                          ? badges.Badge(
                                              showBadge: _cartController
                                                          .cartData
                                                          .value['totalItems'] >
                                                      0
                                                  ? true
                                                  : false,
                                              badgeContent: Text(
                                                "${_cartController.cartData.value['totalItems']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily:
                                                      AppThemeData.semiBold,
                                                  fontWeight: FontWeight.w600,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey50
                                                      : AppThemeData.grey50,
                                                ),
                                              ),
                                              badgeStyle: badges.BadgeStyle(
                                                shape: badges.BadgeShape.circle,
                                                badgeColor: themeChange
                                                        .getThem()
                                                    ? AppThemeData.primary400
                                                    : AppThemeData.secondary300,
                                              ),
                                              child: InkWell(
                                                  onTap: () async {
                                                    (await Get.to(
                                                        const CartScreen()));
                                                    controller.getCartData();
                                                  },
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .shopping_cart,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                  )),
                                            )
                                          : const SizedBox(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(const SearchScreen(), arguments: {
                                      "vendorList":
                                          controller.allNearestRestaurant
                                    });
                                  },
                                  child: TextFieldWidget(
                                    hintText:
                                        'Search restaurants, stores and products'
                                            .tr,
                                    controller: null,
                                    enable: false,
                                    prefix: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_search.svg",
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: BannerView(
                                      controller: controller,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: CategoriesView(
                                      controller: controller,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const NearbyVendorView(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        OfferView(controller: controller),
                                      ],
                                    ),
                                  ),
                                  controller.allNearestRestaurant.isEmpty
                                      ? const SizedBox()
                                      : const Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            VendorView(),
                                          ],
                                        ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const VendorView(),
                                  // controller.storyList.isEmpty ||
                                  //         Constant.storyEnable == false
                                  //     ? const SizedBox()
                                  //     : Padding(
                                  //         padding: const EdgeInsets.symmetric(
                                  //             horizontal: 16),
                                  //         child: Column(
                                  //           children: [
                                  //             const SizedBox(
                                  //               height: 20,
                                  //             ),
                                  //             StoryView(controller: controller),
                                  //           ],
                                  //         ),
                                  //       ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
          // floatingActionButton: Container(
          //   decoration: BoxDecoration(
          //     color: themeChange.getThem()
          //         ? AppThemeData.grey800
          //         : AppThemeData.grey100,
          //     borderRadius: const BorderRadius.all(
          //       Radius.circular(30),
          //     ),
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Container(
          //           decoration: BoxDecoration(
          //             color: themeChange.getThem()
          //                 ? AppThemeData.grey900
          //                 : AppThemeData.grey50,
          //             borderRadius: const BorderRadius.all(
          //               Radius.circular(30),
          //             ),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 10, vertical: 5),
          //             child: Row(
          //               children: [
          //                 InkWell(
          //                   onTap: () {
          //                     controller.isListView.value = true;
          //                   },
          //                   child: ClipOval(
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                           color: controller.isListView.value
          //                               ? AppThemeData.primary300
          //                               : null),
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: SvgPicture.asset(
          //                           "assets/icons/ic_view_grid_list.svg",
          //                           colorFilter: ColorFilter.mode(
          //                             controller.isListView.value
          //                                 ? AppThemeData.grey50
          //                                 : AppThemeData.grey500,
          //                             BlendMode.srcIn,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 const SizedBox(
          //                   width: 10,
          //                 ),
          //                 InkWell(
          //                   onTap: () {
          //                     controller.isListView.value = false;
          //                   },
          //                   child: ClipOval(
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                         color: controller.isListView.value == false
          //                             ? AppThemeData.primary300
          //                             : null,
          //                       ),
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: SvgPicture.asset(
          //                           "assets/icons/ic_map_draw.svg",
          //                           colorFilter: ColorFilter.mode(
          //                             controller.isListView.value == false
          //                                 ? AppThemeData.grey50
          //                                 : AppThemeData.grey500,
          //                             BlendMode.srcIn,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         const SizedBox(
          //           width: 10,
          //         ),
          //         InkWell(
          //           onTap: () {
          //             Get.to(const ScanQrCodeScreen());
          //           },
          //           child: ClipOval(
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 color: themeChange.getThem()
          //                     ? AppThemeData.grey900
          //                     : AppThemeData.grey50,
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(10),
          //                 child: SvgPicture.asset(
          //                   "assets/icons/ic_scan_code.svg",
          //                   colorFilter: ColorFilter.mode(
          //                     themeChange.getThem()
          //                         ? AppThemeData.grey400
          //                         : AppThemeData.grey500,
          //                     BlendMode.srcIn,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         const SizedBox(
          //           width: 14,
          //         ),
          //         DropdownButton<String>(
          //           isDense: false,
          //           underline: const SizedBox(),
          //           value: controller.selectedOrderTypeValue.value.tr,
          //           icon: const Icon(Icons.keyboard_arrow_down),
          //           items: <String>['Delivery'.tr, 'Pickup'.tr]
          //               .map((String value) {
          //             return DropdownMenuItem<String>(
          //               value: value,
          //               child: Text(
          //                 value,
          //                 style: TextStyle(
          //                   fontFamily: AppThemeData.semiBold,
          //                   fontSize: 16,
          //                   color: themeChange.getThem()
          //                       ? AppThemeData.grey50
          //                       : AppThemeData.grey900,
          //                 ),
          //               ),
          //             );
          //           }).toList(),
          //           onChanged: (value) async {
          //             if (cartItem.isEmpty) {
          //               await Preferences.setString(
          //                   Preferences.foodDeliveryType, value!);
          //               controller.selectedOrderTypeValue.value = value;
          //               controller.getData();
          //             } else {
          //               showDialog(
          //                   context: context,
          //                   builder: (BuildContext context) {
          //                     return CustomDialogBox(
          //                       title: "Alert".tr,
          //                       descriptions:
          //                           "Do you really want to change the delivery option? Your cart will be empty."
          //                               .tr,
          //                       positiveString: "Ok".tr,
          //                       negativeString: "Cancel".tr,
          //                       positiveClick: () async {
          //                         await Preferences.setString(
          //                             Preferences.foodDeliveryType, value!);
          //                         controller.selectedOrderTypeValue.value =
          //                             value;
          //                         controller.getData();
          //                         DatabaseHelper.instance
          //                             .deleteAllCartProducts();
          //                         controller.cartProvider.clearDatabase();
          //                         controller.getCartData();
          //                         Get.back();
          //                       },
          //                       negativeClick: () {
          //                         Get.back();
          //                       },
          //                       img: null,
          //                     );
          //                   });
          //             }
          //           },
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}

class StoryView extends StatelessWidget {
  final HomeController controller;

  const StoryView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      height: Responsive.height(32, context),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          image: AssetImage("assets/images/story_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Stories",
                        style: TextStyle(
                          fontFamily: AppThemeData.semiBold,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey50,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
                const GradientText(
                  'Best Stories Ever',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Inter Tight',
                    fontWeight: FontWeight.w800,
                  ),
                  gradient: LinearGradient(colors: [
                    Color(0xFFF1C839),
                    Color(0xFFEA1111),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
