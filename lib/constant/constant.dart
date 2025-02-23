import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/models/admin_commission.dart';
import 'package:customer/models/cart_product_model.dart';
import 'package:customer/models/coupon_model.dart';
import 'package:customer/models/currency_model.dart';
import 'package:customer/models/language_model.dart';
import 'package:customer/models/mail_setting.dart';
import 'package:customer/models/order_model.dart';
import 'package:customer/models/tax_model.dart';
import 'package:customer/models/user_model.dart';
import 'package:customer/models/zone_model.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/utils/preferences.dart';
import 'package:customer/widget/permission_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:fluttertoast/fluttertoast.dart';
// import 'package:timeago/timeago.dart' as timeago;

RxList<CartProductModel> cartItem = <CartProductModel>[].obs;

class Constant {
  static String baseURL = "http://192.168.1.71:3880/api/v1";
  // "https://myserver.myfastbuy.com/api/v1";
  static String baseURL2 = "http://192.168.1.71:3880";
  // "https://myserver.myfastbuy.com";
  //
  static String userRoleDriver = 'driver';
  static String userRoleCustomer = 'customer';
  static String userRoleVendor = 'vendor';

  static String homeIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="currentColor" fill-rule="evenodd" d="m21.1 6.551l.03.024c.537.413.87 1.053.87 1.757v11.256A3.4 3.4 0 0 1 18.6 23H5.4A3.4 3.4 0 0 1 2 19.588V8.332c0-.704.333-1.344.87-1.757l.029-.023l7.79-5.132a2.195 2.195 0 0 1 2.581 0zM10 13v8H8v-8.2c0-.992.808-1.8 1.8-1.8h4.4c.992 0 1.8.808 1.8 1.8V21h-2v-8z" clip-rule="evenodd"/></svg>';
  static String homeIconOutline =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linejoin="round" stroke-miterlimit="10" stroke-width="1.5"><path d="M18.6 22H5.4A2.4 2.4 0 0 1 3 19.588V8.332c0-.382.18-.734.48-.965l7.78-5.126a1.195 1.195 0 0 1 1.44 0l7.82 5.126c.3.231.48.583.48.965v11.256A2.4 2.4 0 0 1 18.6 22Z"/><path d="M9.8 12h4.4c.44 0 .8.36.8.8V22H9v-9.2c0-.44.36-.8.8-.8Z"/></g></svg>';

  static String favouriteIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="currentColor" d="m12 21.35l-1.45-1.32C5.4 15.36 2 12.27 2 8.5C2 5.41 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.08C13.09 3.81 14.76 3 16.5 3C19.58 3 22 5.41 22 8.5c0 3.77-3.4 6.86-8.55 11.53z"/></svg>';
  static String favouriteIconOutline =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 50 50"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M40.77 11.333a10.23 10.23 0 0 1 0 14.438L25 41.667L9.23 25.77a10.229 10.229 0 0 1 7.166-17.438a10.2 10.2 0 0 1 7.166 3A9.3 9.3 0 0 1 25 13.167a9.3 9.3 0 0 1 1.438-1.834a10.06 10.06 0 0 1 14.333 0"/></svg><svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 50 50"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M40.77 11.333a10.23 10.23 0 0 1 0 14.438L25 41.667L9.23 25.77a10.229 10.229 0 0 1 7.166-17.438a10.2 10.2 0 0 1 7.166 3A9.3 9.3 0 0 1 25 13.167a9.3 9.3 0 0 1 1.438-1.834a10.06 10.06 0 0 1 14.333 0"/></svg>';

