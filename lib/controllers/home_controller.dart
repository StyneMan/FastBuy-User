import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/dash_board_controller.dart';
import 'package:customer/data/dummy_banners.dart';
import 'package:customer/data/dummy_vendor_category.dart';
import 'package:customer/models/BannerModel.dart';
import 'package:customer/models/favourite_model.dart';
import 'package:customer/models/coupon_model.dart';
import 'package:customer/models/story_model.dart';
import 'package:customer/models/vendor_category_model.dart';
import 'package:customer/models/vendor_model.dart';
import 'package:customer/services/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  DashBoardController dashBoardController = Get.find<DashBoardController>();
  final CartProvider cartProvider = CartProvider();

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
  RxList<VendorModel> couponRestaurantList = <VendorModel>[].obs;
  RxList<CouponModel> couponList = <CouponModel>[].obs;

  RxList<StoryModel> storyList = <StoryModel>[].obs;
  RxList<BannerModel> bannerModel = <BannerModel>[].obs;
  RxList<BannerModel> bannerBottomModel = <BannerModel>[].obs;

  RxList<FavouriteModel> favouriteList = <FavouriteModel>[].obs;

  getData() async {
    isLoading.value = true;
    // getCartData();
    // selectedOrderTypeValue.value = Preferences.getString(Preferences.foodDeliveryType, defaultValue: "Delivery".tr).tr;
    // await getZone();
    // allNearestRestaurant.value = [dummyVendor];
    // newArrivalRestaurantList.value = [dummyVendor];
    // popularRestaurantList.value = [dummyVendor];
    // couponRestaurantList.value = [dummyVendor];
    bannerModel.value = bannerModels;
    bannerBottomModel.value = bannerModels;

    favouriteList.value = [
      FavouriteModel(restaurantId: "restaurant_001", userId: "user_001"),
      FavouriteModel(restaurantId: "restaurant_002", userId: "user_001"),
      FavouriteModel(restaurantId: "restaurant_003", userId: "user_001"),
    ];

    // couponList.value = dummyCouponModels;

    vendorCategoryModel.value = vendorCategories;
    // FireStoreUtils.getAllNearestRestaurant().listen((event) async {
    // popularRestaurantList.clear();
    // newArrivalRestaurantList.clear();
    // allNearestRestaurant.clear();

    // allNearestRestaurant.addAll(event);
    // newArrivalRestaurantList.addAll(event);
    // popularRestaurantList.addAll(event);

    // popularRestaurantList.sort(
    //   (a, b) => Constant.calculateReview(
    //           reviewCount: b.reviewsCount.toString(),
    //           reviewSum: b.reviewsSum.toString())
    //       .compareTo(Constant.calculateReview(
    //           reviewCount: a.reviewsCount.toString(),
    //           reviewSum: a.reviewsSum.toString())),
    // );

    // newArrivalRestaurantList.sort(
    //   (a, b) => (b.createdAt ?? Timestamp.now())
    //       .toDate()
    //       .compareTo((a.createdAt ?? Timestamp.now()).toDate()),
    // );

    // await FireStoreUtils.getHomeCoupon().then(
    //   (value) {
    //     couponRestaurantList.clear();
    //     couponList.clear();
    //     for (var element1 in value) {
    //       for (var element in allNearestRestaurant) {
    //         if (element1.resturantId == element.id &&
    //             element1.expiresAt!.toDate().isAfter(DateTime.now())) {
    //           couponList.add(element1);
    //           couponRestaurantList.add(element);
    //         }
    //       }
    //     }
    //   },
    // );

    // // await FireStoreUtils.getStory().then((value) {
    //   storyList.clear();
    //   for (var element1 in value) {
    //     for (var element in allNearestRestaurant) {
    //       if (element1.vendorID == element.id) {
    //         storyList.add(element1);
    //       }
    //     }
    //   }
    // });

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
