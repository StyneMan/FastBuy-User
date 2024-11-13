import 'package:customer/models/on_boarding_model.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onBoardingList.length - 1;
  var pageController = PageController();

  @override
  void onInit() {
    getOnBoardingData();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<OnBoardingModel> onBoardingList = <OnBoardingModel>[].obs;

  getOnBoardingData() async {
    // await FireStoreUtils.getOnBoardingList().then((value) {
    //   onBoardingList.value = value;
    // });
    onBoardingList.add(OnBoardingModel(
        id: "1",
        title: "Discover Restaurants Near You",
        description:
            "Explore new flavors and favorite cuisines, all just a few taps away.",
        image: "assets/images/image_1.png"));
    onBoardingList.add(OnBoardingModel(
        id: "2",
        title: "Grocery Stores",
        description:
            "Browse and buy products from nearby grocery stores and get them delivered right to your home, hassle-free",
        image: "assets/images/image_2.png"));
    onBoardingList.add(OnBoardingModel(
        id: "3",
        title: "Send Package",
        description:
            "Our fast and secure delivery service is here to make your day simpler",
        image: "assets/images/image_3.png"));

    isLoading.value = false;
    update();
  }
}