  static String walletIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="currentColor" d="M5.75 7a.75.75 0 0 0 0 1.5h4a.75.75 0 0 0 0-1.5z"/><path fill="currentColor" fill-rule="evenodd" d="M21.188 8.004q-.094-.005-.2-.004h-2.773C15.944 8 14 9.736 14 12s1.944 4 4.215 4h2.773q.106.001.2-.004c.923-.056 1.739-.757 1.808-1.737c.004-.064.004-.133.004-.197V9.938c0-.064 0-.133-.004-.197c-.069-.98-.885-1.68-1.808-1.737m-3.217 5.063c.584 0 1.058-.478 1.058-1.067c0-.59-.474-1.067-1.058-1.067s-1.06.478-1.06 1.067c0 .59.475 1.067 1.06 1.067" clip-rule="evenodd"/><path fill="currentColor" d="M21.14 8.002c0-1.181-.044-2.448-.798-3.355a4 4 0 0 0-.233-.256c-.749-.748-1.698-1.08-2.87-1.238C16.099 3 14.644 3 12.806 3h-2.112C8.856 3 7.4 3 6.26 3.153c-1.172.158-2.121.49-2.87 1.238c-.748.749-1.08 1.698-1.238 2.87C2 8.401 2 9.856 2 11.694v.112c0 1.838 0 3.294.153 4.433c.158 1.172.49 2.121 1.238 2.87c.749.748 1.698 1.08 2.87 1.238c1.14.153 2.595.153 4.433.153h2.112c1.838 0 3.294 0 4.433-.153c1.172-.158 2.121-.49 2.87-1.238q.305-.308.526-.66c.45-.72.504-1.602.504-2.45l-.15.001h-2.774C15.944 16 14 14.264 14 12s1.944-4 4.215-4h2.773q.079 0 .151.002" opacity="0.5"/></svg>';
  static String walletIconOutline =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-width="1"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M6 8h4"/><path stroke-width="1.5" d="M20.833 9h-2.602C16.446 9 15 10.343 15 12s1.447 3 3.23 3h2.603c.084 0 .125 0 .16-.002c.54-.033.97-.432 1.005-.933c.002-.032.002-.071.002-.148v-3.834c0-.077 0-.116-.002-.148c-.036-.501-.465-.9-1.005-.933C20.959 9 20.918 9 20.834 9Z"/><path stroke-width="1.5" d="M20.965 9c-.078-1.872-.328-3.02-1.137-3.828C18.657 4 16.771 4 13 4h-3C6.229 4 4.343 4 3.172 5.172S2 8.229 2 12s0 5.657 1.172 6.828S6.229 20 10 20h3c3.771 0 5.657 0 6.828-1.172c.809-.808 1.06-1.956 1.137-3.828"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.991 12h.01"/></g></svg>';

  static String orderIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="currentColor" fill-rule="evenodd" d="M7.5 6v.75H5.513c-.96 0-1.764.724-1.865 1.679l-1.263 12A1.875 1.875 0 0 0 4.25 22.5h15.5a1.875 1.875 0 0 0 1.865-2.071l-1.263-12a1.875 1.875 0 0 0-1.865-1.679H16.5V6a4.5 4.5 0 1 0-9 0M12 3a3 3 0 0 0-3 3v.75h6V6a3 3 0 0 0-3-3m-3 8.25a3 3 0 1 0 6 0v-.75a.75.75 0 0 1 1.5 0v.75a4.5 4.5 0 1 1-9 0v-.75a.75.75 0 0 1 1.5 0z" clip-rule="evenodd"/></svg>';
  static String orderIconOutline =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15.75 10.5V6a3.75 3.75 0 1 0-7.5 0v4.5m11.356-1.993l1.263 12c.07.665-.45 1.243-1.119 1.243H4.25a1.125 1.125 0 0 1-1.12-1.243l1.264-12A1.125 1.125 0 0 1 5.513 7.5h12.974c.576 0 1.059.435 1.119 1.007M8.625 10.5a.375.375 0 1 1-.75 0a.375.375 0 0 1 .75 0m7.5 0a.375.375 0 1 1-.75 0a.375.375 0 0 1 .75 0"/></svg>';

