import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/app/splash_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/controllers/global_setting_controller.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/controllers/otp_controller.dart';
import 'package:customer/models/language_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/services/localization_service.dart';
import 'package:customer/services/socket/socket_manager.dart';
import 'package:customer/themes/styles.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   androidProvider: AndroidProvider.playIntegrity,
  //   appleProvider: AppleProvider.appAttest,
  // );
  // DatabaseHelper.instance;
  await Preferences.initPref();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  final _controller = Get.put(OtpController());
  final _cartcontroller = Get.put(CartController());
  final _profilecontroller = Get.put(MyProfileController());

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestPermissions() async {
    final bool? granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    if (granted != null && granted) {
      print('Notification permission granted!');
    } else {
      print('Notification permission denied.');
    }
  }

  @override
  void initState() {
    getCurrentAppTheme();
    fetchLegals();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Preferences.getString(Preferences.languageCodeKey)
          .toString()
          .isNotEmpty) {
        LanguageModel languageModel = Constant.getLanguage();
        LocalizationService().changeLocale(languageModel.slug.toString());
      } else {
        LanguageModel languageModel =
            LanguageModel(slug: "en", isRtl: false, title: "English");
        Preferences.setString(
            Preferences.languageCodeKey, jsonEncode(languageModel.toJson()));
      }
    });
    final socket = SocketManager().socket;
    // socket.connect();
    // socket.on

    final accessToken = Preferences.getString(Preferences.accessTokenKey);
    if (accessToken.isNotEmpty) {
      socket.on(
        "notification",
        (data) {
          debugPrint("DATA FROM CHAT >> $data");
        },
      );

      // socket.on(
      //   "refresh-cart",
      //   (data) {
      //     debugPrint("REFRESH  CART HERE >> $data");
      //     // Constant.toast("${data['message']}");

      //   },
      // );
    }

    requestPermissions();
    initLocation();

    super.initState();
  }

  initLocation() {
    Constant.checkPermission(
      context: context,
      onTap: () async {
        // ShowToastDialog.showLoader("Please wait".tr);
        ShippingAddress addressModel = ShippingAddress();
        try {
          await Geolocator.requestPermission();

          Position newLocalData = await Geolocator.getCurrentPosition(
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
                  newLocalData.latitude, newLocalData.longitude)
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
          });

          // Constant.selectedLocation = addressModel;
          // ShowToastDialog.closeLoader();

          // Get.offAll(const DashBoardScreen());
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
          // ShowToastDialog.closeLoader();

          // Get.offAll(const DashBoardScreen());
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  void fetchLegals() async {
    try {
      final resp = await APIService().getLegals();
      debugPrint("LEGALS ::: ${resp.body}");
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        final dynamic decoded = jsonDecode(resp.body);

        if (decoded is List) {
          final List<Map<String, dynamic>> mapList =
              decoded.map((e) => Map<String, dynamic>.from(e)).toList();
          _profilecontroller.policy.value = mapList[0]['privacy'] ?? '';
          _profilecontroller.terms.value = mapList[0]['terms'] ?? '';
        } else if (decoded is Map) {
          _profilecontroller.policy.value = decoded['privacy'] ?? '';
          _profilecontroller.terms.value = decoded['terms'] ?? '';
        } else {
          debugPrint("Unexpected response structure.");
        }
      }

      final gatewayResponse = await APIService().getPaymentGateways();
      debugPrint("PAYMENT GATEWAYS ::: ${gatewayResponse.body}");
      if (gatewayResponse.statusCode >= 200 &&
          gatewayResponse.statusCode <= 299) {
        final dynamic decoded = jsonDecode(gatewayResponse.body);

        if (decoded is List) {
          final List<Map<String, dynamic>> mapList =
              decoded.map((e) => Map<String, dynamic>.from(e)).toList();
          _profilecontroller.paymentGateways.value = mapList;
        } else {
          debugPrint("Unexpected response structure.");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return GetMaterialApp(
            title: 'FastBuy'.tr,
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(
                themeChangeProvider.darkTheme == 0
                    ? true
                    : themeChangeProvider.darkTheme == 1
                        ? false
                        : false,
                context),
            localizationsDelegates: const [
              CountryLocalizations.delegate,
            ],
            locale: LocalizationService.locale,
            fallbackLocale: LocalizationService.locale,
            translations: LocalizationService(),
            builder: EasyLoading.init(),
            home: GetBuilder<GlobalSettingController>(
              init: GlobalSettingController(),
              builder: (context) {
                return const SplashScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
