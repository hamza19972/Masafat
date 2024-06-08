import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/data/datasource/remote/lanesdata.dart';
import 'package:masafat/view/screen/home/ridesucsess.dart';

class MapControllerDropOff extends GetxController {
  String? name;
  String? pickup;
  String? driverID;
  String? phone;
  String? id;
  String? dropoff;
  double? lat;
  double? long;
  LanesData lanesData = LanesData(Get.find());
  String? routeID;
  String? tripId;
  String? gender;
  int? seats;
  double? price;
  String? voucher;

  MyServices myServices = Get.find();
  Position? position;
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
    pickup = Get.arguments['pickup'] as String?;
    driverID = Get.arguments['driverID'] as String?;
    gender = myServices.sharedPreferences.getInt("gender").toString();
    id = myServices.sharedPreferences.getInt("id").toString();
    phone = myServices.sharedPreferences.getString("phone");
    name = myServices.sharedPreferences.getString("username");
    seats = Get.arguments['seats'];
    price = Get.arguments['price'];
    voucher = Get.arguments['voucher'];

    getCurrentLocation();
  }

  void updateLocation(LatLng newLocation) {
    lat = newLocation.latitude;
    long = newLocation.longitude;
    dropoff = "$lat $long";
    selectedLocation.value = newLocation;
  }

  void updateCameraPosition(CameraPosition newPosition) {
    cameraPosition.value = newPosition;
  }

  Future<void> getTrips() async {
    double sendprice = price! * seats!;
    try {
      var response = await lanesData.sendData(tripId!, gender!, id!, phone!,
          driverID!, pickup!, dropoff!, seats!, sendprice, name!, voucher!);
      if (response['status'] == "success") {
        Get.offAll(() => RideSuccess());
        statusRequest.value = StatusRequest.success;
      } else {
        statusRequest.value = StatusRequest.failure;
      }
    } catch (e) {
      statusRequest.value = StatusRequest.failure;
    }
    update(); // Notify listeners that trips data has been updated
  }
}