  static String personIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="currentColor" d="M6.196 17.485q1.275-.918 2.706-1.451Q10.332 15.5 12 15.5t3.098.534t2.706 1.45q.99-1.025 1.593-2.42Q20 13.667 20 12q0-3.325-2.337-5.663T12 4T6.337 6.338T4 12q0 1.667.603 3.064q.603 1.396 1.593 2.42M12 12.5q-1.263 0-2.132-.868T9 9.5t.868-2.132T12 6.5t2.132.868T15 9.5t-.868 2.132T12 12.5m0 8.5q-1.883 0-3.525-.701t-2.858-1.916t-1.916-2.858T3 12t.701-3.525t1.916-2.858q1.216-1.215 2.858-1.916T12 3t3.525.701t2.858 1.916t1.916 2.858T21 12t-.701 3.525t-1.916 2.858q-1.216 1.215-2.858 1.916T12 21"/></svg>';
  static String personIconOutline =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="currentColor" d="M6.196 17.485q1.275-.918 2.706-1.451Q10.332 15.5 12 15.5t3.098.534t2.706 1.45q.99-1.025 1.593-2.42Q20 13.667 20 12q0-3.325-2.337-5.663T12 4T6.337 6.338T4 12q0 1.667.603 3.064q.603 1.396 1.593 2.42m5.805-4.984q-1.264 0-2.133-.868T9 9.501t.868-2.133T12 6.5t2.132.868T15 9.5t-.868 2.132t-2.131.868M12 21q-1.883 0-3.525-.701t-2.858-1.916t-1.916-2.858T3 12t.701-3.525t1.916-2.858q1.216-1.215 2.858-1.916T12 3t3.525.701t2.858 1.916t1.916 2.858T21 12t-.701 3.525t-1.916 2.858q-1.216 1.215-2.858 1.916T12 21m0-1q1.383 0 2.721-.484q1.338-.483 2.313-1.324q-.974-.783-2.255-1.237T12 16.5t-2.789.445t-2.246 1.247q.975.84 2.314 1.324T12 20m0-8.5q.842 0 1.421-.579T14 9.5t-.579-1.421T12 7.5t-1.421.579T10 9.5t.579 1.421T12 11.5m0 6.75"/></svg>';

  static UserModel? userModel; // johnDoe;
  static const globalUrl = "Replace Your website";

  static bool isZoneAvailable = true;
  static ZoneModel? selectedZone;

  static String theme = "theme_1";
  static String mapAPIKey = "AIzaSyD1e9zjiopg9wyMownCMQkKwGGUIdCd-Us";
  static String placeHolderImage = "";

  static String senderId = '';
  static String jsonNotificationFileURL = '';

  static String radius = "50";
  static String driverRadios = "50";
  static String distanceType = "km";

  static String placeholderImage = "";
  static String googlePlayLink = "";
  static String appStoreLink = "";
  static String appVersion = "";
  static String termsAndConditions = "";
  static String privacyPolicy = "";
  static String supportURL = "";
  static String minimumAmountToDeposit = "0.0";
  static String minimumAmountToWithdrawal = "0.0";
  static String? referralAmount = "0.0";
  static bool? walletSetting = true;
  static bool? storyEnable = true;
  static bool? specialDiscountOffer = true;

  static const String orderPlaced = "Order Placed";
  static const String orderAccepted = "Order Accepted";
  static const String orderRejected = "Order Rejected";
  static const String driverPending = "Driver Pending";
  static const String driverRejected = "Driver Rejected";
  static const String orderShipped = "Order Shipped";
  static const String orderInTransit = "In Transit";
  static const String orderCompleted = "Order Completed";

  static CurrencyModel? currencyModel;
  static AdminCommission? adminCommission;
  static List<TaxModel>? taxList = [];

  static MailSettings? mailSettings;
  static String walletTopup = "wallet_topup";
  static String newVendorSignup = "new_vendor_signup";
  static String payoutRequestStatus = "payout_request_status";
  static String payoutRequest = "payout_request";

  static String newOrderPlaced = "order_placed";
  static String scheduleOrder = "schedule_order";
  static String dineInPlaced = "dinein_placed";
  static String dineInCanceled = "dinein_canceled";
  static String dineinAccepted = "dinein_accepted";
  static String restaurantRejected = "restaurant_rejected";
  static String driverCompleted = "driver_completed";
  static String restaurantAccepted = "restaurant_accepted";
  static String takeawayCompleted = "takeaway_completed";

