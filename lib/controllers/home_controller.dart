import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/dash_board_controller.dart';
import 'package:customer/data/dummy_vendor_category.dart';
import 'package:customer/models/BannerModel.dart';
import 'package:customer/models/favourite_model.dart';
import 'package:customer/models/coupon_model.dart';
import 'package:customer/models/story_model.dart';
import 'package:customer/models/vendor_category_model.dart';
import 'package:customer/models/vendor_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/services/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  DashBoardController dashBoardController = Get.put(DashBoardController());
  final CartProvider cartProvider = CartProvider();
  var banners = {}.obs;
  var offers = {}.obs;

  getCartData() async {
    cartProvider.cartStream.listen(
      (event) async {
        cartItem.clear();
        cartItem.addAll(event);
      },
    );
    print("=====>");
    print(cartItem.length);
    update();
  }

  RxBool isLoading = true.obs;
  RxBool isListView = true.obs;
  RxBool isPopular = true.obs;
  RxString selectedOrderTypeValue = "Delivery".tr.obs;

  Rx<PageController> pageController =
      PageController(viewportFraction: 0.877).obs;
  Rx<PageController> pageBottomController =
      PageController(viewportFraction: 0.877).obs;
  RxInt currentPage = 0.obs;
  RxInt currentBottomPage = 0.obs;

  late TabController tabController;

  @override
  void onInit() {
    // TODO: implement onInit
    getVendorCategory();
    getData();
    super.onInit();
  }

  RxList<VendorCategoryModel> vendorCategoryModel = <VendorCategoryModel>[].obs;

  RxList<VendorModel> allNearestRestaurant = <VendorModel>[].obs;
  RxList<VendorModel> newArrivalRestaurantList = <VendorModel>[].obs;
  RxList<VendorModel> popularRestaurantList = <VendorModel>[].obs;
  // RxList<VendorModel> couponRestaurantList = <VendorModel>[].obs;
  RxList<CouponModel> couponList = <CouponModel>[].obs;

  RxList<StoryModel> storyList = <StoryModel>[].obs;
  RxList<BannerModel> bannerModel = <BannerModel>[].obs;
  RxList<BannerModel> bannerBottomModel = <BannerModel>[].obs;

  RxList<FavouriteModel> favouriteList = <FavouriteModel>[].obs;

  getData() async {
    try {
      final resp = await APIService().banners();
      debugPrint("BANNER RESPONSE ::: ${resp.body}");
      if (resp.statusCode >= 200 && resp.statusCode <= 299) {
        final Map<String, dynamic> map = jsonDecode(resp.body);
        // List<Map<String, dynamic>> list =
        //     decodedList.map((item) => item as Map<String, dynamic>).toList();
        banners.value = map;
      }

      // OFFERS :
      final offersResp = await APIService().banners();
      debugPrint("BANNER RESPONSE ::: ${offersResp.body}");
      if (offersResp.statusCode >= 200 && offersResp.statusCode <= 299) {
        final Map<String, dynamic> map = jsonDecode(offersResp.body);
        // List<Map<String, dynamic>> list =
        //     decodedList.map((item) => item as Map<String, dynamic>).toList();
        offers.value = map;
      }
    } catch (e) {
      debugPrint("$e");
    }

    // bannerModel.value = bannerModels;
    // bannerBottomModel.value = bannerModels;

    vendorCategoryModel.value = vendorCategories;

    storyList.value = [
      StoryModel(
        videoThumbnail:
            'https://png.pngtree.com/background/20210717/original/pngtree-elegant-business-template-banner-background-design-with-black-and-yellow-color-picture-image_1424478.jpg',
        videoUrl: [
          'assets/videos/sample_video.mp4',
          'assets/videos/sample_video.mp4',
        ],
        vendorID: 'vendor123',
        // createdAt: Timestamp.now(),
      ),
      StoryModel(
        videoThumbnail:
            'https://www.tjahmusic.com/wp-content/uploads/2014/08/banner-1.jpg',
        videoUrl: [
          'https://example.com/video3.mp4',
          'https://example.com/video4.mp4',
        ],
        vendorID: 'vendor456',
        // createdAt: Timestamp.now(),
      ),
      StoryModel(
        videoThumbnail:
            'https://www.tjahmusic.com/wp-content/uploads/2014/08/banner-1.jpg',
        videoUrl: [
          'https://example.com/video5.mp4',
        ],
        vendorID: 'vendor789',
        // createdAt: Timestamp.now(),
      ),
      StoryModel(
        videoThumbnail:
            'https://www.tjahmusic.com/wp-content/uploads/2014/08/banner-1.jpg',
        videoUrl: [
          'assets/videos/sample_video.mp4',
          'assets/videos/sample_video.mp4',
        ],
        vendorID: 'vendor101',
        // createdAt: Timestamp.now(),
      ),
      StoryModel(
        videoThumbnail:
            'https://www.tjahmusic.com/wp-content/uploads/2014/08/banner-1.jpg',
        videoUrl: [
          'https://example.com/video8.mp4',
        ],
        vendorID: 'vendor102',
        // createdAt: Timestamp.now(),
      ),
    ];
    // });

    update();
    isLoading.value = false;
  }

  getVendorCategory() async {
    // await FireStoreUtils.getHomeVendorCategory().then(
    //   (value) {
    //     // vendorCategoryModel.value = value;
    //   },
    // );

    // await FireStoreUtils.getHomeTopBanner().then(
    //   (value) {
    //     bannerModel.value = value;
    //   },
    // );

    // await FireStoreUtils.getHomeBottomBanner().then(
    //   (value) {
    //     bannerBottomModel.value = value;
    //   },
    // );

    if (Constant.userModel != null) {
      // await FireStoreUtils.getFavouriteRestaurant().then(
      //   (value) {
      //     favouriteList.value = value;
      //   },
      // );
    }
  }

  getZone() async {
    // await FireStoreUtils.getZone().then((value) {
    //   if (value != null) {
    //     for (int i = 0; i < value.length; i++) {
    //       if (Constant.isPointInPolygon(
    //           LatLng(Constant.selectedLocation.location!.latitude ?? 0.0,
    //               Constant.selectedLocation.location!.longitude ?? 0.0),
    //           value[i].area!)) {
    //         Constant.selectedZone = value[i];
    //         Constant.isZoneAvailable = true;
    //         break;
    //       } else {
    //         Constant.selectedZone = value[i];
    //         Constant.isZoneAvailable = false;
    //       }
    //     }
    //   }
    // });
  }
}
