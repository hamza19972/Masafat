import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class MapControllerPickup extends GetxController {
  Rxn<LatLng> pickup = Rxn<LatLng>();
  Rxn<LatLng> dropoff = Rxn<LatLng>();
  var markerIcon = Rxn<BitmapDescriptor>();
  var currentLocation = LatLng(45.521563, -122.677433).obs; // Default location
  var fromController = TextEditingController().obs;
  var toController = TextEditingController().obs;
  Completer<GoogleMapController> completercontroller =
      Completer<GoogleMapController>();

  final GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "");

  void updateLocation(LatLng newLocation) {
    currentLocation.value = newLocation;
  }

  Future<void> searchPlaces(String query) async {
    final PlacesSearchResponse response = await _places.searchByText(query);
    if (response.status == "OK") {
      for (final result in response.results) {
        print(result.name); // Do something with the result
      }
    } else {
      print("Failed to fetch places: ${response.errorMessage}");
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    final response = await _places.getDetailsByPlaceId(placeId);
    if (response.errorMessage == null && response.result != null) {
      final lat = response.result.geometry?.location.lat;
      final lng = response.result.geometry?.location.lng;
      if (lat != null && lng != null) {
        updateLocation(LatLng(lat, lng));
        final GoogleMapController mapController =
            await completercontroller.future;
        mapController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
      }
    }
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap(String path,
      {int width = 100, int height = 100}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    final bytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  void loadCustomMarker() async {
    markerIcon.value = await createCustomMarkerBitmap('assets/images/logo8.png',
        width: 200, height: 200);
  }

  void setPickup(LatLng location) {
    pickup.value = location;
    print(pickup);
  }

  void setDropoff() {
    dropoff.value ;
    print(dropoff);
  }

  @override
  void onInit() {
    super.onInit();
    loadCustomMarker();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return; // Permission denied
      }
    }

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation.value = LatLng(position.latitude, position.longitude);
  }

  // This will be called when the pickup marker is dragged
  void updatePickupLocation(LatLng newLocation) {
    pickup.value = newLocation;
  }

  // This will be called when the drop-off marker is dragged
  void updateDropoffLocation(LatLng newLocation) {
    dropoff.value = newLocation;
  }
}
