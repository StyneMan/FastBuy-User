import 'dart:async';
import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/services/interceptors/api_interceptors.dart';
import 'package:customer/services/interceptors/token_retry.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class APIService {
  http.Client client = InterceptedClient.build(
    interceptors: [
      MyApiInterceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  APIService() {
    // init();
  }

  final StreamController<http.Response> _streamController =
      StreamController<http.Response>();

  Future<http.Response> signup(Map body) async {
    return await http.post(
      Uri.parse('${Constant.baseURL}/auth/customer/signup'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> login(Map body) async {
    return await http.post(
      Uri.parse('${Constant.baseURL}/auth/customer/login'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> loginPhone(Map body) async {
    return await http.post(
      Uri.parse('${Constant.baseURL}/auth/customer/login/phone'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> checkInternet() async {
    return await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos/1'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> forgotPass(Map body) async {
    return await http.post(
      Uri.parse('${Constant.baseURL}/auth/customer/forgotPassword'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> verifyOTP({required Map body}) async {
    return await http.post(
      Uri.parse('${Constant.baseURL}/auth/customer/verifyOTP'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> verifPhoneOTP({required Map body}) async {
    return await http.post(
      Uri.parse('${Constant.baseURL}/auth/customer/phone/verifyOTP'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> sendOTP({required Map body}) async {
    return await http.post(
      Uri.parse('${Constant.baseURL}/auth/customer/sendOTP'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resetPassword({required Map body}) async {
    return await http.post(
      Uri.parse('${Constant.baseURL}/auth/customer/resetPassword'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Stream<http.Response> getProfileStreamed({
    required String accessToken,
  }) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constant.baseURL}/customer/current/profile'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> getProfile({required String accessToken}) async {
    return await client.get(
      Uri.parse('${Constant.baseURL}/customer/current/profile'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Future<http.Response> updateProfile(
      {required String accessToken, required Map payload}) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/customer/profile/update'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> imagesUploader(
      {required String accessToken, required Map payload}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/images/upload'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  // Stream<http.Response> getNotificationsStreamed(
  //     {required int page, required String accessToken}) async* {
  //   try {
  //     // Fetch data and add it to the stream
  //     http.Response response = await client.get(
  //       Uri.parse('${Constants.baseURL}/api/v1/users/notifications?page=$page'),
  //       headers: {
  //         "Content-type": "application/json",
  //         "Authorization": "Bearer $accessToken",
  //       },
  //     );
  //     yield response; // Yield the response to the stream
  //   } catch (error) {
  //     // Handle errors by adding an error to the stream
  //     _streamController.addError(error);
  //   }
  // }

  // Future<http.Response> getNotifications(
  //     {required int page, required String accessToken}) async {
  //   return await client.get(
  //     Uri.parse('${Constants.baseURL}/api/v1/users/notifications?page=$page'),
  //     headers: {
  //       "Content-type": "application/json",
  //       "Authorization": "Bearer $accessToken",
  //     },
  //   );
  // }

  Future<http.Response> saveShippingAddress(
      {required String accessToken, required Map body}) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/customer/address/add'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
  }

  Stream<http.Response> getShippingAdressesStreamed(
      {required String accessToken,
      required String customerId,
      required int page}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constant.baseURL}/customer/address/all'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> updateShippingAddress(
      {required String accessToken,
      required String addressId,
      required Map body}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/address/$addressId/update'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> setDefaultShippingAddress(
      {required String accessToken, required String addressId}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/address/$addressId/setDefault'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Future<http.Response> deleteShippingAddress(
      {required String accessToken, required String addressId}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/address/$addressId/delete'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Future<http.Response> getLegals() async {
    return await client.get(
      Uri.parse('${Constant.baseURL}/settings/legals'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> getVendors(
      {required String accessToken,
      required int page,
      String? vendorType}) async {
    if (vendorType == null || vendorType.isEmpty) {
      return await client.get(
        Uri.parse('${Constant.baseURL}/vendor/locations?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    } else {
      return await client.get(
        Uri.parse(
            '${Constant.baseURL}/vendor/locations?page=$page&type=$vendorType'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
    }
  }

  Future<http.Response> getNearbyVendors({
    required int page,
    required Map payload,
  }) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/vendor/nearby?page=$page'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> estimateParcelFare(
      {required String accessToken, required Map payload}) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/orders/logistics/estimate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> estimateDeliveryFare(
      {required String accessToken, required Map payload}) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/orders/delivery/estimate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> getPaymentGateways() async {
    return await client.get(
      Uri.parse('${Constant.baseURL}/settings/payment/gateways'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> getVendorCategories({required String vendorId}) async {
    return await http.get(
      Uri.parse('${Constant.baseURL}/vendor/$vendorId/categories'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> getVendorLocationProducts(
      {required String branchId, required int page, String? categoryId}) async {
    if (categoryId != null) {
      return await http.get(
        Uri.parse(
            '${Constant.baseURL}/products/branch/$branchId/all?page=$page&categoryId=$categoryId'),
        headers: {
          "Content-type": "application/json",
        },
      );
    }
    return await client.get(
      Uri.parse('${Constant.baseURL}/products/branch/$branchId/all?page=$page'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> getPackOptions() async {
    return await http.get(
      Uri.parse('${Constant.baseURL}/settings/pack/all'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> addFavourite(
      {required String accessToken, required String branchId}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/vendor/$branchId/favourite'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Stream<http.Response> getFavouritesStreamed({
    required String accessToken,
    required String customerId,
    required String vendorType,
    required int page,
  }) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse(
            '${Constant.baseURL}/customer/$customerId/favourites?page=$page&type=$vendorType'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Stream<http.Response> getFavouriteListStreamed({
    required String accessToken,
    required String customerId,
  }) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constant.baseURL}/customer/$customerId/favourite/list'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> addToCart(
      {required String accessToken, required Map payload}) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/customer/cart/add'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> reorderToCart(
      {required String accessToken, required Map payload}) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/customer/cart/reorder'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> updateCart(
      {required String accessToken,
      required Map payload,
      required String cartId}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/cart/$cartId/update'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> deleteCart(
      {required String accessToken, required String cartId}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/cart/$cartId/delete'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Future<http.Response> clearAllCartItems(
      {required String accessToken, required String cartId}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/cart/$cartId/clear'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Future<http.Response> removeCartItem(
      {required String accessToken, required String cartItemId}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/cart/item/$cartItemId/delete'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Stream<http.Response> getCartStreamed(
      {required String accessToken,
      required String customerId,
      required int page}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constant.baseURL}/customer/$customerId/carts?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Stream<http.Response> getWalletStreamed({
    required String accessToken,
    required String customerId,
  }) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constant.baseURL}/customer/$customerId/wallet'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Stream<http.Response> getTransactionsStreamed(
      {required String accessToken,
      required String customerId,
      required int page}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse(
            '${Constant.baseURL}/customer/$customerId/transactions?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> initPayment({
    required String accessToken,
    required Map payload,
  }) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/bank/payment/init'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> initPaystack(
      {required String accessToken, required Map payload}) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/bank/payments/paystack/init'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> orderWithCard(
      {required String accessToken, required Map payload}) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/bank/payments/order/card'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> orderWithWallet(
      {required String accessToken, required Map payload}) async {
    return await client.post(
      Uri.parse('${Constant.baseURL}/bank/payments/order/wallet'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> applyCoupon(
      {required String accessToken, required Map payload}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/coupon/apply'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Stream<http.Response> getOrdersStreamed(
      {required String accessToken,
      required String customerId,
      required int page}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constant.baseURL}/customer/$customerId/orders?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Stream<http.Response> getParcelOrdersStreamed(
      {required String accessToken,
      required String customerId,
      required int page}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse(
            '${Constant.baseURL}/customer/$customerId/orders/parcels?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Stream<http.Response> getOrdersInprogressStreamed(
      {required String accessToken,
      required String customerId,
      required int page}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse(
            '${Constant.baseURL}/customer/$customerId/orders/in_progress?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Stream<http.Response> getOrdersDeliveredStreamed(
      {required String accessToken,
      required String customerId,
      required int page}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse(
            '${Constant.baseURL}/customer/$customerId/orders/delivered?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Stream<http.Response> getOrdersCancelledStreamed(
      {required String accessToken,
      required String customerId,
      required int page}) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse(
            '${Constant.baseURL}/customer/$customerId/orders/cancelled?page=$page'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  Future<http.Response> setupWalletPIN(
      {required String accessToken, required Map payload}) async {
    return await client.put(
      Uri.parse('${Constant.baseURL}/customer/wallet/secure'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> searcher({required String key}) async {
    return await http.get(
      Uri.parse('${Constant.baseURL}/customer/search/result?query=$key'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> banners() async {
    return await http.get(
      Uri.parse('${Constant.baseURL}/banner/published'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }
}