  static String selectedMapType = 'google';
  static String? mapType = "google";

  static toast(String message) {
    Fluttertoast.showToast(
      msg: "" + message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Helper function to process the input value
  static double? _processInput(dynamic inputValue) {
    if (inputValue == null) return null;

    if (inputValue is num) {
      return inputValue.toDouble();
    } else if (inputValue is String) {
      return double.tryParse(inputValue);
    }
    return null; // Invalid input
  }

  static String formatNumber(dynamic inputValue,
      {int? minimumFractionDigits, int? maximumFractionDigits}) {
    const String defaultLocale = 'en_US';

    // Convert input to a number
    final double? number = _processInput(inputValue);
    if (number == null) return '';

    // Create a NumberFormat instance with options
    final NumberFormat formatter = NumberFormat()
      ..minimumFractionDigits = minimumFractionDigits ?? 0
      ..maximumFractionDigits = maximumFractionDigits ?? 2;
    // ..locale = defaultLocale;

    return formatter.format(number);
  }

  // static String timeUntil(DateTime date) {
  //   return timeago
  //       .format(date, locale: "en", allowFromNow: true)
  //       .replaceAll("minute", "min")
  //       .replaceAll("second", "sec")
  //       .replaceAll("hour", "hr")
  //       .replaceAll("a moment ago", "just now")
  //       .replaceAll("about", "");
  // }

  static String amountShow({required String? amount}) {
    if (currencyModel!.symbolAtRight == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(currencyModel!.decimalDigits ?? 0)} ${currencyModel!.symbol.toString()}";
    } else {
      return "${currencyModel!.symbol.toString()} ${amount == null || amount.isEmpty ? "0.0" : double.parse(amount.toString()).toStringAsFixed(currencyModel!.decimalDigits ?? 0)}";
    }
  }

  static Color statusColor({required String? status}) {
    if (status == orderPlaced) {
      return AppThemeData.secondary300;
    } else if (status == orderAccepted || status == orderCompleted) {
      return AppThemeData.success400;
    } else if (status == orderRejected) {
      return AppThemeData.danger300;
    } else {
      return AppThemeData.warning300;
    }
  }

  static Color statusText({required String? status}) {
    if (status == orderPlaced) {
      return AppThemeData.grey50;
    } else if (status == orderAccepted || status == orderCompleted) {
      return AppThemeData.grey50;
    } else if (status == orderRejected) {
      return AppThemeData.grey50;
    } else {
      return AppThemeData.grey900;
    }
  }

  static String productCommissionPrice(String price) {
    String commission = "0";
    if (adminCommission != null && adminCommission!.isEnabled == true) {
      if (adminCommission!.commissionType!.toLowerCase() ==
              "Percent".toLowerCase() ||
          adminCommission!.commissionType?.toLowerCase() ==
              "Percentage".toLowerCase()) {
        commission = (double.parse(price) +
                (double.parse(price) *
                    double.parse(adminCommission!.amount.toString()) /
                    100))
            .toString();
      } else {
        commission = (double.parse(price) +
                double.parse(adminCommission!.amount.toString()))
            .toString();
      }
    } else {
      commission = price;
    }
    return commission;
  }

  static double calculateTax({String? amount, TaxModel? taxModel}) {
    double taxAmount = 0.0;
    if (taxModel != null && taxModel.enable == true) {
      if (taxModel.type == "fix") {
        taxAmount = double.parse(taxModel.tax.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) *
                double.parse(taxModel.tax!.toString())) /
            100;
      }
    }
    return taxAmount;
  }

  static double calculateDiscount({String? amount, CouponModel? offerModel}) {
    double taxAmount = 0.0;
    if (offerModel != null) {
      if (offerModel.discountType == "Percentage" ||
          offerModel.discountType == "percentage") {
        taxAmount = (double.parse(amount.toString()) *
                double.parse(offerModel.discount.toString())) /
            100;
      } else {
        taxAmount = double.parse(offerModel.discount.toString());
      }
    }
    return taxAmount;
  }

