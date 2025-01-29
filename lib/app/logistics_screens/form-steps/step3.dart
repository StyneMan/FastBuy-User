import 'dart:io';

import 'package:customer/app/checkout_screens/rider_note_dialog.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/logistics_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/themes/select_field_widget.dart';
import 'package:customer/themes/text_field_widget.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PackageForm extends StatelessWidget {
  final LogisticsController controller;
  const PackageForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Obx(
      () => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        children: [
          controller.addedPackages.value.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return packageCard(
                          context,
                          themeChange,
                          index,
                          controller.addedPackages.value[index],
                        );
                      },
                      itemCount: controller.addedPackages.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    controller.shouldAddMorePackage.value
                        ? RoundedButtonFill(
                            title: "Add another package".tr,
                            color: AppThemeData.primary300,
                            textColor: AppThemeData.grey50,
                            onPress: () {
                              controller.shouldAddMorePackage.value = false;
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Package Name".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.regular,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextFieldWidget(
                                hintText: "Enter package name",
                                controller: controller
                                    .packageNameEditingController.value,
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "Package name is required";
                                  }
                                  return null;
                                },
                                prefix: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_user.svg",
                                    colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.grey300
                                          : AppThemeData.grey600,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                "Package Weight".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.regular,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextFieldWidget(
                                hintText: "Enter package weight",
                                controller:
                                    controller.weightEditingController.value,
                                textInputType:
                                    const TextInputType.numberWithOptions(
                                  signed: true,
                                  decimal: true,
                                ),
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$')),
                                ],
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "Weight is required";
                                  }
                                  return null;
                                },
                                prefix: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_map_draw.svg",
                                    colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.grey300
                                          : AppThemeData.grey600,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                suffix: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    "kg".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                      fontFamily: AppThemeData.regular,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                "Package Dimension".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.regular,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextFieldWidget(
                                hintText: "Enter package dimension",
                                controller:
                                    controller.dimensionEditingController.value,
                                textInputType:
                                    const TextInputType.numberWithOptions(
                                  signed: true,
                                  decimal: true,
                                ),
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$')),
                                ],
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "Dimension is required";
                                  }
                                  return null;
                                },
                                prefix: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_scan_code.svg",
                                    colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.grey300
                                          : AppThemeData.grey600,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                suffix: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    "cm".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                      fontFamily: AppThemeData.regular,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Images".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                      fontFamily: AppThemeData.regular,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      buildBottomSheet(context, controller);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        controller.images.value.isEmpty
                                            ? "Add Image".tr
                                            : "Add More".tr,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.primary300
                                              : AppThemeData.primary300,
                                          fontSize: 13,
                                          fontFamily: AppThemeData.semiBold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 6 / 6,
                                  crossAxisSpacing: 4.0,
                                ),
                                itemCount: controller.images.value.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => imageCard(
                                    controller.images.value[index], index),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              RoundedButtonFill(
                                title: "Save Package".tr,
                                color: AppThemeData.primary300,
                                textColor: AppThemeData.grey50,
                                onPress: () async {
                                  if (controller.images.isEmpty) {
                                    Constant.toast("No image added");
                                  } else if (controller.weightEditingController
                                          .value.text.isEmpty ||
                                      controller.dimensionEditingController
                                          .value.text.isEmpty ||
                                      controller.packageNameEditingController
                                          .value.text.isEmpty) {
                                    Constant.toast(
                                        "Some input fields not filled");
                                  } else {
                                    Map payload = {
                                      "weight": controller
                                          .weightEditingController.value.text,
                                      "quantity": 1,
                                      "name": controller
                                          .packageNameEditingController
                                          .value
                                          .text,
                                      "dimen": controller
                                          .dimensionEditingController
                                          .value
                                          .text,
                                      "images": controller.images.value,
                                    };

                                    debugPrint("PAYLOADD ::: $payload");
                                    controller.savePackage(payload);
                                  }
                                },
                              ),
                            ],
                          ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Package Name".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextFieldWidget(
                      hintText: "Enter package name",
                      controller: controller.packageNameEditingController.value,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Package name is required";
                        }
                        return null;
                      },
                      prefix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          "assets/icons/ic_user.svg",
                          colorFilter: ColorFilter.mode(
                            themeChange.getThem()
                                ? AppThemeData.grey300
                                : AppThemeData.grey600,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Package Weight".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextFieldWidget(
                      hintText: "Enter package weight",
                      controller: controller.weightEditingController.value,
                      textInputType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$')),
                      ],
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Weight is required";
                        }
                        return null;
                      },
                      prefix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          "assets/icons/ic_map_draw.svg",
                          colorFilter: ColorFilter.mode(
                            themeChange.getThem()
                                ? AppThemeData.grey300
                                : AppThemeData.grey600,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      suffix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "kg".tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontFamily: AppThemeData.regular,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Package Dimension".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextFieldWidget(
                      hintText: "Enter package dimension",
                      controller: controller.dimensionEditingController.value,
                      textInputType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$')),
                      ],
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Dimension is required";
                        }
                        return null;
                      },
                      prefix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          "assets/icons/ic_scan_code.svg",
                          colorFilter: ColorFilter.mode(
                            themeChange.getThem()
                                ? AppThemeData.grey300
                                : AppThemeData.grey600,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      suffix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "cm".tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontFamily: AppThemeData.regular,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Images".tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            fontFamily: AppThemeData.regular,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            buildBottomSheet(context, controller);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              controller.images.value.isEmpty
                                  ? "Add Image".tr
                                  : "Add More".tr,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.primary300
                                    : AppThemeData.primary300,
                                fontSize: 13,
                                fontFamily: AppThemeData.semiBold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 6 / 6,
                        crossAxisSpacing: 4.0,
                      ),
                      itemCount: controller.images.value.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          imageCard(controller.images.value[index], index),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    RoundedButtonFill(
                      title: "Save Package".tr,
                      color: AppThemeData.primary300,
                      textColor: AppThemeData.grey50,
                      onPress: () async {
                        if (controller.images.isEmpty) {
                          Constant.toast("No image added");
                        } else if (controller
                                .weightEditingController.value.text.isEmpty ||
                            controller.dimensionEditingController.value.text
                                .isEmpty ||
                            controller.packageNameEditingController.value.text
                                .isEmpty) {
                          Constant.toast("Some input fields not filled");
                        } else {
                          Map payload = {
                            "weight":
                                controller.weightEditingController.value.text,
                            "quantity": 1,
                            "name": controller
                                .packageNameEditingController.value.text,
                            "dimen": controller
                                .dimensionEditingController.value.text,
                            "images": controller.images.value,
                          };

                          debugPrint("PAYLOADD ::: $payload");
                          controller.savePackage(payload);
                        }
                      },
                    ),
                  ],
                ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            "Shipping".tr,
            style: TextStyle(
              fontSize: 14,
              color: themeChange.getThem()
                  ? AppThemeData.grey50
                  : AppThemeData.grey900,
              fontFamily: AppThemeData.regular,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          SelectFieldWidget(
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Shipping type is required";
              }
              return null;
            },
            items: const ["Regular", "Cargo", "Express"],
            hintText: "Select shipping",
            controller: controller.shippingEditingController.value,
            onSelected: (e) {
              controller.selectedShipping.value = "$e".toLowerCase();
              controller.shippingEditingController.value.text = e;
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: Responsive.width(100, context),
            padding: const EdgeInsets.all(16.0),
            decoration: ShapeDecoration(
              color: themeChange.getThem()
                  ? AppThemeData.grey900
                  : AppThemeData.grey50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rider Note".tr,
                  style: TextStyle(
                    fontSize: 17,
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontFamily: AppThemeData.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RiderNoteDialog(
                          isParcel: true,
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.storefront),
                          const SizedBox(
                            width: 8.0,
                          ),
                          controller.riderNote.value.isNotEmpty
                              ? Text(
                                  "Rider Note: ".tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Text(
                                  "Leave a note for the rider".tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      controller.riderNote.value.isNotEmpty
                          ? Text(
                              controller.riderNote.value.tr,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                                fontFamily: AppThemeData.regular,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildBottomSheet(BuildContext context, LogisticsController controller) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("please select".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(
                                    source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "camera".tr,
                                style: const TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => controller.pickFile(
                                  source: ImageSource.gallery),
                              icon: const Icon(
                                Icons.photo_library_sharp,
                                size: 32,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "gallery".tr,
                                style: const TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  imageCard(String path, int index) => Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.file(
                File(path),
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.images.removeAt(index);
                  // controller.images.value = [...rem];
                },
              ),
            ),
          ],
        ),
      );

  packageCard(BuildContext context, themeChange, int index, var item) =>
      Container(
        padding: const EdgeInsets.only(
          left: 16.0,
          bottom: 16.0,
          top: 5.0,
        ),
        width: Responsive.width(100, context),
        decoration: ShapeDecoration(
          color: themeChange.getThem()
              ? AppThemeData.grey900
              : AppThemeData.grey50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Text(
                        "Package Name".tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${item['name']}".tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.regular,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Weight".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${item['weight']} kg".tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 18.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dimension".tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${item['dimen']} cm".tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: themeChange.getThem()
                            ? AppThemeData.grey50
                            : AppThemeData.grey900,
                        fontFamily: AppThemeData.regular,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Images".tr,
              style: TextStyle(
                fontSize: 14,
                color: themeChange.getThem()
                    ? AppThemeData.grey50
                    : AppThemeData.grey900,
                fontFamily: AppThemeData.regular,
                fontWeight: FontWeight.w600,
              ),
            ),
            GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 6 / 6,
                crossAxisSpacing: 6.0,
              ),
              itemCount: item['images'].length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.file(
                  File(item['images'][index]),
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
}
