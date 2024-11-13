import 'package:customer/constant/constant.dart';
import 'package:customer/data/dummy_product.dart';
import 'package:customer/models/favourite_item_model.dart';
import 'package:customer/models/favourite_model.dart';
import 'package:customer/models/product_model.dart';
import 'package:customer/models/vendor_model.dart';
import 'package:get/get.dart';

import '../data/dummy_vendor.dart';

class FavouriteController extends GetxController {
  RxBool favouriteRestaurant = true.obs;
  RxList<FavouriteModel> favouriteList = <FavouriteModel>[].obs;
  RxList<VendorModel> favouriteVendorList = <VendorModel>[].obs;

  RxList<FavouriteItemModel> favouriteItemList = <FavouriteItemModel>[].obs;
  RxList<ProductModel> favouriteFoodList = <ProductModel>[].obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  getData() async {
    if (Constant.userModel != null) {
      favouriteList.value = [
        FavouriteModel(restaurantId: "restaurant_001", userId: "user_001"),
        FavouriteModel(restaurantId: "restaurant_002", userId: "user_001"),
        FavouriteModel(restaurantId: "restaurant_003", userId: "user_001"),
      ];

      favouriteItemList.value = [
        FavouriteItemModel(
            storeId: "store_123", userId: "user_001", productId: "product_abc"),
        FavouriteItemModel(
            storeId: "store_456", userId: "user_002", productId: "product_xyz"),
        FavouriteItemModel(
            storeId: "store_789", userId: "user_003", productId: "product_lmn"),
      ];

      // await FireStoreUtils.getFavouriteRestaurant().then(
      //   (value) {
      //     favouriteList.value = value;
      //   },
      // );

      favouriteVendorList.value = [dummyVendor];
      favouriteFoodList.value = dummyProducts;

      // await FireStoreUtils.getFavouriteItem().then(
      //   (value) {
      //     favouriteItemList.value = value;
      //   },
      // );

      // for (var element in favouriteList) {
      //   await FireStoreUtils.getVendorById(element.restaurantId.toString())
      //       .then(
      //     (value) {
      //       if (value != null) {
      //         favouriteVendorList.add(value);
      //       }
      //     },
      //   );
      // }

      // for (var element in favouriteItemList) {
      //   await FireStoreUtils.getProductById(element.productId.toString()).then(
      //     (value) {
      //       if (value != null) {
      //         favouriteFoodList.add(value);
      //       }
      //     },
      //   );
      // }
    }

    isLoading.value = false;
  }
}
