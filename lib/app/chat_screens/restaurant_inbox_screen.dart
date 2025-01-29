import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RestaurantInboxScreen extends StatelessWidget {
  const RestaurantInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeChange.getThem()
            ? AppThemeData.surfaceDark
            : AppThemeData.surface,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Vendor Inbox".tr,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: AppThemeData.medium,
            fontSize: 16,
            color: themeChange.getThem()
                ? AppThemeData.grey50
                : AppThemeData.grey900,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            return ListView.separated(
                itemBuilder: (context, index) => InkWell(
                      onTap: () async {
                        // ShowToastDialog.showLoader("Please wait".tr);

                        // UserModel? customer = await FireStoreUtils.getUserProfile(
                        //     inboxModel.customerId.toString());
                        // UserModel? restaurantUser = await FireStoreUtils.getUserProfile(
                        //     inboxModel.restaurantId.toString());
                        // VendorModel? vendorModel = await FireStoreUtils.getVendorById(
                        //     restaurantUser!.vendorID.toString());
                        // ShowToastDialog.closeLoader();

                        // Get.to(const ChatScreen(), arguments: {
                        //   "customerName": '${customer!.fullName()}',
                        //   "restaurantName": vendorModel!.title,
                        //   "orderId": inboxModel.orderId,
                        //   "restaurantId": restaurantUser.id,
                        //   "customerId": customer.id,
                        //   "customerProfileImage": customer.profilePictureURL,
                        //   "restaurantProfileImage": vendorModel.photo,
                        //   "token": restaurantUser.fcmToken,
                        //   "chatType": inboxModel.chatType,
                        // });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: themeChange.getThem()
                                ? AppThemeData.grey900
                                : AppThemeData.grey50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: NetworkImageWidget(
                                    imageUrl:
                                        "inboxModel.restaurantProfileImage.toString()",
                                    fit: BoxFit.cover,
                                    height: Responsive.height(6, context),
                                    width: Responsive.width(12, context),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "{inboxModel.restaurantName}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppThemeData.semiBold,
                                                fontSize: 16,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey100
                                                    : AppThemeData.grey800,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "24/10/2025",
                                            // Constant.timestampToDate(
                                            //     inboxModel.createdAt!),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: AppThemeData.regular,
                                              fontSize: 16,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey400
                                                  : AppThemeData.grey500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "{inboxModel.lastMessage}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.medium,
                                          fontSize: 14,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey200
                                              : AppThemeData.grey700,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16.0,
                    ),
                itemCount: 1);
          }

          return const Expanded(
            child: Center(
              child: Text('No chats found'),
            ),
          );
        },
      ),
    );
  }
}
