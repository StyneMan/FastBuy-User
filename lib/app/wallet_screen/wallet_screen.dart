import 'package:customer/app/auth_screen/login_screen.dart';
import 'package:customer/app/wallet_screen/payment_list_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/controllers/wallet_controller.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/widget/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final _profileController = Get.find<MyProfileController>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: WalletController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surfaceDark
                : AppThemeData.surface,
            body: controller.isLoading.value
                ? Constant.loader()
                : _profileController.userData.value.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/login.gif",
                              height: 120,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Please Log In to Continue".tr,
                              style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey100
                                      : AppThemeData.grey800,
                                  fontSize: 22,
                                  fontFamily: AppThemeData.semiBold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "You’re not logged in. Please sign in to access your account and explore all features."
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey500,
                                  fontSize: 16,
                                  fontFamily: AppThemeData.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RoundedButtonFill(
                              title: "Log in".tr,
                              width: 55,
                              height: 5.5,
                              color: AppThemeData.primary300,
                              textColor: AppThemeData.grey50,
                              onPress: () async {
                                Get.offAll(LoginScreen());
                              },
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).viewPadding.top),
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "My Wallet".tr,
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey50
                                                    : AppThemeData.grey900,
                                                fontFamily:
                                                    AppThemeData.semiBold,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "Keep track of your balance, transactions, and payment methods all in one place."
                                                  .tr,
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey50
                                                    : AppThemeData.grey900,
                                                fontFamily:
                                                    AppThemeData.regular,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: AppThemeData.secondary300,
                                      // image: DecorationImage(
                                      //     image: AssetImage(
                                      //         "assets/images/wallet.png"),
                                      //     fit: BoxFit.fill),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 20,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "My Wallet".tr,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.primary100
                                                  : AppThemeData.primary100,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: AppThemeData.regular,
                                            ),
                                          ),
                                          Text(
                                            "₦${Constant.formatNumber(controller.userWallet.value['balance'] ?? 0.0)}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey50
                                                  : AppThemeData.grey50,
                                              fontSize: 40,
                                              overflow: TextOverflow.ellipsis,
                                              // fontFamily: AppThemeData.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 80,
                                            ),
                                            child: RoundedButtonFill(
                                              title: "Top up".tr,
                                              color: AppThemeData.warning300,
                                              textColor: AppThemeData.grey900,
                                              onPress: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return PaymentListScreen();
                                                  },
                                                );
                                                // topupWalletBottomSheet(
                                                //   context,
                                                //   controller,
                                                // );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // controller.walletTransactionList.isEmpty
                            Expanded(
                              child: controller.walletTransactions.value['data']
                                          ?.length <
                                      1
                                  ? Constant.showEmptyView(
                                      message: "No transactions found".tr)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: controller.walletTransactions
                                            .value['data'].length,
                                        itemBuilder: (context, index) {
                                          // WalletTransactionModel
                                          //     walletTractionModel = controller
                                          //         .walletTransactionList[index];
                                          final item = controller
                                              .walletTransactions
                                              .value['data'][index];
                                          return transactionCard(
                                            controller,
                                            themeChange,
                                            item,
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
          );
        });
  }

  transactionCard(WalletController controller, themeChange, var item) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            // await FireStoreUtils.getOrderByOrderId(transactionModel.orderId.toString()).then(
            //   (value) {
            //     if (value != null) {
            //       Get.to(const OrderDetailsScreen(), arguments: {"orderModel": value});
            //     }
            //   },
            // );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1,
                          color: themeChange.getThem()
                              ? AppThemeData.grey800
                              : AppThemeData.grey100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: item['transaction_type'] == 'credit'
                        ? SvgPicture.asset(
                            "assets/icons/ic_credit.svg",
                            height: 16,
                            width: 16,
                          )
                        : SvgPicture.asset(
                            "assets/icons/ic_debit.svg",
                            height: 16,
                            width: 16,
                          ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item['summary']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: AppThemeData.semiBold,
                                    fontWeight: FontWeight.w600,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey100
                                        : AppThemeData.grey800,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy hh:mm a').format(
                                    DateTime.parse(
                                      item['created_at'],
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: AppThemeData.semiBold,
                                    fontWeight: FontWeight.w600,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey100
                                        : AppThemeData.grey800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "₦${Constant.formatNumber(item['amount'])}",
                            style: TextStyle(
                              fontSize: 16,
                              color: item['transaction_type'] == 'credit'
                                  ? AppThemeData.success400
                                  : AppThemeData.danger300,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "",
                        // Constant.timestampToDateTime(transactionModel.date!),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: AppThemeData.medium,
                          fontWeight: FontWeight.w500,
                          color: themeChange.getThem()
                              ? AppThemeData.grey200
                              : AppThemeData.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: MySeparator(
            color: themeChange.getThem()
                ? AppThemeData.grey700
                : AppThemeData.grey200,
          ),
        ),
      ],
    );
  }
}

enum PaymentGateway {
  payFast,
  mercadoPago,
  paypal,
  stripe,
  flutterWave,
  payStack,
  paytm,
  razorpay,
  cod,
  wallet,
  midTrans,
  orangeMoney,
  xendit
}
