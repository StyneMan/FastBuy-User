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
  static String baseURL = "https://myserver.myfastbuy.com/api/v1";
  // "http://192.168.2.112:3880/api/v1";

  static String baseURL2 = "https://myserver.myfastbuy.com";
  // "http://192.168.53.247:3880";

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

  static String darkIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="currentColor" d="M20.993 13.313a6 6 0 0 1-7.306-7.306a7 7 0 1 0 7.306 7.306"/><path fill="currentColor" fill-rule="evenodd" d="M4.5 8.25a.5.5 0 0 1 .5.5v1.5a.5.5 0 0 1-1 0v-1.5a.5.5 0 0 1 .5-.5" clip-rule="evenodd"/><path fill="currentColor" fill-rule="evenodd" d="M3.25 9.5a.5.5 0 0 1 .5-.5h1.5a.5.5 0 0 1 0 1h-1.5a.5.5 0 0 1-.5-.5M7.5 3a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2a.5.5 0 0 1 .5-.5" clip-rule="evenodd"/><path fill="currentColor" fill-rule="evenodd" d="M6 4.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5" clip-rule="evenodd"/></svg>';

  static String shareIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><g fill="none" fill-rule="evenodd"><path d="m12.593 23.258l-.011.002l-.071.035l-.02.004l-.014-.004l-.071-.035q-.016-.005-.024.005l-.004.01l-.017.428l.005.02l.01.013l.104.074l.015.004l.012-.004l.104-.074l.012-.016l.004-.017l-.017-.427q-.004-.016-.017-.018m.265-.113l-.013.002l-.185.093l-.01.01l-.003.011l.018.43l.005.012l.008.007l.201.093q.019.005.029-.008l.004-.014l-.034-.614q-.005-.018-.02-.022m-.715.002a.02.02 0 0 0-.027.006l-.006.014l-.034.614q.001.018.017.024l.015-.002l.201-.093l.01-.008l.004-.011l.017-.43l-.003-.012l-.01-.01z"/><path fill="currentColor" d="M15 5.5a3.5 3.5 0 1 1 .994 2.443L11.67 10.21c.213.555.33 1.16.33 1.79a5 5 0 0 1-.33 1.79l4.324 2.267a3.5 3.5 0 1 1-.93 1.771l-4.475-2.346a5 5 0 1 1 0-6.963l4.475-2.347A3.5 3.5 0 0 1 15 5.5"/></g></svg>';

  static String rateIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="currentColor" d="M18.483 16.767A8.5 8.5 0 0 1 8.118 7.081a1 1 0 0 1-.113.097c-.28.213-.63.292-1.33.45l-.635.144c-2.46.557-3.69.835-3.983 1.776c-.292.94.546 1.921 2.223 3.882l.434.507c.476.557.715.836.822 1.18c.107.345.071.717-.001 1.46l-.066.677c-.253 2.617-.38 3.925.386 4.506s1.918.052 4.22-1.009l.597-.274c.654-.302.981-.452 1.328-.452s.674.15 1.329.452l.595.274c2.303 1.06 3.455 1.59 4.22 1.01c.767-.582.64-1.89.387-4.507z"/><path fill="currentColor" d="m9.153 5.408l-.328.588c-.36.646-.54.969-.82 1.182q.06-.045.113-.097a8.5 8.5 0 0 0 10.366 9.686l-.02-.19c-.071-.743-.107-1.115 0-1.46c.107-.344.345-.623.822-1.18l.434-.507c1.677-1.96 2.515-2.941 2.222-3.882c-.292-.941-1.522-1.22-3.982-1.776l-.636-.144c-.699-.158-1.049-.237-1.33-.45c-.28-.213-.46-.536-.82-1.182l-.327-.588C13.58 3.136 12.947 2 12 2s-1.58 1.136-2.847 3.408" opacity="0.5"/></svg>';

  static String termsIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 32 32"><path fill="currentColor" d="M28 26h-3v-2h3V8h-3V6h3a2 2 0 0 1 2 2v16a2.003 2.003 0 0 1-2 2"/><circle cx="23" cy="16" r="2" fill="currentColor"/><circle cx="16" cy="16" r="2" fill="currentColor"/><circle cx="9" cy="16" r="2" fill="currentColor"/><path fill="currentColor" d="M7 26H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3v2H4v16h3Z"/></svg>';

  static String policyIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="currentColor" d="M12.003 20.842q-.159 0-.309-.025t-.281-.075q-2.951-1.125-4.682-3.816T5 11.1V6.817q0-.514.293-.926q.292-.412.757-.597l5.385-2q.292-.106.565-.106t.566.106l5.384 2q.464.186.757.597q.293.412.293.926V11.1q0 1.498-.422 2.88t-1.14 2.674l-2.95-2.95q.237-.379.375-.81Q15 12.463 15 12q0-1.237-.881-2.119T12 9t-2.119.881T9 12t.881 2.119T12 15q.487 0 .941-.147q.455-.147.828-.441l3.071 3.065q-.911 1.067-1.933 1.903t-2.34 1.362q-.135.05-.27.075q-.137.025-.295.025M12 14q-.825 0-1.412-.587T10 12t.588-1.412T12 10t1.413.588T14 12t-.587 1.413T12 14"/></svg>';

  static String drawerIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 17h8m-8-5h14m-8-5h8"/></svg>';

  static String profileIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"><circle cx="12" cy="8.196" r="4.446"/><path d="M19.608 20.25a7.608 7.608 0 0 0-15.216 0"/></g></svg><svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"><circle cx="12" cy="8.196" r="4.446"/><path d="M19.608 20.25a7.608 7.608 0 0 0-15.216 0"/></g></svg>';

  static String logoutIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 24 24"><path fill="currentColor" d="M12 3.25a.75.75 0 0 1 0 1.5a7.25 7.25 0 0 0 0 14.5a.75.75 0 0 1 0 1.5a8.75 8.75 0 1 1 0-17.5"/><path fill="currentColor" d="M16.47 9.53a.75.75 0 0 1 1.06-1.06l3 3a.75.75 0 0 1 0 1.06l-3 3a.75.75 0 1 1-1.06-1.06l1.72-1.72H10a.75.75 0 0 1 0-1.5h8.19z"/></svg>';

  static String loginIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 20 20"><path fill="currentColor" d="M9.76 0C15.417 0 20 4.477 20 10S15.416 20 9.76 20c-3.191 0-6.142-1.437-8.07-3.846a.644.644 0 0 1 .115-.918a.68.68 0 0 1 .94.113a8.96 8.96 0 0 0 7.016 3.343c4.915 0 8.9-3.892 8.9-8.692s-3.985-8.692-8.9-8.692a8.96 8.96 0 0 0-6.944 3.255a.68.68 0 0 1-.942.101a.644.644 0 0 1-.103-.92C3.703 1.394 6.615 0 9.761 0m.545 6.862l2.707 2.707c.262.262.267.68.011.936L10.38 13.15a.66.66 0 0 1-.937-.011a.66.66 0 0 1-.01-.937l1.547-1.548l-10.31.001A.66.66 0 0 1 0 10c0-.361.3-.654.67-.654h10.268L9.38 7.787a.66.66 0 0 1-.01-.937a.66.66 0 0 1 .935.011"/></svg>';

  static String supportIcon =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24px" height="24px" viewBox="0 0 512 512"><path fill="currentColor" fill-rule="evenodd" d="M422.401 217.174c-6.613-67.84-46.72-174.507-170.666-174.507c-123.947 0-164.054 106.667-170.667 174.507c-23.2 8.805-38.503 31.079-38.4 55.893v29.867c0 32.99 26.744 59.733 59.733 59.733c32.99 0 59.734-26.744 59.734-59.733v-29.867c-.108-24.279-14.848-46.095-37.334-55.253c4.267-39.254 25.174-132.48 126.934-132.48s122.453 93.226 126.72 132.48c-22.44 9.178-37.106 31.009-37.12 55.253v29.867a59.95 59.95 0 0 0 33.92 53.76c-8.96 16.853-31.787 39.68-87.894 46.506c-11.215-17.03-32.914-23.744-51.788-16.023c-18.873 7.72-29.646 27.717-25.71 47.725s21.48 34.432 41.872 34.432a42.67 42.67 0 0 0 37.973-23.68c91.52-10.454 120.747-57.6 129.92-85.334c24.817-8.039 41.508-31.301 41.173-57.386v-29.867c.103-24.814-15.2-47.088-38.4-55.893m-302.933 85.76c0 9.425-7.641 17.066-17.067 17.066s-17.066-7.64-17.066-17.066v-29.867a17.067 17.067 0 1 1 34.133 0zm264.533-29.867c0-9.426 7.641-17.067 17.067-17.067s17.067 7.641 17.067 17.067v29.867c0 9.425-7.641 17.066-17.067 17.066s-17.067-7.64-17.067-17.066z"/></svg>';

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
