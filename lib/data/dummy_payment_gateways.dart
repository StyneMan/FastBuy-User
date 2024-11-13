import 'package:customer/models/payment_model/flutter_wave_model.dart';
import 'package:customer/models/payment_model/mercado_pago_model.dart';
import 'package:customer/models/payment_model/mid_trans.dart';
import 'package:customer/models/payment_model/orange_money.dart';
import 'package:customer/models/payment_model/pay_fast_model.dart';
import 'package:customer/models/payment_model/pay_stack_model.dart';
import 'package:customer/models/payment_model/paypal_model.dart';
import 'package:customer/models/payment_model/paytm_model.dart';
import 'package:customer/models/payment_model/razorpay_model.dart';
import 'package:customer/models/payment_model/stripe_model.dart';
import 'package:customer/models/payment_model/xendit.dart';

PayFastModel dummyPayFastModel = PayFastModel(
  returnUrl: "https://example.com/payment/return",
  cancelUrl: "https://example.com/payment/cancel",
  notifyUrl: "https://example.com/payment/notify",
  merchantKey: "merchant_key_12345",
  isEnable: true,
  merchantId: "100001",
  isSandbox: true,
);

MercadoPagoModel dummyMercadoPagoModel = MercadoPagoModel(
  isSandboxEnabled: true,
  isEnabled: true,
  accessToken: "TEST-1234567890abcdef-123456-abcdef1234567890abcdef",
  publicKey: "TEST-public-key-1234567890abcdef",
);

PayPalModel dummyPayPalModel = PayPalModel(
  paypalSecret: "your-dummy-paypal-secret-key",
  isWithdrawEnabled: true,
  paypalAppId: "your-dummy-paypal-app-id",
  isEnabled: true,
  isLive: false,
  paypalClient: "your-dummy-paypal-client-id",
);

StripeModel dummyStripeModel = StripeModel(
  stripeSecret: "sk_test_4eC39HqLyjWDarjtT1zdp7dc",
  clientpublishableKey: "pk_test_TYooMQauvdEDq54NiTphI7jx",
  isWithdrawEnabled: true,
  isEnabled: true,
  isSandboxEnabled: true,
  stripeKey: "stripe-test-key",
);

FlutterWaveModel dummyFlutterWaveModel = FlutterWaveModel(
  isSandbox: true,
  isWithdrawEnabled: true,
  publicKey: "FLWPUBK_TEST-abc1234567890abcdef-X",
  encryptionKey: "FLWSECK_TEST1234567890",
  isEnable: true,
  secretKey: "FLWSECK_TEST-xyz1234567890abcdef-X",
);

PayStackModel dummyPayStackModel = PayStackModel(
  isSandbox: true,
  callbackURL: "https://example.com/callback",
  publicKey: "pk_test_1234567890abcdef",
  secretKey: "sk_test_1234567890abcdef",
  isEnable: true,
  webhookURL: "https://example.com/webhook",
);

PaytmModel dummyPaytmModel = PaytmModel(
  paytmMID: "MID1234567890123456",
  pAYTMMERCHANTKEY: "TESTMERCHANTKEY1234",
  isEnabled: true,
  isSandboxEnabled: true,
);

RazorPayModel dummyRazorPayModel = RazorPayModel(
  razorpaySecret: "rzp_test_1234567890abcdef1234",
  isWithdrawEnabled: true,
  isSandboxEnabled: true,
  isEnabled: true,
  razorpayKey: "rzp_test_1234567890abcdef",
);

MidTrans dummyMidTrans = MidTrans(
  enable: true,
  name: "MidTrans Payment Gateway",
  isSandbox: true,
  serverKey: "sb-MidTrans-1234567890abcdef",
  image: "https://example.com/midtrans-logo.png",
);

OrangeMoney dummyOrangeMoney = OrangeMoney(
  image: "https://example.com/orange-money-logo.png",
  clientId: "client-123456",
  auth: "Bearer token1234567890abcdef",
  enable: true,
  name: "Orange Money Payment Gateway",
  notifyUrl: "https://example.com/notify",
  clientSecret: "client-secret-key12345",
  isSandbox: true,
  returnUrl: "https://example.com/return",
  merchantKey: "merchant-key-9876543210",
  cancelUrl: "https://example.com/cancel",
  notifUrl: "https://example.com/notification",
);

Xendit dummyXendit = Xendit(
  name: "Xendit Payment Gateway",
  enable: true,
  apiKey: "xendit-api-key-abcdef123456",
  isSandbox: true,
  image: "https://example.com/xendit-logo.png",
);
