import 'dart:convert';

import 'package:customer/app/favourite_screens/favourite_screen.dart';
import 'package:customer/app/home_screen/home_screen.dart';
import 'package:customer/app/home_screen/home_screen_two.dart';
import 'package:customer/app/order_list_screen/order_screen.dart';
import 'package:customer/app/profile_screen/profile_screen.dart';
import 'package:customer/app/wallet_screen/wallet_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/address_list_controller.dart';
import 'package:customer/controllers/cart_controller.dart';
import 'package:customer/controllers/favourite_controller.dart';
import 'package:customer/controllers/my_profile_controller.dart';
import 'package:customer/controllers/order_controller.dart';
import 'package:customer/controllers/vendors_controller.dart';
import 'package:customer/controllers/wallet_controller.dart';
import 'package:customer/services/api_service.dart';
import 'package:customer/services/notification_service.dart';
import 'package:customer/services/socket/socket_manager.dart';
import 'package:customer/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DashBoardController extends GetxController {
  final profileController = Get.find<MyProfileController>();
  final vendorController = Get.put(VendorsController());
  final favouriteController = Get.put(FavouriteController());
  final cartController = Get.put(CartController());
  final walletController = Get.put(WalletController());
  final shippingAddressController = Get.put(AddressListController());
  final orderController = Get.put(OrderController());

  RxInt selectedIndex = 0.obs;

  RxList pageList = [].obs;

  @override
  void onInit() {
    getPackOptions();
    getData();

    debugPrint("PROFILE L::: ${profileController.userData.value}");

    if (Constant.theme == "theme_2") {
      if (Constant.walletSetting == false) {
        pageList.value = [
          HomeScreen(),
          FavouriteScreen(),
          OrderScreen(),
          const ProfileScreen(),
        ];
      } else {
        pageList.value = [
          HomeScreen(),
          FavouriteScreen(),
          WalletScreen(),
          OrderScreen(),
          const ProfileScreen(),
        ];
      }
    } else {
      if (Constant.walletSetting == false) {
        pageList.value = [
          HomeScreenTwo(),
          FavouriteScreen(),
          OrderScreen(),
          const ProfileScreen(),
        ];
      } else {
        pageList.value = [
          HomeScreenTwo(),
          FavouriteScreen(),
          WalletScreen(),
          OrderScreen(),
          const ProfileScreen(),
        ];
      }
    }
    super.onInit();
  }

  getPackOptions() async {
    try {
      final packResp = await APIService().getPackOptions();
      debugPrint("PACK OPTION RESPONSE HERE ::: ${packResp.body}");
      if (packResp.statusCode >= 200 && packResp.statusCode <= 299) {
        List<Map<String, dynamic>> list = jsonDecode(packResp.body);
        vendorController.packOptions.value = list as List;
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  getData() async {
    final accessToken = Preferences.getString(Preferences.accessTokenKey);
    if (accessToken.isNotEmpty) {
      try {
        final socket = SocketManager().socket;
        Map payload = {
          "userId": profileController.userData.value['id'],
          "userType": "customer",
        };

        socket.onConnect((data) {
          debugPrint('Connected ID RELOAD: $data');
        });
        socket.on("handshake", (data) {
          debugPrint("FROM NESTJS :: $data");
          // now reconnect to servr her
          try {
            socket.emit("register", payload);
          } catch (e) {
            debugPrint("REconnection Error:: $e");
          }
        });
        socket.emit("register", payload);

        // Listen for notification events
        socket.on('notification', (data) {
          print('Notification received: $data');
          AppNotificationService.showNotification(
            title: data['title'] ?? 'New Notification',
            body: data['message'] ?? 'You have a new message!',
          );
        });

        socket.on(
          "refresh-cart",
          (data) {
            // debugPrint("REFRESH  CART HERE >> $data");
            // Constant.toast("REFRESH CART HERE :: ");
            APIService()
                .getCartStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              // debugPrint("MY SHOPPING CART :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                cartController.cartData.value = map;
              }
            });
          },
        );

        socket.on(
          "refresh-shipping-address",
          (data) {
            // debugPrint("REFRESH  CART HERE >> $data");
            // Constant.toast("REFRESH CART HERE :: ");
            APIService()
                .getShippingAdressesStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              // debugPrint("MY SHOPPING CART :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                shippingAddressController.shippingAddresses.value = map;
              }
            });
          },
        );

        socket.on(
          "refresh-favourites",
          (data) {
            // debugPrint("REFRESH  FAVS HERE >> $data");
            // Constant.toast("REFRESH CART HERE :: ");
            APIService()
                .getFavouritesStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              vendorType: "restaurant",
              page: 1,
            )
                .listen((onData) {
              // debugPrint("RESTAURANT FAVOURITES :: ${onData.body}");
              favouriteController.isLoading.value = false;
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                favouriteController.favouriteRestaurants.value = map;
              }
            });

            APIService()
                .getFavouritesStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              vendorType: "grocery_store",
              page: 1,
            )
                .listen((onData) {
              // debugPrint("STORE  FAVOURITES :: ${onData.body}");
              favouriteController.isLoading.value = false;
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                favouriteController.favouriteStores.value = map;
              }
            });
          },
        );

        socket.on(
          "refresh-wallet",
          (data) {
            debugPrint("REFRESH WALLET HERE >> $data");
            // Constant.toast("REFRESH CART HERE :: ");
            APIService()
                .getWalletStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
            )
                .listen((onData) {
              // debugPrint("MY WALLET  :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                walletController.userWallet.value = map;
              }
            });

            APIService()
                .getTransactionsStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              debugPrint("MY WALLET TRANSACTIONS :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);

                walletController.walletTransactions.value = map;
              }
            });
          },
        );

        socket.on(
          "refresh-orders",
          (data) {
            debugPrint("REFRESH ORDERS HERE >> $data");
            // Constant.toast("REFRESH CART HERE :: ");
            APIService()
                .getOrdersStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                orderController.myOrders.value = map;
              }
            });

            APIService()
                .getOrdersInprogressStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                orderController.myInprogressOrders.value = map;
              }
            });

            APIService()
                .getOrdersDeliveredStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                orderController.myDeliveredOrders.value = map;
              }
            });

            APIService()
                .getOrdersCancelledStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                orderController.myCancelledOrders.value = map;
              }
            });

            APIService()
                .getParcelOrdersStreamed(
              accessToken: accessToken,
              customerId: profileController.userData.value['id'],
              page: 1,
            )
                .listen((onData) {
              // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
              if (onData.statusCode >= 200 && onData.statusCode <= 299) {
                Map<String, dynamic> map = jsonDecode(onData.body);
                orderController.myParcelOrders.value = map;
              }
            });
          },
        );

        APIService()
            .getFavouriteListStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
        )
            .listen((onData) {
          // debugPrint("ALL FAVOURITES :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            favouriteController.favouriteList.value = map;
          }
        });

        APIService()
            .getFavouritesStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          vendorType: "restaurant",
          page: 1,
        )
            .listen((onData) {
          // debugPrint("RESTAURANT FAVOURITES :: ${onData.body}");
          favouriteController.isLoading.value = false;
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            favouriteController.favouriteRestaurants.value = map;
          }
        });

        APIService()
            .getFavouritesStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          vendorType: "grocery_store",
          page: 1,
        )
            .listen((onData) {
          // debugPrint("STORE  FAVOURITES :: ${onData.body}");
          favouriteController.isLoading.value = false;
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            favouriteController.favouriteStores.value = map;
          }
        });

        APIService()
            .getCartStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          // debugPrint("MY SHOPPING CART :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            cartController.cartData.value = map;
          }
        });

        APIService()
            .getShippingAdressesStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          // debugPrint("MY SHIPPING ADDRESSES :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);

            shippingAddressController.shippingAddresses.value = map;
          }
        });

        APIService()
            .getWalletStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
        )
            .listen((onData) {
          // debugPrint("MY WALLET  :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            walletController.userWallet.value = map;
          }
        });

        APIService()
            .getTransactionsStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          debugPrint("MY WALLET TRANSACTIONS :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            walletController.walletTransactions.value = map;
          }
        });

        APIService()
            .getOrdersStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          debugPrint("MY ORDERS  :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            orderController.myOrders.value = map;
          }
        });

        APIService()
            .getOrdersInprogressStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            orderController.myInprogressOrders.value = map;
          }
        });

        APIService()
            .getOrdersDeliveredStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            orderController.myDeliveredOrders.value = map;
          }
        });

        APIService()
            .getOrdersCancelledStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            orderController.myCancelledOrders.value = map;
          }
        });

        APIService()
            .getParcelOrdersStreamed(
          accessToken: accessToken,
          customerId: profileController.userData.value['id'],
          page: 1,
        )
            .listen((onData) {
          // debugPrint("MY ORDERS REFRESHED  :: ${onData.body}");
          if (onData.statusCode >= 200 && onData.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(onData.body);
            orderController.myParcelOrders.value = map;
          }
        });

        if (shippingAddressController.location.value.latitude != null &&
            shippingAddressController.location.value.longitude != null) {
          Map payload = {
            "lat": shippingAddressController.location.value.latitude,
            "lng": shippingAddressController.location.value.longitude,
          };

          final nearbys = await APIService().getNearbyVendors(
            page: 1,
            payload: payload,
          );
          debugPrint("NEARBY VENDORS :::: ${nearbys.body}");
          if (nearbys.statusCode >= 200 && nearbys.statusCode <= 299) {
            Map<String, dynamic> map = jsonDecode(nearbys.body);
            vendorController.nearbyVendors.value = map;
          }
        }
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

  DateTime? currentBackPressTime;
  RxBool canPopNow = false.obs;
}
