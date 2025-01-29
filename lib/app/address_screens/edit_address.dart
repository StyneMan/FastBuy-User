import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/models/user_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:provider/provider.dart';

class EditAddress extends StatefulWidget {
  final AddressListController controller;
  final int index;
  const EditAddress({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    try {
      widget.controller.houseBuildingTextEditingController.value.text = widget
          .controller.shippingAddresses.value['data'][widget.index]['street'];
      widget.controller.localityEditingController.value.text = widget
          .controller.shippingAddresses.value['data'][widget.index]['locality'];
      widget.controller.landmarkEditingController.value.text = widget
          .controller.shippingAddresses.value['data'][widget.index]['landmark'];
      widget.controller.selectedSaveAs.value =
          "${widget.controller.shippingAddresses.value['data'][widget.index]['address_as']}"
              .capitalize!;
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Obx(
      () => Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Container(
                      width: 134,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: ShapeDecoration(
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: Constant.mapAPIKey,
                            onPlacePicked: (result) {
                              // result.latLng.
                              debugPrint(
                                  "Place picked: ${result.formattedAddress}");
                              widget.controller.localityEditingController.value
                                  .text = result.formattedAddress!.toString();
                              widget.controller.location.value = UserLocation(
                                latitude: result.latLng?.latitude,
                                longitude: result.latLng?.longitude,
                              );
                              Get.back();
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
                              hintText: "Search for a building, street or ...",
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
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_focus.svg",
                          color: themeChange.getThem()
                              ? AppThemeData.primary300
                              : AppThemeData.secondary300,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Choose Current Location".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: themeChange.getThem()
                                ? AppThemeData.primary300
                                : AppThemeData.secondary300,
                            fontFamily: AppThemeData.medium,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Save as'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: AppThemeData.semiBold,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 34,
                        child: ListView.builder(
                          itemCount: widget.controller.saveAsList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  widget.controller.selectedSaveAs.value =
                                      widget.controller.saveAsList[index]
                                          .toString();
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: widget.controller.selectedSaveAs
                                                .value ==
                                            widget.controller.saveAsList[index]
                                                .toString()
                                        ? AppThemeData.primary300
                                        : themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          widget.controller.saveAsList[index] ==
                                                  "Home".tr
                                              ? "assets/icons/ic_home_add.svg"
                                              : widget.controller
                                                          .saveAsList[index] ==
                                                      "Work".tr
                                                  ? "assets/icons/ic_work.svg"
                                                  : widget.controller
                                                                  .saveAsList[
                                                              index] ==
                                                          "Hotel".tr
                                                      ? "assets/icons/ic_building.svg"
                                                      : "assets/icons/ic_location.svg",
                                          width: 18,
                                          height: 18,
                                          colorFilter: ColorFilter.mode(
                                              widget.controller.selectedSaveAs
                                                          .value ==
                                                      widget.controller
                                                          .saveAsList[index]
                                                          .toString()
                                                  ? AppThemeData.grey50
                                                  : themeChange.getThem()
                                                      ? AppThemeData.grey700
                                                      : AppThemeData.grey300,
                                              BlendMode.srcIn),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.controller.saveAsList[index]
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppThemeData.medium,
                                            color: widget.controller
                                                        .selectedSaveAs.value ==
                                                    widget.controller
                                                        .saveAsList[index]
                                                        .toString()
                                                ? AppThemeData.grey50
                                                : themeChange.getThem()
                                                    ? AppThemeData.grey700
                                                    : AppThemeData.grey300,
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        title: 'House/Flat/Floor No.'.tr,
                        controller: widget.controller
                            .houseBuildingTextEditingController.value,
                        hintText: 'House/Flat/Floor No.'.tr,
                      ),
                      TextFieldWidget(
                        title: 'Apartment/Road/Area'.tr,
                        controller:
                            widget.controller.localityEditingController.value,
                        hintText: 'Apartment/Road/Area'.tr,
                      ),
                      TextFieldWidget(
                        title: 'Nearby landmark'.tr,
                        controller:
                            widget.controller.landmarkEditingController.value,
                        hintText: 'Nearby landmark (Optional)'.tr,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: themeChange.getThem()
              ? AppThemeData.grey800
              : AppThemeData.grey100,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: RoundedButtonFill(
              title: "Save Changes".tr,
              height: 5.5,
              color: AppThemeData.primary300,
              fontSizes: 16,
              onPress: () async {
                if (widget.controller.location.value.latitude == null ||
                    widget.controller.location.value.longitude == null) {
                  ShowToastDialog.showToast("Please select Location".tr);
                }
                if (formKey.currentState!.validate()) {
                  updateAddress(controller: widget.controller);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  updateAddress({required AddressListController controller}) async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      Map body = {
        "landmark": controller.landmarkEditingController.value.text,
        "locality": controller.localityEditingController.value.text,
        "street": controller.houseBuildingTextEditingController.value.text,
        "addressAs": controller.selectedSaveAs.value.toString().toLowerCase(),
        "latitude": controller.location.value.latitude ?? 0.0,
        "longitude": controller.location.value.longitude ?? 0.0,
      };

      final token = Preferences.getString(Preferences.accessTokenKey);

      var resp = await APIService().updateShippingAddress(
        accessToken: token,
        body: body,
        addressId: widget.controller.shippingAddresses.value['data']
            [widget.index]['id'],
      );
      debugPrint(resp.body);
      ShowToastDialog.closeLoader();
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        // all good here
        Map<String, dynamic> map = jsonDecode(resp.body);
        controller.refreshShipping();
        Constant.toast(map['message']);
        Get.back();

        // Update address here
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
