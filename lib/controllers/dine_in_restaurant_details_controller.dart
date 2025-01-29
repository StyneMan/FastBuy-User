// import 'dart:async';

// import 'package:customer/constant/constant.dart';
// import 'package:customer/models/favourite_model.dart';
// import 'package:customer/models/vendor_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class DineInRestaurantDetailsController extends GetxController {
//   Rx<TextEditingController> searchEditingController =
//       TextEditingController().obs;

//   Rx<TextEditingController> additionRequestController =
//       TextEditingController().obs;

//   RxBool isLoading = true.obs;
//   RxBool firstVisit = false.obs;
//   Rx<PageController> pageController = PageController().obs;
//   RxInt currentPage = 0.obs;
//   RxInt noOfQuantity = 1.obs;

//   RxList<FavouriteModel> favouriteList = <FavouriteModel>[].obs;
//   RxList tags = [].obs;

//   List occasionList = ["Birthday", "Anniversary"];
//   RxString selectedOccasion = "".obs;

//   RxList<TimeModel> timeSlotList = <TimeModel>[].obs;

//   // Rx<Timestamp> selectedDate = Timestamp.now().obs;
//   RxString selectedTimeSlot = '6:00 PM'.obs;

//   RxString selectedTimeDiscount = '0'.obs;
//   RxString selectedTimeDiscountType = ''.obs;

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     getArgument();
//     // getRecord();
//     super.onInit();
//   }

//   void animateSlider() {
//     if (vendorModel.value.photos != null &&
//         vendorModel.value.photos!.isNotEmpty) {
//       Timer.periodic(const Duration(seconds: 2), (Timer timer) {
//         if (currentPage < vendorModel.value.photos!.length) {
//           currentPage++;
//         } else {
//           currentPage.value = 0;
//         }

//         if (pageController.value.hasClients) {
//           pageController.value.animateToPage(
//             currentPage.value,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeIn,
//           );
//         }
//       });
//     }
//   }

//   Rx<VendorModel> vendorModel = VendorModel().obs;

//   getArgument() async {
//     dynamic argumentData = Get.arguments;
//     if (argumentData != null) {
//       vendorModel.value = argumentData['vendorModel'];
//     }
//     animateSlider();
//     // statusCheck();
//     isLoading.value = false;
//     await getFavouriteList();

//     update();
//   }

//   getFavouriteList() async {
//     if (Constant.userModel != null) {
//     //   await FireStoreUtils.getFavouriteRestaurant().then(
//     //     (value) {
//     //       favouriteList.value = value;
//     //     },
//     //   );
//     // }

//     // await FireStoreUtils.getVendorCuisines(vendorModel.value.id.toString())
//     //     .then(
//     //   (value) {
//     //     tags.value = value;
//     //   },
//     // );
//     // update();
//   }

//   RxBool isOpen = false.obs;

//   statusCheck() {
//     final now = DateTime.now();
//     var day = DateFormat('EEEE', 'en_US').format(now);
//     var date = DateFormat('dd-MM-yyyy').format(now);
//     for (var element in vendorModel.value.workingHours!) {
//       if (day == element.day.toString()) {
//         if (element.timeslot!.isNotEmpty) {
//           for (var element in element.timeslot!) {
//             var start =
//                 DateFormat("dd-MM-yyyy HH:mm").parse("$date ${element.from}");
//             var end =
//                 DateFormat("dd-MM-yyyy HH:mm").parse("$date ${element.to}");
//             // if (isCurrentDateInRange(start, end)) {
//             //   isOpen.value = true;
//             // }
//           }
//         }
//       }
//     }
//   }

//   bool isCurrentDateInRangeDineIn(
//       DateTime startDate, DateTime endDate, DateTime selected) {
//     return selected.isAtSameMomentAs(startDate) ||
//         selected.isAtSameMomentAs(endDate) ||
//         selected.isAfter(startDate) && selected.isBefore(endDate);
//   }

//   bool isCurrentDateInRange(DateTime startDate, DateTime endDate) {
//     final currentDate = DateTime.now();
//     return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
//   }
// }

// // class TimeModel {
// //   DateTime? time;
// //   String? discountPer;
// //   String? discountType;

// //   TimeModel(
// //       {required this.time,
// //       required this.discountPer,
// //       required this.discountType});
// // }
