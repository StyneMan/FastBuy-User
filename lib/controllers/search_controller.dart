import 'dart:convert';

import 'package:customer/models/product_model.dart';
import 'package:customer/models/vendor_model.dart';
import 'package:customer/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<VendorModel> vendorList = <VendorModel>[].obs;
  RxList vendorSearchList = [].obs;

  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList productSearchList = [].obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      vendorList.value = argumentData['vendorList'];
    }
    isLoading.value = false;

    for (var element in vendorList) {
      // await FireStoreUtils.getProductByVendorId(element.id.toString()).then(
      //   (value) {
      //     // productList.addAll(value);
      //   },
      // );
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      return;
    }
    try {
      final response = await APIService().searcher(
        key: text,
      );
      debugPrint("RESPONSE HERE ::: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(response.body);
        vendorSearchList.value = map['vendors'];
        productSearchList.value = map['products'];
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  void dispose() {
    vendorSearchList.clear();
    productSearchList.clear();
    super.dispose();
  }
}
