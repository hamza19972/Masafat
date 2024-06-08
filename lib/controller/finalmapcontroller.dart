import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:flutter_google_maps_webservices/places.dart";
import 'package:masafat/core/functions/handingdatacontroller.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/data/datasource/remote/mapdata.dart';
import 'package:masafat/view/screen/home/ridesucsess.dart';

class FinalMapController extends GetxController {
  var selectedDate = '';
  var selectedTime = '';

  DateTime? date;
  TimeOfDay? time;

  MyServices myServices = Get.find();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  MapData mapData = MapData(Get.find());
  String apiKey = '';
  StatusRequest statusRequest = StatusRequest.loading;
  late GoogleMapsPlaces places;

  Completer<GoogleMapController>? completercontroller;
  String? userid;

  List<Marker> markers = [];

  double? lat;
  double? long;
  int selectedSeats = 1;
  String? gender;

  LatLng? pickUpPrice;
  LatLng? dropOffPrice;

  String? pickUp;
  String? dropoff;
  String? dropoffName;
  String? pickupName;

  List<Placemark>? placemarksPickUp;
  List<Placemark>? placemarksDropOff;

  double? distanceInKilometers;
  double? totalFare;
  double? distanceInKilometerstemp;

  int? price;

  double baseFare = 0; // Your base fare
  double pricePerKilometer = 0.06; // Your price per kilometer

  // Generates a list of times at 15-minute intervals

  setSelectedSeats(int seats) {
    selectedSeats = seats;
    calculatePrice();
    update(); // Notify listeners to refresh UI
  }

  placesClass() {
    places = GoogleMapsPlaces(apiKey: "YOUR_API_KEY");
  }

  Future<void> searchPlaces(String query) async {
    final PlacesSearchResponse response = await places.searchByText(query);
    if (response.status == "OK") {
      for (final result in response.results) {
        print(result.name); // Do something with the result
      }
    } else {
      print("Failed to fetch places: ${response.errorMessage}");
    }
  }

  addMarkersPickUp(LatLng latLng) async {
    markers.clear();
    markers.add(Marker(
        markerId: MarkerId("pickup"),
        position: latLng,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));
    lat = latLng.latitude;
    long = latLng.longitude;
    pickUpPrice = latLng;
    pickUp = lat.toString() + " " + long.toString();
    print("================================pickup");
    print(latLng);
    print(pickUp);
    placemarksPickUp =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    update();
  }

  Future<void> addMarkersDropOff(LatLng latLng) async {
    markers.add(Marker(markerId: MarkerId("dropoff"), position: latLng));
    lat = latLng.latitude;
    long = latLng.longitude;
    dropOffPrice = latLng;
    dropoff = lat.toString() + " " + long.toString();
    print("================================dropoff");
    print(latLng);
    print(dropoff);
    List<Placemark> newPlacemarksDropOff =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    // Clear previous route if any
    polylines.clear();

    // Check if the pickup location has been set and the administrative areas are the same
    if (placemarksPickUp != null &&
        placemarksPickUp!.isNotEmpty &&
        newPlacemarksDropOff.isNotEmpty &&
        newPlacemarksDropOff.first.administrativeArea ==
            placemarksPickUp!.first.administrativeArea) {
      // Inform the user they cannot select the same administrative area for pickup and dropoff
      Get.snackbar(
        '23'.tr,
        '24'.tr,
        snackPosition: SnackPosition.TOP,
      );

      // Clear the dropoff marker and related data
      markers.removeWhere((marker) => marker.markerId == MarkerId("dropoff"));
      dropOffPrice = null;
      placemarksDropOff = null;
      totalFare = null; // Ensure fare is not calculated
    } else {
      // Different administrative areas, proceed with setting the dropoff and calculating route/fare
      placemarksDropOff = newPlacemarksDropOff;
      await calculateFaretow(pickUpPrice!,
          dropOffPrice!); // Recalculates fare only if dropoff is valid
      await showRoute(); // Show route only for valid dropoff
    }
    update(); // Update the state to refresh UI
  }

  Position? postion;

  CameraPosition? kGooglePlex;

  getCurrentLocation() async {
    postion = await Geolocator.getCurrentPosition();
    kGooglePlex = CameraPosition(
      target: LatLng(postion!.latitude, postion!.longitude),
      zoom: 14.4746,
    );
    statusRequest = StatusRequest.none;
    update();
  }

  @override
  void onInit() {
    gender = myServices.sharedPreferences.getString("gender");
    places = GoogleMapsPlaces(apiKey: apiKey);
    getCurrentLocation();
    completercontroller = Completer<GoogleMapController>();
    super.onInit();
  }

  // Replace with your actual API key

