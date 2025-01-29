import 'package:customer/models/gift_cards_order_model.dart';
import 'package:get/get.dart';

class HistoryGiftCardController extends GetxController {
  RxList<GiftCardsOrderModel> giftCardsOrderList = <GiftCardsOrderModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    // await FireStoreUtils.getGiftHistory().then((value) {
    //   giftCardsOrderList.value = value;
    // });
    // isLoading.value = false;
  }

  updateList(int index) {
    GiftCardsOrderModel giftCardsOrderModel = giftCardsOrderList[index];
    giftCardsOrderModel.isPasswordShow =
        giftCardsOrderModel.isPasswordShow == true ? false : true;

    giftCardsOrderList.removeAt(index);
    giftCardsOrderList.insert(index, giftCardsOrderModel);
  }

  // Future<void> share(String giftCode, String giftPin, String msg, String amount, Timestamp date) async {
  //   await Share.share(
  //     "Gift Code : $giftCode\nGift Pin : $giftPin\nPrice : ${Constant.amountShow(amount: amount)}\nExpire Date : ${date.toDate()}\n\nMessage : $msg",
  //   );
  // }
}
