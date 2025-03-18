import 'dart:convert';

import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/payment/MercadoPagoScreen.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/utils/preferences.dart';

import 'package:customer/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_profile_controller.dart';

class WalletController extends GetxController {
  final profileController = Get.find<MyProfileController>();
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreTransactions = false.obs;
  var userWallet = {}.obs;
  var walletTransactions = [].obs;
  Rx<TextEditingController> topUpAmountController = TextEditingController().obs;

  var transactionScrollController = ScrollController();
  RxInt transactionCurrentPage = 1.obs;

  Rx<UserModel> userModel = UserModel().obs;
  RxString selectedPaymentMethod = "".obs;

  @override
  void onInit() {
    getWalletTransaction();
    setupScrollListener();
    super.onInit();
  }

  void setupScrollListener() {
    transactionScrollController.addListener(() async {
      if (transactionScrollController.position.pixels ==
          transactionScrollController.position.maxScrollExtent) {
        debugPrint("Reached end");
        // Constant.toast("REACHED THE END !!!");

        // Prevent multiple calls at once
        if (hasMoreTransactions.value) {
          await loadMoreTransactions();
        }
      }
    });
  }

  Future<void> loadMoreTransactions() async {
    final accessToken = Preferences.getString(Preferences.accessTokenKey);

    if (accessToken.isEmpty) return;

    isLoadingMore.value = true;
    transactionCurrentPage.value = transactionCurrentPage.value + 1;

    try {
      final response = await APIService().getTransactions(
        accessToken: accessToken,
        customerId: profileController.userData.value['id'],
        page: transactionCurrentPage.value, // Next page
      );
      debugPrint("SECOND PAGE PF tRANSACTIONS ::: ${response.body}");
      isLoadingMore.value = false;
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);

        // Append new data to existing list
        walletTransactions.value = [
          ...walletTransactions.value,
          ...map['data']
        ];

        hasMoreTransactions.value = int.parse("${map['totalPages']}") >
                int.parse("${map['currentPage']}")
            ? true
            : false;
        transactionCurrentPage.value = int.parse("${map['currentPage']}");
      }
    } catch (e) {
      debugPrint(e.toString());
      isLoadingMore.value = false;
    } finally {
      isLoadingMore.value = false;
    }
  }

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

              walletTransactions.value = map['data'];
              hasMoreTransactions.value = int.parse("${map['totalPages']}") >
                      int.parse("${map['currentPage']}")
                  ? true
                  : false;
              transactionCurrentPage.value = int.parse("${map['currentPage']}");
            }
          });
        }
      } catch (e) {
        debugPrint("$e");
      }
    }
    isLoading.value = false;
  }

  refreshWallet() async {
    try {
      final accessToken = Preferences.getString(Preferences.accessTokenKey);
      if (accessToken.isNotEmpty) {
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

            walletTransactions.value = map['data'];
            hasMoreTransactions.value = int.parse("${map['totalPages']}") >
                    int.parse("${map['currentPage']}")
                ? true
                : false;
            transactionCurrentPage.value = int.parse("${map['currentPage']}");
          }
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
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
            // ShowToastDialog.showToast("Payment Successful!!");
            // Refresh wallet here
            refreshWallet();
          } else {
            // ShowToastDialog.showToast("Payment UnSuccessful!!");
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

  @override
  void onClose() {
    super.onClose();
    transactionScrollController.dispose();
  }
}
