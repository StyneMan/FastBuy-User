import 'dart:convert';

import 'package:customer/app/address_screens/address_list_screen.dart';
import 'package:customer/app/dash_board_screens/dash_board_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/dash_board_controller.dart';
import 'package:customer/controllers/location_permission_controller.dart';
import 'package:customer/controllers/vendors_controller.dart';
import 'package:customer/models/user_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:customer/widget/place_picker_osm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:provider/provider.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: LocationPermissionController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            height: Responsive.height(100, context),
            width: Responsive.width(100, context),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/location_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Enable Location Services 📍".tr,
                    style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey900
                            : AppThemeData.secondary300,
                        fontSize: 22,
                        fontFamily: AppThemeData.semiBold),
                  ),
                  Text(
                    "To provide the best shopping experience, allow FastBuy to access your location."
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey900
                            : AppThemeData.grey900,
                        fontSize: 16,
                        fontFamily: AppThemeData.bold),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  RoundedButtonFill(
                    title: "Use Current Location".tr,
                    color: AppThemeData.primary300,
                    textColor: AppThemeData.grey50,
                    onPress: () async {
                      final addressCoontroller =
                          Get.put(AddressListController());

                      final dashboardController =
                          Get.put(DashBoardController());
                      Constant.checkPermission(
                        context: context,
                        onTap: () async {
                          ShowToastDialog.showLoader("Please wait".tr);
                          ShippingAddress addressModel = ShippingAddress();
                          try {
                            await Geolocator.requestPermission();

                            Position newLocalData =
                                await Geolocator.getCurrentPosition(
                              locationSettings: const LocationSettings(
                                accuracy: LocationAccuracy.high,
                              ),
                            );

                            debugPrint(
                                "CURRENT LOCATION PICKED LAT ::: ${newLocalData.latitude}");
                            debugPrint(
                                "CURRENT LOCATION PICKED LNG ::: ${newLocalData.longitude}");

                            // Position newLocalData =
                            //     await Geolocator.getCurrentPosition(
                            //         desiredAccuracy: LocationAccuracy.high);

                            await placemarkFromCoordinates(
                                    newLocalData.latitude,
                                    newLocalData.longitude)
                                .then((valuePlaceMaker) {
                              Placemark placeMark = valuePlaceMaker[0];
                              addressModel.addressAs = "Home";
                              addressModel.location = UserLocation(
                                latitude: newLocalData.latitude,
                                longitude: newLocalData.longitude,
                              );
                              String currentLocation =
                                  "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                              addressModel.locality = currentLocation;

                              debugPrint("CURRANT LOCATE >> $currentLocation");

                              addressModel.address =
                                  "${placeMark.name}, ${placeMark.subLocality}, ";
                              addressModel.addressAs = "Home";
                              addressModel.isDefault = true;
                              addressModel.locality = "${placeMark.locality}";
                              addressModel.landmark =
                                  "${placeMark.subAdministrativeArea}";
                              addressModel.location = UserLocation(
                                latitude: newLocalData.latitude,
                                longitude: newLocalData.longitude,
                              );

                              Map mp = {
                                "address":
                                    "${placeMark.name} ${placeMark.subLocality}",
                                "landmark":
                                    "${placeMark.subAdministrativeArea}",
                                "locality": "${placeMark.locality}",
                                "addressAs": "Home",
                                "isDefault": false,
                                "id": "1",
                              };

                              Preferences.setString(
                                Preferences.shippingAddress,
                                jsonEncode(mp),
                              );

                              Preferences.setString(
                                  Preferences.currAddress, "${placeMark.name}");
                            });
                            addressCoontroller.location.value = UserLocation(
                              latitude: newLocalData.latitude,
                              longitude: newLocalData.longitude,
                            );

                            Preferences.setString(Preferences.currLatitude,
                                "${newLocalData.latitude}");
                            Preferences.setString(Preferences.currLongitude,
                                "${newLocalData.longitude}");

                            // Now fetch nearest vendors here
                            getNearestVendors(
                              addressController: addressCoontroller,
                              vendorController:
                                  dashboardController.vendorController,
                            );

                            ShowToastDialog.closeLoader();
                            dashboardController.selectedIndex.value = 0;
                            Get.to(const DashBoardScreen());
                          } catch (e) {
                            // await placemarkFromCoordinates(19.228825, 72.854118)
                            //     .then((valuePlaceMaker) {
                            //   Placemark placeMark = valuePlaceMaker[0];
                            //   addressModel.addressAs = "Home";
                            //   addressModel.location = UserLocation(
                            //       latitude: 19.228825, longitude: 72.854118);
                            //   String currentLocation =
                            //       "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                            //   addressModel.locality = currentLocation;
                            // });

                            // Constant.selectedLocation = addressModel;
                            ShowToastDialog.closeLoader();

                            Get.offAll(const DashBoardScreen());
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedButtonFill(
                    title: "Set From Map".tr,
                    color: AppThemeData.primary300,
                    textColor: AppThemeData.grey50,
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        "assets/icons/ic_location_pin.svg",
                        colorFilter: const ColorFilter.mode(
                            AppThemeData.grey50, BlendMode.srcIn),
                      ),
                    ),
                    isRight: false,
                    onPress: () async {
                      final addressCoontroller =
                          Get.put(AddressListController());

                      final dashboardController =
                          Get.put(DashBoardController());
                      Constant.checkPermission(
                        context: context,
                        onTap: () async {
                          ShowToastDialog.showLoader("Please wait".tr);
                          ShippingAddress addressModel = ShippingAddress();
                          try {
                            await Geolocator.requestPermission();
                            // await Geolocator.getCurrentPosition(
                            //     desiredAccuracy: LocationAccuracy.high);
                            ShowToastDialog.closeLoader();
                            if (Constant.selectedMapType == 'osm') {
                              Get.to(() => const LocationPicker())
                                  ?.then((value) {
                                if (value != null) {
                                  // ShippingAddress addressModel =
                                  //     ShippingAddress();
                                  // addressModel.addressAs = "Home";
                                  // addressModel.locality =
                                  //     value.displayName!.toString();
                                  // addressModel.location = UserLocation(
                                  //     latitude: value.lat,
                                  //     longitude: value.lon);
                                  // Constant.selectedLocation = addressModel;
                                  Get.offAll(const DashBoardScreen());
                                }
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    apiKey: Constant.mapAPIKey,
                                    onPlacePicked: (result) {
                                      debugPrint(
                                          "Place picked: ${result.formattedAddress}");

                                      addressCoontroller.location.value =
                                          UserLocation(
                                        latitude: result.latLng?.latitude,
                                        longitude: result.latLng?.longitude,
                                      );
                                      addressCoontroller.shippingModel.value =
                                          ShippingAddress(
                                        address: "${result.formattedAddress}",
                                        addressAs: "Home",
                                        isDefault: true,
                                        landmark: "${result.name}",
                                        locality:
                                            "${result.locality?.longName}",
                                        location: UserLocation(
                                          latitude: result.latLng?.latitude,
                                          longitude: result.latLng?.longitude,
                                        ),
                                      );

                                      Map mp = {
                                        "address": "${result.formattedAddress}",
                                        "landmark": "${result.name}",
                                        "locality":
                                            "${result.locality?.longName}",
                                        "addressAs": "Home",
                                        "isDefault": true,
                                        "id": "1",
                                      };

                                      Preferences.setString(
                                        Preferences.shippingAddress,
                                        jsonEncode(mp),
                                      );

                                      addressModel.addressAs = "Home";
                                      addressModel.locality =
                                          result.formattedAddress!.toString();
                                      addressModel.location = UserLocation(
                                        latitude: result.latLng?.latitude,
                                        longitude: result.latLng?.longitude,
                                      );
                                      Preferences.setString(
                                          Preferences.currLatitude,
                                          "${result.latLng?.latitude}");
                                      Preferences.setString(
                                          Preferences.currLongitude,
                                          "${result.latLng?.longitude}");

                                      // Now fetch nearest vendors here
                                      getNearestVendors(
                                        addressController: addressCoontroller,
                                        vendorController: dashboardController
                                            .vendorController,
                                      );
                                      ShowToastDialog.closeLoader();

                                      dashboardController.selectedIndex.value =
                                          0;
                                      Get.to(const DashBoardScreen());
                                    },
                                    initialLocation: const LatLng(
                                      6.465422,
                                      3.406448,
                                    ),
                                    searchInputConfig: const SearchInputConfig(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8.0,
                                      ),
                                      autofocus: false,
                                      textDirection: TextDirection.ltr,
                                    ),
                                    searchInputDecorationConfig:
                                        const SearchInputDecorationConfig(
                                      hintText:
                                          "Search for a building, street or ...",
                                    ),
                                    // useCurrentLocation: true,
                                    // selectInitialPosition: true,
                                    usePinPointingSearch: true,
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
                            // await placemarkFromCoordinates(19.228825, 72.854118)
                            //     .then((valuePlaceMaker) {
                            //   Placemark placeMark = valuePlaceMaker[0];
                            //   addressModel.addressAs = "Home";
                            //   addressModel.location = UserLocation(
                            //       latitude: 19.228825, longitude: 72.854118);
                            //   String currentLocation =
                            //       "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                            //   addressModel.locality = currentLocation;
                            // });

                            // Constant.selectedLocation = addressModel;
                            ShowToastDialog.closeLoader();

                            Get.offAll(const DashBoardScreen());
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Constant.userModel == null
                      ? const SizedBox()
                      : RoundedButtonFill(
                          title: "Enter Manually location".tr,
                          color: AppThemeData.primary300,
                          textColor: AppThemeData.grey50,
                          isRight: false,
                          onPress: () async {
                            Get.to(AddressListScreen())!.then(
                              (value) {
                                if (value != null) {
                                  // ShippingAddress addressModel = value;
                                  // Constant.selectedLocation = addressModel;
                                  Get.offAll(const DashBoardScreen());
                                }
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
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
}
