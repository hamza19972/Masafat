import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/view/screen/mapdropoff.dart';

class MapControllerPickUp extends GetxController {
  String? pickup;
  double? lat;
  double? long;
  String? routeID;
  String? tripId;
  String? driverID;
  int? seats;
  double? price;
  Position? position;
  String? voucher;

  var statusRequest = StatusRequest.loading.obs;
  Completer<GoogleMapController> completercontroller =
      Completer<GoogleMapController>();

  var selectedLocation = LatLng(37.7749, -122.4194).obs;
  var cameraPosition =
      CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 14).obs;

  Future<void> getCurrentLocation() async {
    try {
      position = await Geolocator.getCurrentPosition();
      cameraPosition.value = CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        zoom: 15.4746,
      );
      statusRequest.value = StatusRequest.none;
    } catch (e) {
      statusRequest.value = StatusRequest.failure;
    }
  }

  @override
  void onInit() {
    super.onInit();
    routeID = Get.arguments['routeID'] as String?;
    tripId = Get.arguments['tripId'] as String?;
    driverID = Get.arguments['driverID'] as String?;
    seats = Get.arguments['seats'];
    price = Get.arguments['price'];
    voucher = Get.arguments['voucher'];

    getCurrentLocation();
  }

  void updateLocation(LatLng newLocation) {
    lat = newLocation.latitude;
    long = newLocation.longitude;
    pickup = "$lat $long";
    selectedLocation.value = newLocation;
  }

  void updateCameraPosition(CameraPosition newPosition) {
    cameraPosition.value = newPosition;
  }

  void goToDropOffMap() {
    Get.to(() => MapDropOff(), arguments: {
      "routeID": routeID,
      "tripId": tripId,
      "pickup": pickup,
      "driverID": driverID,
      "seats": seats,
      "price": price,
      "voucher": voucher,
    });
  }
}
