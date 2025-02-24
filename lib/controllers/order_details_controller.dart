import 'package:customer/app/chat_screens/chat_screen.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/services/socket/socket_manager.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  final cartController = Get.find<CartController>();

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  var orderModel = {}.obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
    }
    // calculatePrice();
    update();
  }

  RxDouble subTotal = 0.0.obs;
  RxDouble specialDiscountAmount = 0.0.obs;
  RxDouble taxAmount = 0.0.obs;
  RxDouble totalAmount = 0.0.obs;

  initChat() async {
    ShowToastDialog.showLoader(
      "Please wait".tr,
    );
    final socket = SocketManager().socket;
    Map payload = {
      "senderId": cartController.profileController.userData.value['id'],
      "receiverId": orderModel.value['vendor_location']['id'],
      "senderType": "customer",
      "receiverType": "vendor_location",
    };

    socket.emit("joinChat", payload);
    ShowToastDialog.closeLoader();

    Get.to(
      const ChatScreen(),
      arguments: {
        "customerName":
            '${cartController.profileController.userData.value['first_name']} ${cartController.profileController.userData.value['last_name']}',
        "vendorName": orderModel.value['order_type'] == "parcel_order"
            ? "FastBuy Logistics"
            : '${orderModel.value['vendor']['name']} ${orderModel.value['vendor_location']['branch_name']}',
        "orderId": '${orderModel.value['order_id']}',
        "vendorId": orderModel.value['order_type'] == "parcel_order"
            ? ""
            : '${orderModel.value['vendor']['id']}',
        "customerId":
            '${cartController.profileController.userData.value['id']}',
        "customerProfileImage":
            '${cartController.profileController.userData.value['photo_url']}',
        "restaurantProfileImage":
            orderModel.value['order_type'] == "parcel_order"
                ? "https://i.imgur.com/ZmYTJoA.png"
                : '${orderModel.value['vendor']['logo']}',
        "token": "",
        "chatType": "restaurant",
      },
    );
  }

  // calculatePrice() async {
  //   subTotal.value = 0.0;
  //   specialDiscountAmount.value = 0.0;
  //   taxAmount.value = 0.0;
  //   totalAmount.value = 0.0;

  //   for (var element in orderModel.value.products!) {
  //     if (double.parse(element.discountPrice.toString()) <= 0) {
  //       subTotal.value = subTotal.value +
  //           double.parse(element.price.toString()) *
  //               double.parse(element.quantity.toString()) +
  //           (double.parse(element.extrasPrice.toString()) *
  //               double.parse(element.quantity.toString()));
  //     } else {
  //       subTotal.value = subTotal.value +
  //           double.parse(element.discountPrice.toString()) *
  //               double.parse(element.quantity.toString()) +
  //           (double.parse(element.extrasPrice.toString()) *
  //               double.parse(element.quantity.toString()));
  //     }
  //   }

  //   if (orderModel.value.specialDiscount != null &&
  //       orderModel.value.specialDiscount!['special_discount'] != null) {
  //     specialDiscountAmount.value = double.parse(
  //         orderModel.value.specialDiscount!['special_discount'].toString());
  //   }

  //   if (orderModel.value.taxSetting != null) {
  //     for (var element in orderModel.value.taxSetting!) {
  //       taxAmount.value = taxAmount.value +
  //           Constant.calculateTax(
  //               amount: (subTotal.value -
  //                       double.parse(orderModel.value.discount.toString()) -
  //                       specialDiscountAmount.value)
  //                   .toString(),
  //               taxModel: element);
  //     }
  //   }

  //   totalAmount.value = (subTotal.value -
  //           double.parse(orderModel.value.discount.toString()) -
  //           specialDiscountAmount.value) +
  //       taxAmount.value +
  //       double.parse(orderModel.value.deliveryCharge.toString()) +
  //       double.parse(orderModel.value.tipAmount.toString());

  //   isLoading.value = false;
  // }

  // final CartProvider cartProvider = CartProvider();

  // addToCart({required CartProductModel cartProductModel}) {
  //   cartProvider.addToCart(
  //       Get.context!, cartProductModel, cartProductModel.quantity!);
  //   update();
  // }
}
