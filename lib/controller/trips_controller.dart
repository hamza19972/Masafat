import 'dart:convert';
import 'package:get/get.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/data/datasource/remote/lanesdata.dart';
import 'package:masafat/mappickup.dart';
import 'package:intl/date_symbol_data_local.dart';


class Trip {
  final int tripID;
  final int driverID;
  final int routeID;
  final DateTime departureDateTime; // Combining date and time into one DateTime
  final int gender;
  final int seats;
  final String status;

  Trip({
    required this.tripID,
    required this.driverID,
    required this.routeID,
    required this.departureDateTime,
    required this.gender,
    required this.seats,
    required this.status,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    // Combine date and time into one DateTime object
    return Trip(
      tripID: json['TripID'],
      driverID: json['DriverID'],
      routeID: json['RouteID'],
      departureDateTime:
          DateTime.parse(json['DepartureDate'] + " " + json['DepartureTime']),
      gender: json['gender'],
      seats: json['seats'],
      status: json['Status'],
    );
  }
}

List<Trip> parseTrips(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return List<Trip>.from(parsed['data'].map((x) => Trip.fromJson(x)));
}

class TripsController extends GetxController {
  var selectedSeats = 1.obs; // Reactive state for selected seats
  String? gender;
  String? routeID;
  int? seats;
  double? price;
  var trips = <Trip>[].obs;
  String? voucher;
  String? lang;

  MyServices myServices = Get.find();
  LanesData lanesData = LanesData(Get.find());
  var statusRequest = StatusRequest.loading.obs;

  @override
  void onInit() {
    super.onInit();
    gender = myServices.sharedPreferences.getInt("gender").toString();
    lang = myServices.sharedPreferences.getString("lang");
    routeID = Get.arguments['routeID'];
    seats = Get.arguments['seats'];
    price = Get.arguments['price'];
    voucher = Get.arguments['voucher'];
    getTrips();
    initializeDateFormatting('ar', null);
  }

  void incrementSeats() {
    if (selectedSeats.value < 4) {
      selectedSeats.value++;
    }
  }

  void decrementSeats() {
    if (selectedSeats.value > 1) {
      selectedSeats.value--;
    }
  }

  Future<void> getTrips() async {
    try {
      var response = await lanesData.getTrips(routeID!, gender!, seats!);
      if (response['status'] == "success") {
        List<dynamic> tripData = response['data'];
        List<Trip> fetchedTrips =
            tripData.map((trip) => Trip.fromJson(trip)).toList();

        // Sort the trips by departureDateTime
        fetchedTrips
            .sort((a, b) => a.departureDateTime.compareTo(b.departureDateTime));

        trips.value = fetchedTrips;
        statusRequest.value = StatusRequest.success;
      } else {
        statusRequest.value = StatusRequest.failure;
      }
    } catch (e) {
      statusRequest.value = StatusRequest.failure;
    }
    update(); // Notify listeners that trips data has been updated
  }

  void openPickupMap(String tripId, String driverID) {
    Get.to(() => MapPickUp(), arguments: {
      "tripId": tripId,
      "routeID": routeID,
      "driverID": driverID,
      "seats": seats,
      "price": price,
      "voucher": voucher
    });
  }
}
