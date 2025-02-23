import 'dart:typed_data';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LiveTrackingController extends GetxController {
  GoogleMapController? mapController;

  @override
  void onInit() {
    // TODO: implement onInit
    addMarkerSetup();
    if (Constant.selectedMapType == 'osm') {
      ShowToastDialog.showLoader("Please wait".tr);
      mapOsmController = MapController(
        initPosition: GeoPoint(latitude: 20.9153, longitude: -100.7439),
      ); //OSM
    }

    getArgument();
    super.onInit();
  }

  var orderModel = {}.obs;
  var driverUserModel = {}.obs;
  RxBool isLoading = true.obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
      isLoading.value = false;
      if (Constant.selectedMapType != 'osm') {
        if (orderModel.value['order_status'] == "rider_picked_order") {
          getPolyline(
            sourceLatitude:
                double.parse("${orderModel.value['rider']['current_lat']}"),
            sourceLongitude:
                double.parse("${orderModel.value['rider']['current_lng']}"),
            destinationLatitude:
                double.parse("${orderModel.value['vendor']['lat']}"),
            destinationLongitude:
                double.parse("${orderModel.value['vendor']['lng']}"),
          );
        } else if (orderModel.value['order_status'] == "in_delivery") {
          getPolyline(
            sourceLatitude:
                double.parse("${orderModel.value['rider']['current_lat']}"),
            sourceLongitude:
                double.parse("${orderModel.value['rider']['current_lng']}"),
            destinationLatitude:
                double.parse("${orderModel.value['delivery_addr_lat']}"),
            destinationLongitude:
                double.parse("${orderModel.value['delivery_addr_lng']}"),
          );
        } else {
          getPolyline(
            sourceLatitude:
                double.parse("${orderModel.value['delivery_addr_lat']}"),
            sourceLongitude:
                double.parse("${orderModel.value['delivery_addr_lng']}"),
            destinationLatitude:
                double.parse("${orderModel.value['vendor']['lat']}"),
            destinationLongitude:
                double.parse("${orderModel.value['vendor']['lng']}"),
          );
        }
      } else {
        if (orderModel.value['order_status'] == "rider_picked_order") {
          setOsmMarker(
            departure: GeoPoint(
              latitude: orderModel.value['rider']['current_lat'],
              longitude: orderModel.value['rider']['current_lng'],
            ),
            destination: GeoPoint(
              latitude: orderModel.value['vendor']['lat'],
              longitude: orderModel.value['vendor']['lng'],
            ),
          );
        } else if (orderModel.value['order_status'] == "in_delivery") {
          setOsmMarker(
            departure: GeoPoint(
              latitude: orderModel.value['rider']['current_lat'],
              longitude: orderModel.value['rider']['current_lng'],
            ),
            destination: GeoPoint(
              latitude: orderModel.value['delivery_addr_lat'],
              longitude: orderModel.value['delivery_addr_lng'],
            ),
          );
        } else {
          setOsmMarker(
            departure: GeoPoint(
              latitude: orderModel.value['delivery_addr_lat'],
              longitude: orderModel.value['delivery_addr_lng'],
            ),
            destination: GeoPoint(
              latitude: orderModel.value['vendor']['lat'],
              longitude: orderModel.value['vendor']['lng'],
            ),
          );
        }
      }
    }
    // });

    // if (orderModel.value.status == Constant.orderCompleted) {
    //   Get.back();
    // }
    // }
    // });
    // }

    isLoading.value = false;

    update();
  }

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? driverIcon;

  void getPolyline({
    required double? sourceLatitude,
    required double? sourceLongitude,
    required double? destinationLatitude,
    required double? destinationLongitude,
  }) async {
    if (sourceLatitude != null &&
        sourceLongitude != null &&
        destinationLatitude != null &&
        destinationLongitude != null) {
      List<LatLng> polylineCoordinates = [];
      PolylineRequest polylineRequest = PolylineRequest(
        origin: PointLatLng(sourceLatitude, sourceLongitude),
        destination: PointLatLng(destinationLatitude, destinationLongitude),
        mode: TravelMode.driving,
      );

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: polylineRequest,
        googleApiKey: Constant.mapAPIKey,
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        print(result.errorMessage.toString());
      }

      addMarker(
          latitude: double.parse("${orderModel.value['vendor']['lat']}"),
          longitude: double.parse("${orderModel.value['vendor']['lng']}"),
          id: "Departure",
          descriptor: departureIcon!,
          rotation: 0.0);
      addMarker(
          latitude: double.parse("${orderModel.value['delivery_addr_lat']}"),
          longitude: double.parse("${orderModel.value['delivery_addr_lng']}"),
          id: "Destination",
          descriptor: destinationIcon!,
          rotation: 0.0);
      addMarker(
        latitude: double.parse("${orderModel.value['rider']['current_lat']}"),
        longitude: double.parse("${orderModel.value['rider']['current_lng']}"),
        id: "Driver",
        descriptor: driverIcon!,
        rotation: double.parse("2.0"),
      );

      _addPolyLine(polylineCoordinates);
    }
  }

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  addMarker(
      {required double? latitude,
      required double? longitude,
      required String id,
      required BitmapDescriptor descriptor,
      required double? rotation}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: LatLng(latitude ?? 0.0, longitude ?? 0.0),
        rotation: rotation ?? 0.0);
    markers[markerId] = marker;
  }

  addMarkerSetup() async {
    if (Constant.selectedMapType != 'osm') {
      final Uint8List departure =
          await Constant().getBytesFromAsset('assets/images/pickup.png', 100);
      final Uint8List destination =
          await Constant().getBytesFromAsset('assets/images/dropoff.png', 100);
      final Uint8List driver = await Constant()
          .getBytesFromAsset('assets/images/food_delivery.png', 50);
      departureIcon = BitmapDescriptor.fromBytes(departure);
      destinationIcon = BitmapDescriptor.fromBytes(destination);
      driverIcon = BitmapDescriptor.fromBytes(driver);
    } else {
      departureOsmIcon =
          Image.asset("assets/images/pickup.png", width: 30, height: 30); //OSM
      destinationOsmIcon =
          Image.asset("assets/images/dropoff.png", width: 30, height: 30); //OSM
      driverOsmIcon = Image.asset(
        "assets/images/food_delivery.png",
        width: 30,
        height: 30,
      ); //OSM
    }
  }

  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints();

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      consumeTapEvents: true,
      startCap: Cap.roundCap,
      width: 6,
    );
    polyLines[id] = polyline;
    updateCameraLocation(
        polylineCoordinates.first, polylineCoordinates.last, mapController);
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 10);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  //OSM
  late MapController mapOsmController;
  Rx<RoadInfo> roadInfo = RoadInfo().obs;
  Map<String, GeoPoint> osmMarkers = <String, GeoPoint>{};
  Image? departureOsmIcon; //OSM
  Image? destinationOsmIcon; //OSM
  Image? driverOsmIcon;

  void getOSMPolyline() async {
    // try {
    //   GeoPoint destinationLocation;
    //   if (orderModel.value.status == Constant.orderShipped) {
    //     destinationLocation = GeoPoint(
    //         latitude: orderModel.value.vendor!.latitude ?? 0,
    //         longitude: orderModel.value.vendor!.longitude ?? 0);
    //   } else {
    //     destinationLocation = GeoPoint(
    //         latitude: orderModel.value.address!.location!.latitude ?? 0,
    //         longitude: orderModel.value.address!.location!.longitude ?? 0);
    //   }

    //   await mapOsmController.removeLastRoad();
    //   roadInfo.value = await mapOsmController.drawRoad(
    //     GeoPoint(
    //         latitude: driverUserModel.value.location!.latitude!,
    //         longitude: driverUserModel.value.location!.longitude!),
    //     destinationLocation,
    //     roadType: RoadType.car,
    //     roadOption: RoadOption(
    //       roadWidth: 15,
    //       roadColor: AppThemeData
    //           .primary300, //themeChange ? AppColors.darkModePrimary :
    //       zoomInto: false,
    //     ),
    //   );
    //   mapOsmController.goToLocation(
    //     GeoPoint(
    //         latitude: driverUserModel.value.location!.latitude!,
    //         longitude: driverUserModel.value.location!.longitude!),
    //   );
    // } catch (e) {
    //   print('Error: $e');
    // }
  }

  Future<void> updateOSMCameraLocation(
      {required GeoPoint source, required GeoPoint destination}) async {
    BoundingBox bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = BoundingBox(
        north: source.latitude,
        south: destination.latitude,
        east: source.longitude,
        west: destination.longitude,
      );
    } else if (source.longitude > destination.longitude) {
      bounds = BoundingBox(
        north: destination.latitude,
        south: source.latitude,
        east: source.longitude,
        west: destination.longitude,
      );
    } else if (source.latitude > destination.latitude) {
      bounds = BoundingBox(
        north: source.latitude,
        south: destination.latitude,
        east: destination.longitude,
        west: source.longitude,
      );
    } else {
      bounds = BoundingBox(
        north: destination.latitude,
        south: source.latitude,
        east: destination.longitude,
        west: source.longitude,
      );
    }

    await mapOsmController.zoomToBoundingBox(bounds, paddinInPixel: 100);
  }

  setOsmMarker(
      {required GeoPoint departure, required GeoPoint destination}) async {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   if (osmMarkers.containsKey('Driver')) {
    //     await mapOsmController.removeMarker(osmMarkers['Driver']!);
    //   }

    //   await mapOsmController
    //       .addMarker(
    //           GeoPoint(
    //               latitude: driverUserModel.value.location!.latitude!,
    //               longitude: driverUserModel.value.location!.longitude!),
    //           markerIcon: MarkerIcon(iconWidget: driverOsmIcon),
    //           angle: pi / 3,
    //           iconAnchor: IconAnchor(
    //             anchor: Anchor.top,
    //           ))
    //       .then((v) {
    //     osmMarkers['Driver'] = GeoPoint(
    //         latitude: driverUserModel.value.location!.latitude!,
    //         longitude: driverUserModel.value.location!.longitude!);
    //   });

    //   if (osmMarkers.containsKey('Source')) {
    //     await mapOsmController.removeMarker(osmMarkers['Source']!);
    //   }
    //   await mapOsmController
    //       .addMarker(departure,
    //           markerIcon: MarkerIcon(iconWidget: departureOsmIcon),
    //           angle: pi / 3,
    //           iconAnchor: IconAnchor(
    //             anchor: Anchor.top,
    //           ))
    //       .then((v) {
    //     osmMarkers['Source'] = departure;
    //   });

    //   if (osmMarkers.containsKey('Destination')) {
    //     await mapOsmController.removeMarker(osmMarkers['Destination']!);
    //   }

    //   await mapOsmController
    //       .addMarker(destination,
    //           markerIcon: MarkerIcon(iconWidget: destinationOsmIcon),
    //           angle: pi / 3,
    //           iconAnchor: IconAnchor(
    //             anchor: Anchor.top,
    //           ))
    //       .then((v) {
    //     osmMarkers['Destination'] = destination;
    //   });
    // });
    // getOSMPolyline();
  }
}
