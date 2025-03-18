import 'package:customer/utils/preferences.dart';
import 'package:get/get.dart';

class MyProfileController extends GetxController {
  RxBool isLoading = false.obs;
  var userData = {}.obs;
  var policy = "".obs;
  var terms = "".obs;
  var paymentGateways = [].obs;
  RxDouble ratingVal = 1.0.obs;
  var pendingReviews = {}.obs;

  @override
  void onInit() {
    getThem();
    super.onInit();
  }

  RxString isDarkMode = "Light".obs;
  RxBool isDarkModeSwitch = false.obs;

  getThem() {
    isDarkMode.value = Preferences.getString(Preferences.themKey);
    if (isDarkMode.value == "Dark") {
      isDarkModeSwitch.value = true;
    } else if (isDarkMode.value == "Light") {
      isDarkModeSwitch.value = false;
    } else {
      isDarkModeSwitch.value = false;
    }
    isLoading.value = false;
  }

  setProfile(var profile) {
    userData.value = profile;
  }

  clearProfile() {
    userData.value = {};
  }
}
