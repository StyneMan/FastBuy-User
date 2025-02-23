import 'dart:convert';

import 'package:customer/app/address_screens/add_address.dart';
import 'package:customer/app/address_screens/edit_address.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/vendors_controller.dart';
import 'package:customer/models/user_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatelessWidget {
  final String? receiver;
  AddressListScreen({
    super.key,
    this.receiver,
  });

  final _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddressListController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              titleSpacing: 0,
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.surfaceDark
                  : AppThemeData.surface,
              title: Text(
                "Add Address",
                style: TextStyle(
                  fontSize: 16,
                  color: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey900,
                  fontFamily: AppThemeData.medium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      ShowToastDialog.showLoader("Please wait".tr);
                      // ShippingAddress addressModel = ShippingAddress();
                      try {
                        await Geolocator.requestPermission();
                        final hasPermission = await _handlePermission();

                        if (!hasPermission) {
                          return;
                        }

                        final newLocalData =
                            await _geolocatorPlatform.getCurrentPosition();
                        // _updatePositionList(
                        //   _PositionItemType.position,
                        //   position.toString(),
                        // );
                        // position.

                        // Position newLocalData =
                        //     await Geolocator.getCurrentPosition(
                        //         desiredAccuracy: LocationAccuracy.high);

                        await placemarkFromCoordinates(
                                newLocalData.latitude, newLocalData.longitude)
                            .then((valuePlaceMaker) {
                          Placemark placeMark = valuePlaceMaker[0];
                          // addressModel.addressAs = "Home".tr;
                          // addressModel.location = UserLocation(
                          //     latitude: newLocalData.latitude,
                          //     longitude: newLocalData.longitude);

                          String currentLocation =
                              "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                          debugPrint("CURR LOCATION ::: $currentLocation");
                          // addressModel.locality = currentLocation;
                        });

                        ShowToastDialog.closeLoader();
                        Get.back();
                        // Get.back(result: addressModel);
                      } catch (e) {
                        // await placemarkFromCoordinates(19.228825, 72.854118)
                        //     .then((valuePlaceMaker) {
                        //   Placemark placeMark = valuePlaceMaker[0];
                        //   addressModel.addressAs = "Home".tr;
                        //   addressModel.location = UserLocation(
                        //       latitude: 19.228825, longitude: 72.854118);
                        //   String currentLocation =
                        //       "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                        //   addressModel.locality = currentLocation;
                        // });
                        // ShowToastDialog.closeLoader();

                        // Get.back(result: addressModel);
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/ic_send_one.svg"),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Use my current location".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: themeChange.getThem()
                                ? AppThemeData.primary300
                                : AppThemeData.primary300,
                            fontFamily: AppThemeData.medium,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {
                      // controller.clearData();
                      addAddressBottomSheet(context, controller);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/ic_plus.svg"),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Add Location".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: themeChange.getThem()
                                ? AppThemeData.primary300
                                : AppThemeData.primary300,
                            fontFamily: AppThemeData.medium,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Saved Addresses".tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: themeChange.getThem()
                          ? AppThemeData.grey50
                          : AppThemeData.grey900,
                      fontFamily: AppThemeData.semiBold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: controller.shippingAddresses.value['data'].isEmpty
                        ? Constant.showEmptyView(
                            message: "Saved addresses not found".tr)
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: controller
                                .shippingAddresses.value['data'].length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 16.0,
                            ),
                            itemBuilder: (context, index) {
                              // ShippingAddress shippingAddress =
                              //     controller.shippingAddressList[index];
                              final item = controller
                                  .shippingAddresses.value['data'][index];
                              return InkWell(
                                onTap: () {
                                  final vendorController =
                                      Get.find<VendorsController>();
                                  if (receiver != null &&
                                      receiver!.isNotEmpty) {
                                    controller.location2.value.latitude =
                                        double.parse("${item['latitude']}");
                                    controller.location2.value.longitude =
                                        double.parse("${item['longitude']}");

                                    controller.receivingModel.value =
                                        ShippingAddress(
                                      locality: item['locality'],
                                      address: item['street'],
                                      addressAs: item['address_as'],
                                      location: UserLocation(
                                        latitude:
                                            double.parse("${item['latitude']}"),
                                        longitude: double.parse(
                                            "${item['longitude']}"),
                                      ),
                                    );

                                    Get.back();
                                  } else {
                                    controller.location.value.latitude =
                                        double.parse("${item['latitude']}");
                                    controller.location.value.longitude =
                                        double.parse("${item['longitude']}");

                                    controller.shippingModel.value =
                                        ShippingAddress(
                                      locality: item['locality'],
                                      address: item['street'],
                                      addressAs: item['address_as'],
                                      location: UserLocation(
                                        latitude:
                                            double.parse("${item['latitude']}"),
                                        longitude: double.parse(
                                            "${item['longitude']}"),
                                      ),
                                    );

                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      getNearestVendors(
                                        addressController: controller,
                                        vendorController: vendorController,
                                      );
                                    });

                                    Get.back();
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                    decoration: ShapeDecoration(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey900
                                          : AppThemeData.grey50,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/ic_send_one.svg",
                                                colorFilter: ColorFilter.mode(
                                                    themeChange.getThem()
                                                        ? AppThemeData.grey100
                                                        : AppThemeData.grey800,
                                                    BlendMode.srcIn),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${item['address_as']}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey100
                                                            : AppThemeData
                                                                .grey800,
                                                        fontFamily: AppThemeData
                                                            .semiBold,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    item['is_default'] == false
                                                        ? const SizedBox()
                                                        : Container(
                                                            decoration:
                                                                ShapeDecoration(
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData
                                                                      .primary50
                                                                  : AppThemeData
                                                                      .primary50,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4)),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          5),
                                                              child: Text(
                                                                "Default".tr,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: themeChange.getThem()
                                                                      ? AppThemeData
                                                                          .primary300
                                                                      : AppThemeData
                                                                          .primary300,
                                                                  fontFamily:
                                                                      AppThemeData
                                                                          .semiBold,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showActionSheet(context,
                                                      index, controller);
                                                },
                                                child: SvgPicture.asset(
                                                    "assets/icons/ic_more_one.svg"),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${item['locality']}",
                                            style: TextStyle(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey400
                                                  : AppThemeData.grey500,
                                              fontFamily: AppThemeData.regular,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kLocationServicesDisabledMessage,
      // );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // _updatePositionList(
        //   _PositionItemType.log,
        //   _kPermissionDeniedMessage,
        // );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kPermissionDeniedForeverMessage,
      // );

      return false;
    }

    // // When we reach here, permissions are granted and we can
    // // continue accessing the position of the device.
    // _updatePositionList(
    //   _PositionItemType.log,
    //   _kPermissionGrantedMessage,
    // );
    return true;
  }

  void showActionSheet(
      BuildContext context, int index, AddressListController controller) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              setDefaultAddress(
                controller: controller,
                addressId: controller.shippingAddresses.value['data'][index]
                    ['id'],
              );
            },
            child:
                Text('Default'.tr, style: const TextStyle(color: Colors.blue)),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Get.back();
              // controller.clearData();
              // controller.setData(controller.shippingAddressList[index]);
              editAddressBottomSheet(context, controller, index);
            },
            child: const Text('Edit', style: TextStyle(color: Colors.blue)),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              deleteAddress(
                controller: controller,
                addressId: controller.shippingAddresses.value['data'][index]
                    ['id'],
              );
            },
            child: Text('Delete'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'.tr),
        ),
      ),
    );
  }

  addAddressBottomSheet(
    BuildContext context,
    AddressListController controller,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.75,
        child: AddAddress(controller: controller),
      ),
    );
  }

  editAddressBottomSheet(
      BuildContext context, AddressListController controller, int index) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.6,
        child: EditAddress(
          controller: controller,
          index: index,
        ),
      ),
    );
  }

  getNearestVendors(
      {required AddressListController addressController,
      required VendorsController vendorController}) async {
    if (addressController.location.value.latitude != null &&
        addressController.location.value.longitude != null) {
      Map payload = {
        "lat": addressController.location.value.latitude,
        "lng": addressController.location.value.longitude,
      };

      final nearbys = await APIService().getNearbyVendors(
        page: 1,
        payload: payload,
      );
      debugPrint("NEARBY VENDORS :::: ${nearbys.body}");
      if (nearbys.statusCode >= 200 && nearbys.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(nearbys.body);
        vendorController.nearbyVendors.value = map;
      }
    }
  }

  setDefaultAddress(
      {required AddressListController controller,
      required String addressId}) async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final token = Preferences.getString(Preferences.accessTokenKey);

      var resp = await APIService().setDefaultShippingAddress(
        accessToken: token,
        addressId: addressId,
      );
      debugPrint(resp.body);
      ShowToastDialog.closeLoader();
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        // all good here
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast("Sucessfully marked as default");
        controller.refreshShipping();
        Get.back();
      } else {
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        Constant.toast(errorMap['message']);
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint(e.toString());
    }
  }

  deleteAddress(
      {required AddressListController controller,
      required String addressId}) async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final token = Preferences.getString(Preferences.accessTokenKey);

      var resp = await APIService().deleteShippingAddress(
        accessToken: token,
        addressId: addressId,
      );
      debugPrint(resp.body);
      ShowToastDialog.closeLoader();
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        // all good here
        Map<String, dynamic> map = jsonDecode(resp.body);
        Constant.toast("Sucessfully deleted address");
        controller.refreshShipping();
        Get.back();
      } else {
        Map<String, dynamic> errorMap = jsonDecode(resp.body);
        Constant.toast(errorMap['message']);
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint(e.toString());
    }
  }
}