  static String calculateReview(
      {required String? reviewCount, required String? reviewSum}) {
    if (0 == double.parse(reviewSum.toString()) &&
        0 == double.parse(reviewSum.toString())) {
      return "0";
    }
    return (double.parse(reviewSum.toString()) /
            double.parse(reviewCount.toString()))
        .toStringAsFixed(1);
  }

  static const userPlaceHolder = 'assets/images/user_placeholder.png';

  static String getUuid() {
    return const Uuid().v4();
  }

  static Widget loader() {
    return Center(
      child: CircularProgressIndicator(color: AppThemeData.primary300),
    );
  }

  static Widget showEmptyView({required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty.png",
          ),
          Text(message,
              style: const TextStyle(
                  fontFamily: AppThemeData.medium, fontSize: 18)),
        ],
      ),
    );
  }

  static String getReferralCode() {
    var rng = math.Random();
    return (rng.nextInt(900000) + 100000).toString();
  }

  static String maskingString(String documentId, int maskingDigit) {
    String maskedDigits = documentId;
    for (int i = 0; i < documentId.length - maskingDigit; i++) {
      maskedDigits = maskedDigits.replaceFirst(documentId[i], "*");
    }
    return maskedDigits;
  }

  String? validateRequired(String? value, String type) {
    if (value!.isEmpty) {
      return '$type required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  static String getDistance(
      {required String lat1,
      required String lng1,
      required String lat2,
      required String lng2}) {
    double distance;
    double distanceInMeters = Geolocator.distanceBetween(
      double.parse(lat1),
      double.parse(lng1),
      double.parse(lat2),
      double.parse(lng2),
    );
    if (distanceType == "miles") {
      distance = distanceInMeters / 1609;
    } else {
      distance = distanceInMeters / 1000;
    }
    return distance.toStringAsFixed(2);
  }

  bool hasValidUrl(String? value) {
    print("=====>");
    print(value);
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  launchURL(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<TimeOfDay?> selectTime(context) async {
    FocusScope.of(context).requestFocus(FocusNode()); //remove focus
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      return newTime;
    }
    return null;
  }

  static Future<DateTime?> selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppThemeData.primary300, // header background color
                onPrimary: AppThemeData.grey900, // header text color
                onSurface: AppThemeData.grey900, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppThemeData.grey900, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        //get today's date
        firstDate: DateTime(2000),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    return pickedDate;
  }

  static int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  static DateTime stringToDate(String openDineTime) {
    return DateFormat('HH:mm').parse(DateFormat('HH:mm').format(
        DateFormat("hh:mm a").parse((Intl.getCurrentLocale() == "en_US")
            ? openDineTime
            : openDineTime.toLowerCase())));
  }

  static LanguageModel getLanguage() {
    final String user = Preferences.getString(Preferences.languageCodeKey);
    Map<String, dynamic> userMap = jsonDecode(user);
    return LanguageModel.fromJson(userMap);
  }

  static String orderId({String orderId = ''}) {
    return "#${(orderId).substring(orderId.length - 10)}";
  }

  static checkPermission(
      {required BuildContext context, required Function() onTap}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, request the user to enable it
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      ShowToastDialog.showToast(
          "You have to allow location permission to use your location");
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const PermissionDialog();
        },
      );
    } else {
      onTap();
    }
  }

  static bool isPointInPolygon(LatLng point, List<GeoPoint> polygon) {
    int crossings = 0;
    for (int i = 0; i < polygon.length; i++) {
      int next = (i + 1) % polygon.length;
      if (polygon[i].latitude <= point.latitude &&
              polygon[next].latitude > point.latitude ||
          polygon[i].latitude > point.latitude &&
              polygon[next].latitude <= point.latitude) {
        double edgeLong = polygon[next].longitude - polygon[i].longitude;
        double edgeLat = polygon[next].latitude - polygon[i].latitude;
        double interpol = (point.latitude - polygon[i].latitude) / edgeLat;
        if (point.longitude < polygon[i].longitude + interpol * edgeLong) {
          crossings++;
        }
      }
    }
    return (crossings % 2 != 0);
  }

  static Uri createCoordinatesUrl(double latitude, double longitude,
      [String? label]) {
    Uri uri;
    if (kIsWeb) {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    } else if (Platform.isAndroid) {
      var query = '$latitude,$longitude';
      if (label != null) query += '($label)';
      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      var params = {'ll': '$latitude,$longitude'};
      if (label != null) params['q'] = label;
      uri = Uri.https('maps.apple.com', '/', params);
    } else {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    }

    return uri;
  }

  static sendOrderEmail({required OrderModel orderModel}) async {
    // EmailTemplateModel? emailTemplateModel = "";
    // // await FireStoreUtils.getEmailTemplates(newOrderPlaced);
    // if (emailTemplateModel != null) {
    //   String firstHTML = """
    //    <table style="width: 100%; border-collapse: collapse; border: 1px solid rgb(0, 0, 0);">
    // <thead>
    //     <tr>
    //         <th style="text-align: left; border: 1px solid rgb(0, 0, 0);">Product Name<br></th>
    //         <th style="text-align: left; border: 1px solid rgb(0, 0, 0);">Quantity<br></th>
    //         <th style="text-align: left; border: 1px solid rgb(0, 0, 0);">Price<br></th>
    //         <th style="text-align: left; border: 1px solid rgb(0, 0, 0);">Extra Item Price<br></th>
    //         <th style="text-align: left; border: 1px solid rgb(0, 0, 0);">Total<br></th>
    //     </tr>
    // </thead>
    // <tbody>
    // """;

    //   String newString = emailTemplateModel.message.toString();
    //   newString = newString.replaceAll("{username}",
    //       "${Constant.userModel!.firstName} ${Constant.userModel!.lastName}");
    //   newString = newString.replaceAll("{orderid}", orderModel.id.toString());
    //   // newString = newString.replaceAll("{date}",
    //   //     DateFormat('yyyy-MM-dd').format(orderModel.createdAt!.toDate()));
    //   newString = newString.replaceAll(
    //     "{address}",
    //     orderModel.address!.getFullAddress(),
    //   );
    //   newString = newString.replaceAll(
    //     "{paymentmethod}",
    //     orderModel.paymentMethod.toString(),
    //   );

    //   double deliveryCharge = 0.0;
    //   double total = 0.0;
    //   double specialDiscount = 0.0;
    //   double discount = 0.0;
    //   double taxAmount = 0.0;
    //   double tipValue = 0.0;
    //   String specialLabel =
    //       '(${orderModel.specialDiscount!['special_discount_label']}${orderModel.specialDiscount!['specialType'] == "amount" ? currencyModel!.symbol : "%"})';
    //   List<String> htmlList = [];

    //   if (orderModel.deliveryCharge != null) {
    //     deliveryCharge = double.parse(orderModel.deliveryCharge.toString());
    //   }
    //   if (orderModel.tipAmount != null) {
    //     tipValue = double.parse(orderModel.tipAmount.toString());
    //   }
    //   for (var element in orderModel.products!) {
    //     if (element.extrasPrice != null &&
    //         element.extrasPrice!.isNotEmpty &&
    //         double.parse(element.extrasPrice!) != 0.0) {
    //       total += double.parse(element.quantity.toString()) *
    //           double.parse(element.extrasPrice!);
    //     }
    //     total += double.parse(element.quantity.toString()) *
    //         double.parse(element.price.toString());

    //     List<dynamic>? addon = element.extras;
    //     String extrasDisVal = '';
    //     for (int i = 0; i < addon!.length; i++) {
    //       extrasDisVal +=
    //           '${addon[i].toString().replaceAll("\"", "")} ${(i == addon.length - 1) ? "" : ","}';
    //     }
    //     String product = """
    //     <tr>
    //         <td style="width: 20%; border-top: 1px solid rgb(0, 0, 0);">${element.name}</td>
    //         <td style="width: 20%; border: 1px solid rgb(0, 0, 0);" rowspan="2">${element.quantity}</td>
    //         <td style="width: 20%; border: 1px solid rgb(0, 0, 0);" rowspan="2">${amountShow(amount: element.price.toString())}</td>
    //         <td style="width: 20%; border: 1px solid rgb(0, 0, 0);" rowspan="2">${amountShow(amount: element.extrasPrice.toString())}</td>
    //         <td style="width: 20%; border: 1px solid rgb(0, 0, 0);" rowspan="2">${amountShow(amount: ((double.parse(element.quantity.toString()) * double.parse(element.extrasPrice!) + (double.parse(element.quantity.toString()) * double.parse(element.price.toString())))).toString())}</td>
    //     </tr>
    //     <tr>
    //         <td style="width: 20%;">${extrasDisVal.isEmpty ? "" : "Extra Item : $extrasDisVal"}</td>
    //     </tr>
    // """;
    //     htmlList.add(product);
    //   }

    //   if (orderModel.specialDiscount!.isNotEmpty) {
    //     specialDiscount = double.parse(
    //         orderModel.specialDiscount!['special_discount'].toString());
    //   }

    //   if (orderModel.couponId != null && orderModel.couponId!.isNotEmpty) {
    //     discount = double.parse(orderModel.discount.toString());
    //   }

    //   List<String> taxHtmlList = [];
    //   if (taxList != null) {
    //     for (var element in taxList!) {
    //       taxAmount = taxAmount +
    //           calculateTax(
    //               amount: (total - discount - specialDiscount).toString(),
    //               taxModel: element);
    //       String taxHtml =
    //           """<span style="font-size: 1rem;">${element.title}: ${amountShow(amount: calculateTax(amount: (total - discount - specialDiscount).toString(), taxModel: element).toString())}${taxList!.indexOf(element) == taxList!.length - 1 ? "</span>" : "<br></span>"}""";
    //       taxHtmlList.add(taxHtml);
    //     }
    //   }

    //   var totalamount = orderModel.deliveryCharge == null ||
    //           orderModel.deliveryCharge!.isEmpty
    //       ? total + taxAmount - discount - specialDiscount
    //       : total +
    //           taxAmount +
    //           double.parse(orderModel.deliveryCharge!) +
    //           double.parse(orderModel.tipAmount!) -
    //           discount -
    //           specialDiscount;

    //   newString = newString.replaceAll(
    //       "{subtotal}", amountShow(amount: total.toString()));
    //   newString =
    //       newString.replaceAll("{coupon}", orderModel.couponId.toString());
    //   newString = newString.replaceAll("{discountamount}",
    //       amountShow(amount: orderModel.discount.toString()));
    //   newString = newString.replaceAll("{specialcoupon}", specialLabel);
    //   newString = newString.replaceAll("{specialdiscountamount}",
    //       amountShow(amount: specialDiscount.toString()));
    //   newString = newString.replaceAll(
    //       "{shippingcharge}", amountShow(amount: deliveryCharge.toString()));
    //   newString = newString.replaceAll(
    //       "{tipamount}", amountShow(amount: tipValue.toString()));
    //   newString = newString.replaceAll(
    //       "{totalAmount}", amountShow(amount: totalamount.toString()));

    //   String tableHTML = htmlList.join();
    //   String lastHTML = "</tbody></table>";
    //   newString = newString.replaceAll(
    //       "{productdetails}", firstHTML + tableHTML + lastHTML);
    //   newString = newString.replaceAll("{taxdetails}", taxHtmlList.join());
    //   newString = newString.replaceAll("{newwalletbalance}.",
    //       amountShow(amount: Constant.userModel!.walletAmount.toString()));

    //   String subjectNewString = emailTemplateModel.subject.toString();
    //   subjectNewString =
    //       subjectNewString.replaceAll("{orderid}", orderModel.id.toString());
    // }
  }
}

extension StringExtension on String {
  String capitalizeString() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
