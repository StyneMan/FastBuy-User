import 'dart:convert';
import 'dart:io';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/data/dummy_payment_gateways.dart';
import 'package:customer/models/payment_model/mid_trans.dart';
import 'package:customer/models/payment_model/orange_money.dart';
import 'package:customer/models/payment_model/xendit.dart';
import 'package:customer/payment/MercadoPagoScreen.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';

import 'package:customer/models/payment_model/flutter_wave_model.dart';
import 'package:customer/models/payment_model/mercado_pago_model.dart';
import 'package:customer/models/payment_model/pay_fast_model.dart';
import 'package:customer/models/payment_model/pay_stack_model.dart';
import 'package:customer/models/payment_model/paypal_model.dart';
import 'package:customer/models/payment_model/paytm_model.dart';
import 'package:customer/models/payment_model/razorpay_model.dart';
import 'package:customer/models/payment_model/stripe_model.dart';
import 'package:customer/models/user_model.dart';
import 'package:customer/models/wallet_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as maths;
import 'package:http/http.dart' as http;

import 'my_profile_controller.dart';

class WalletController extends GetxController {
  final profileController = Get.find<MyProfileController>();
  RxBool isLoading = true.obs;
  var userWallet = {}.obs;
  var walletTransactions = {}.obs;
  Rx<TextEditingController> topUpAmountController = TextEditingController().obs;

  RxList<WalletTransactionModel> walletTransactionList =
      <WalletTransactionModel>[].obs;

  Rx<UserModel> userModel = UserModel().obs;
  RxString selectedPaymentMethod = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getPaymentSettings();
    getWalletTransaction();
    super.onInit();
  }

  Rx<PayFastModel> payFastModel = PayFastModel().obs;
  Rx<MercadoPagoModel> mercadoPagoModel = MercadoPagoModel().obs;
  Rx<PayPalModel> payPalModel = PayPalModel().obs;
  Rx<StripeModel> stripeModel = StripeModel().obs;
  Rx<FlutterWaveModel> flutterWaveModel = FlutterWaveModel().obs;
  Rx<PayStackModel> payStackModel = PayStackModel().obs;
  Rx<PaytmModel> paytmModel = PaytmModel().obs;
  Rx<RazorPayModel> razorPayModel = RazorPayModel().obs;
  Rx<MidTrans> midTransModel = MidTrans().obs;
  Rx<OrangeMoney> orangeMoneyModel = OrangeMoney().obs;
  Rx<Xendit> xenditModel = Xendit().obs;

  getWalletTransaction() async {
    if (profileController.userData.value.isNotEmpty) {
      try {
        final accessToken = Preferences.getString(Preferences.accessTokenKey);
        if (accessToken.isNotEmpty) {
          APIService()
              .getTransactionsStreamed(
            accessToken: accessToken,
            customerId: profileController.userData.value['id'],
            page: 1,
          )
              .listen((onData) {
            debugPrint("MY WALLET TRANSACTIONS :: ${onData.body}");
            if (onData.statusCode >= 200 && onData.statusCode <= 299) {
              Map<String, dynamic> map = jsonDecode(onData.body);

              walletTransactions.value = map;
            }
          });
        }
      } catch (e) {}
    }
    isLoading.value = false;
  }

  refreshWallet() async {
    try {
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      APIService()
          .getWalletStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
      )
          .listen((onData) {
        // debugPrint("MY WALLET  :: ${onData.body}");
        if (onData.statusCode >= 200 && onData.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(onData.body);
          userWallet.value = map;
        }
      });

      APIService()
          .getTransactionsStreamed(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: 1,
      )
          .listen((onData) {
        debugPrint("MY WALLET TRANSACTIONS :: ${onData.body}");
        if (onData.statusCode >= 200 && onData.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(onData.body);

          walletTransactions.value = map;
        }
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  getPaymentSettings() async {
    // await FireStoreUtils.getPaymentSettingsData().then(
    //   (value) {
    payFastModel.value = dummyPayFastModel;
    // PayFastModel.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.payFastSettings)));
    mercadoPagoModel.value = dummyMercadoPagoModel;
    // MercadoPagoModel.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.mercadoPago)));
    payPalModel.value = dummyPayPalModel;
    // PayPalModel.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.paypalSettings)));
    stripeModel.value = dummyStripeModel;
    // StripeModel.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.stripeSettings)));
    flutterWaveModel.value = dummyFlutterWaveModel;
    // FlutterWaveModel.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.flutterWave)));
    payStackModel.value = dummyPayStackModel;
    // PayS    tackModel.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.payStack)));
    paytmModel.value = dummyPaytmModel;
    // PaytmModel.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.paytmSettings)));
    razorPayModel.value = dummyRazorPayModel;
    // RazorPayModel.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.razorpaySettings)));

    midTransModel.value = dummyMidTrans;
    // MidTrans.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.midTransSettings)));
    orangeMoneyModel.value = dummyOrangeMoney;
    // OrangeMoney.fromJson(json
    //     .decode(Preferences.getString(Preferences.orangeMoneySettings)));
    xenditModel.value = dummyXendit;
    // Xendit.fromJson(
    //     jsonDecode(Preferences.getString(Preferences.xenditSettings)));

    // Stripe.publishableKey = stripeModel.value.clientpublishableKey.toString();
    // Stripe.merchantIdentifier = 'GoRide';
    // Stripe.instance.applySettings();
    // setRef();

    // razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    // razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
    // razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    // },
    // );
  }

  //flutter wave Payment Method
  initiatePayment({
    required BuildContext context,
    required String amount,
  }) async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      Map payload = {
        "amount": int.parse(amount),
        "email_address": profileController.userData.value['email_address'],
        "full_name":
            "${profileController.userData.value['first_name']} ${profileController.userData.value['last_name']}",
        "customer_id": profileController.userData.value['id'],
        "phone_number": profileController.userData.value['intl_phone_format'],
        "title": "Fund Wallet"
      };

      final response = await APIService().initPayment(
        accessToken: accessToken,
        payload: payload,
      );
      debugPrint("INIT PAYMENT RESPONSE ::: ${response.body}");
      ShowToastDialog.closeLoader();
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> data = jsonDecode(response.body);

        Get.to(MercadoPagoScreen(
                initialURl:
                    data['data']['link'] ?? data['data']['authorization_url']))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            // Refresh wallet here
            refreshWallet();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
      } else {
        debugPrint('Payment initialization failed: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint("INIT PAYMENT ERROR ::: $e");
      ShowToastDialog.closeLoader();
    }
  }

  String? _ref;

  setRef() {
    maths.Random numRef = maths.Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      _ref = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      _ref = "IOSRef$year$refNumber";
    }
  }

  Future verifyCheckSum(
      {required String checkSum,
      required double amount,
      required orderId}) async {
    String getChecksum = "${Constant.globalUrl}payments/validatechecksum";
    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {},
        body: {
          "mid": paytmModel.value.paytmMID.toString(),
          "order_id": orderId,
          "key_secret": paytmModel.value.pAYTMMERCHANTKEY.toString(),
          "checksum_value": checkSum,
        });
    final data = jsonDecode(response.body);
    return data['status'];
  }

  String generateBasicAuthHeader(String apiKey) {
    String credentials = '$apiKey:';
    String base64Encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Encoded';
  }

  //Orangepay payment
  static String accessToken = '';
  static String payToken = '';
  static String orderId = '';
  static String amount = '';

  static reset() {
    accessToken = '';
    payToken = '';
    orderId = '';
    amount = '';
  }
}