  Future<void> calculateFaretow(LatLng pickup, LatLng dropoff) async {
    if (pickup != null && dropoff != null) {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${dropoff.latitude},${dropoff.longitude}&key=$apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final distance = route['legs'][0]['distance']['value'];

          final distanceInKilometers = distance / 1000;
          if (distanceInKilometers <= 50) {
            totalFare = 0.072 * distanceInKilometers;
          } else if (distanceInKilometers <= 100 && distanceInKilometers > 50) {
            distanceInKilometerstemp = distanceInKilometers - 50;
            totalFare=0.072 * 50 + 0.05 * distanceInKilometerstemp!;
          } else if (distanceInKilometers > 100 &&
              distanceInKilometers <= 200) {
            distanceInKilometerstemp = distanceInKilometers - 100;
            totalFare = (0.05 * 100 + 0.019 * distanceInKilometerstemp!);
          } else {
            distanceInKilometerstemp = distanceInKilometers - 200;
            totalFare =
                (0.04 * 100 + 0.035 * 100 + 0.026 * distanceInKilometerstemp!);
          }
        } else {
          print('No route found');
          totalFare = 0; // or handle this case as needed
        }
      } else {
        print('Failed to fetch directions');
        totalFare = 0; // or handle this case as needed
      }

      update();
    }
    price = totalFare!.toInt() * selectedSeats.toInt();
    update();
  }

  List<LatLng> decodePolyline(String polyline) {
    int index = 0;
    int len = polyline.length;
    List<LatLng> decoded = [];
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      decoded.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return decoded;
  }

  Set<Polyline> polylines = {};

  Future<List<LatLng>> getRouteCoordinates(
      LatLng start, LatLng destination) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';
    http.Response response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    if (data['routes'].isEmpty) return [];

    List<LatLng> routePoints =
        decodePolyline(data['routes'][0]['overview_polyline']['points']);
    return routePoints;
  }

  showRoute() async {
    LatLng startLocation = pickUpPrice!;
    LatLng endLocation = dropOffPrice!;

    List<LatLng> routePoints =
        await getRouteCoordinates(startLocation, endLocation);

    Polyline routePolyline = Polyline(
      polylineId: PolylineId("route"),
      points: routePoints,
      width: 5,
      color: Colors.green,
      geodesic: true,
    );

    polylines.add(routePolyline);

    update();
  }

  void showDatePickertow() {
    
    final now = DateTime.now();
    final minuteInterval = 60; // Example interval
    // Adjust the minute to fit the interval
    final initialDateTime =
        DateTime(now.year, now.month, now.day, now.hour+1, 0);
    Get.bottomSheet(
      Container(
        color: Colors.white,
        height: Get.context!.height * 0.3,
        child: CupertinoDatePicker(
          initialDateTime: initialDateTime,
          onDateTimeChanged: (DateTime newDate) {
            selectedDate = DateFormat('yyyy-MM-dd').format(newDate);
            selectedTime = DateFormat('HH:mm:ss').format(newDate);
            // If you need to print or use the formatted date/time immediately
            print('Date: ${selectedDate}, Time: ${selectedTime}');
          },
          minuteInterval: minuteInterval,
          maximumYear: 2024,
          minimumDate: now,
          mode: CupertinoDatePickerMode.dateAndTime,
        ),
      ),
      isScrollControlled: true,
    );
  }

  void calculatePrice() {
    // Assuming `distanceInKilometers` holds the current trip distance
    // and `baseFare`, `pricePerKilometer` are defined

    if (distanceInKilometers != null) {
      double distancePrice = distanceInKilometers! * pricePerKilometer;
      totalFare = distancePrice; // Update this calculation as needed

      // Calculate final price based on the number of seats
      price = (totalFare! * selectedSeats).toInt();
    }

    update(); // Update the UI with the new price
  }

  continueAction() async {
    var fullArea = placemarksPickUp![0].administrativeArea!.toString();
    var areaPartspickup = fullArea.split(" ");
    pickupName = areaPartspickup[0].toString();
    var fullAreadrop = placemarksDropOff![0].administrativeArea!.toString();
    var areaPartsdrop = fullAreadrop.split(" ");
    dropoffName = areaPartsdrop[0].toString();
    userid = myServices.sharedPreferences.getInt("id").toString();
    {
      statusRequest = StatusRequest.loading;
      update();
      var response = await mapData.postdata(
          userid!,
          dropoff!,
          pickUp!,
          selectedTime,
          selectedDate,
          selectedSeats.toString(),
          (totalFare! * selectedSeats).toString(),
          pickupName!,
          dropoffName!,
          gender!);
      print("=============================== Controller $response ");
      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success") {
          // data.addAll(response['data']);
          Get.offAll(() => RideSuccess());

          update();
        } else {
          Get.dialog(
            AlertDialog(
              title: Text('25'.tr),
              content: Text('22'.tr),
              actions: <Widget>[
                TextButton(
                  child: Text('26'.tr),
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                ),
                TextButton(
                  child: Text('27'.tr),
                  onPressed: () {
                    // Perform some action here
                    Get.back(); // Close the dialog
                  },
                ),
              ],
            ),
          );
        }
      }
    }
  }
}
