import 'dart:convert';

import 'package:customer/app/checkout_screens/checkout_screen.dart';
import 'package:customer/app/product_screens/product_list.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/controllers/favourite_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/services/socket/socket_manager.dart';
import 'package:customer/themes/app_them_data.dart';
import 'package:customer/themes/round_button_fill.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class VendorDetail extends StatefulWidget {
  final item;
  const VendorDetail({
    super.key,
    required this.item,
  });

  @override
  State<VendorDetail> createState() => _VendorDetailState();
}

class _VendorDetailState extends State<VendorDetail>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  late Socket socket;
  bool _isTempLiked = false;

  final cartController = Get.find<CartController>();

  @override
  void initState() {
    if (widget.item != null) {
      tabController = TabController(
          length: ((widget.item['vendor']['categories'] ?? [])?.length) + 1,
          vsync: this);
    }
    cartController.isInCart.value = false;
    cartController.currCartItem.value.clear();

    if (cartController.cartData.value.isNotEmpty) {
      if (cartController.cartData.value['data']?.length > 0) {
        // now check if this vendor's product is in cart
        debugPrint("VENDDOR LOCATION ID : ${widget.item['id']}");
        for (var i = 0;
            i < cartController.cartData.value['data']?.length;
            i++) {
          final itemElem = cartController.cartData.value['data'][i];
          debugPrint(
              "CART VENDOR LOCATION ID : ${itemElem['vendor_location']['id']}");

          if (itemElem['vendor_location']['id'] == widget.item['id']) {
            setState(() {
              cartController.isInCart.value = true;
              cartController.currCartItem.value = itemElem;
            });
            break;
          } else {
            setState(() {
              cartController.isInCart.value = false;
            });
          }
        }
      }
    }

    super.initState();
    initSocketIO();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Constant.toast("DID CHANGE !!!");

    if (cartController.cartData.value.isNotEmpty) {
      if (cartController.cartData.value['data']?.length > 0) {
        // now check if this vendor's product is in cart
        debugPrint("VENDDOR LOCATION ID : ${widget.item['id']}");
        for (var i = 0;
            i < cartController.cartData.value['data']?.length;
            i++) {
          final itemElem = cartController.cartData.value['data'][i];
          debugPrint(
              "CART VENDOR LOCATION ID : ${itemElem['vendor_location']['id']}");

          if (itemElem['vendor_location']['id'] == widget.item['id']) {
            setState(() {
              cartController.isInCart.value = true;
              cartController.currCartItem.value = itemElem;
            });
            break;
          } else {
            setState(() {
              cartController.isInCart.value = false;
            });
          }
        }
      }
    }
  }

  initSocketIO() {
    socket = SocketManager().socket;
    // socket.emit("cart", "CART INITIALIZED FROM CLIENT ::: ");
    // socket.on("notification", (val) {
    //   debugPrint("USER-CONNECTED :: :: $val");
    // });

    socket.on(
      "cart-add",
      (data) {
        debugPrint("FROM SERVER ::: $data");
      },
    );

    // socket.on(
    //   "notification",
    //   (data) {
    //     debugPrint("FROM SERVER ::: $data");
    //   },
    // );
    // final snackBar = SnackBar(
    //   content: Text('This is a long duration SnackBar!'),
    //   duration: Duration(seconds: 10), // Set the desired duration
    //   action: SnackBarAction(
    //     label: 'Dismiss',
    //     onPressed: () {
    //       // Optional: Perform an action on dismiss
    //     },
    //   ),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final categories = (widget.item['vendor']['categories'] ?? []) as List;
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          themeChange.getThem() ? Colors.transparent : const Color(0xFFFAF6F1),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: themeChange.getThem()
            ? Colors.transparent
            : const Color(0xFFFAF6F1),
      ),
      body: ListView(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.275,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  image: DecorationImage(
                    image: NetworkImage("${widget.item['vendor']['cover']}"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -24,
                left: 16,
                child: ClipOval(
                  child: Container(
                    color: Colors.white,
                    child: Image.network(
                      '${widget.item['vendor']['logo']}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetX(
                    init: FavouriteController(),
                    builder: (controller) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.item['vendor']['name']} ${widget.item['branch_name']}"
                                  .tr,
                              style: TextStyle(
                                fontSize: 18,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                                fontFamily: AppThemeData.regular,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          IconButton(
                            onPressed: () async {
                              try {
                                // Persist UI first
                                if (_isTempLiked) {
                                  setState(() {
                                    _isTempLiked = false;
                                  });
                                } else {
                                  setState(() {
                                    _isTempLiked = true;
                                  });
                                }
                                // ShowToastDialog.showLoader(
                                //     "Please wait".tr);
                                final String accessToken =
                                    Preferences.getString(
                                        Preferences.accessTokenKey);
                                final resp = await APIService().addFavourite(
                                  accessToken: accessToken,
                                  branchId: widget.item['id'],
                                );
                                ShowToastDialog.closeLoader();
                                debugPrint(
                                    "FAVOURITE RESPONSE ::: ${resp.body}");
                                if (resp.statusCode >= 200 &&
                                    resp.statusCode <= 299) {
                                  Map<String, dynamic> map =
                                      jsonDecode(resp.body);
                                  controller.refreshData();
                                }
                              } catch (e) {
                                debugPrint("$e");
                                ShowToastDialog.closeLoader();
                              }
                            },
                            icon: (controller.favouriteList.value.isNotEmpty
                                            ? controller
                                                .favouriteList.value['data']
                                            : [])
                                        ?.where((p0) =>
                                            p0['branchId'] == widget.item['id'])
                                        .isNotEmpty ||
                                    _isTempLiked
                                ? SvgPicture.asset(
                                    "assets/icons/ic_like_fill.svg",
                                  )
                                : SvgPicture.asset(
                                    "assets/icons/ic_like.svg",
                                  ),
                          ),
                        ],
                      );
                    }),
                Text(
                  "${widget.item['street']}, ${widget.item['city']}. ${widget.item['region']}"
                      .tr,
                  style: TextStyle(
                    fontSize: 13,
                    color: themeChange.getThem()
                        ? AppThemeData.grey50
                        : AppThemeData.grey900,
                    fontFamily: AppThemeData.regular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                widget.item['vendor']['business_schedule'] == null
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Opening Time".tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Mon - Fri: ${widget.item['vendor']['business_schedule']['mon_fri']['opening_time']} - ${widget.item['business_schedule']['mon_fri']['closing_time']}"
                                      .tr,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Sat: ${widget.item['business_schedule']['sat']['closed'] ? "Closed" : "${widget.item['business_schedule']['sat']['opening_time']} - ${widget.item['business_schedule']['sat']['closing_time']}"}"
                                      .tr,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                    fontFamily: AppThemeData.regular,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RatingBarIndicator(
                                rating: widget.item['rating'] ??
                                    1.0, // rating value (can be dynamic)
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5, // total number of stars
                                itemSize: 16.0, // size of the stars
                                direction:
                                    Axis.horizontal, // direction of the stars
                              ),
                              Text(
                                "0 reviews".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey900,
                                  fontFamily: AppThemeData.regular,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                const SizedBox(width: 16.0),
                const Divider(),
                const SizedBox(width: 16.0),
                Column(
                  children: [
                    categories.isEmpty
                        ? const SizedBox()
                        : TabBar(
                            controller: tabController,
                            isScrollable: true,
                            unselectedLabelColor: themeChange.getThem()
                                ? AppThemeData.grey500
                                : AppThemeData.grey500,
                            labelColor: themeChange.getThem()
                                ? AppThemeData.grey50
                                : AppThemeData.grey900,
                            tabs: [
                              const Tab(
                                text:
                                    "All", // "All" tab is hardcoded as the first tab
                              ),
                              ...categories.map(
                                (category) => Tab(
                                  text:
                                      "${category['name']}", // Dynamically generated category tabs
                                ),
                              ),
                            ],
                            indicatorSize: TabBarIndicatorSize.tab,
                          ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          ProductList(
                            branchId: widget.item['id'],
                            categoryId: null,
                          ),
                          // Content for each category tab
                          ...categories.map(
                            (category) => Center(
                              child: ProductList(
                                branchId: widget.item['id'],
                                categoryId: category['id'],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => cartController.isInCart.value
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 17,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: RoundedButtonFill(
                    title: "Proceed to Checkout".tr,
                    height: 5.5,
                    color: AppThemeData.primary300,
                    fontSizes: 16,
                    onPress: () async {
                      Get.to(
                        CheckoutScreen(
                          cart: cartController.currCartItem,
                        ),
                        transition: Transition.cupertino,
                      );
                    },
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
