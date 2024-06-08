import 'dart:convert';
import 'package:get/get.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/data/datasource/remote/tripv2data.dart';
import 'package:geocoding/geocoding.dart';

class Tripv2 {
  final int id;
  final int tripId;
  final int passengerId;
  final String name;
  final String userPhone;
  final int driverId;
  final String pickupLocation;
  final String dropoffLocation;
  final int seatsBooked;
  final String price;
  final String status;
  final DateTime createdAt;

  String pickupAddress = '';
  String dropoffAddress = '';

  Tripv2({
    required this.id,
    required this.tripId,
    required this.passengerId,
    required this.name,
    required this.userPhone,
    required this.driverId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.seatsBooked,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory Tripv2.fromJson(Map<dynamic, dynamic> json) {
    return Tripv2(
      id: json['id'],
      tripId: json['trip_id'],
      passengerId: json['passenger_id'],
      name: json['name'],
      userPhone: json['user_phone'],
      driverId: json['driverId'],
      pickupLocation: json['pickup_location'] ?? '',
      dropoffLocation: json['dropoff_location'] ?? '',
      seatsBooked: json['seats_booked'],
      price: json['price'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Future<void> updateAddresses() async {
    pickupAddress = await getAddressFromCoordinates(pickupLocation);
    dropoffAddress = await getAddressFromCoordinates(dropoffLocation);
  }

  Future<String> getAddressFromCoordinates(String location) async {
    final latLng = location.replaceAll('POINT(', '').replaceAll(')', '').split(' ');
    final lat = double.parse(latLng[0]);
    final lng = double.parse(latLng[1]);

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      return placemarks.first.locality ?? 'Unknown location';
    } else {
      return 'Unknown location';
    }
  }
}

class TripController extends GetxController {
  var trips = <Tripv2>[].obs;
  var isLoading = true.obs;
  var statusRequest = StatusRequest.loading.obs;

  late Tripv2Data tripv2data;
  late MyServices myServices;
  int? userID;

  @override
  void onInit() {
    myServices = Get.find<MyServices>();
    tripv2data = Tripv2Data(Get.find());
    userID = myServices.sharedPreferences.getInt("id");
    fetchTrips();
    super.onInit();
  }

  Future<void> fetchTrips() async {
  try {
    isLoading(true);
    var response = await tripv2data.getData(userID!);
    if (response is String) {
      response = json.decode(response);
    }

    if (response['status'] == 'success') {
      List<Tripv2> loadedTrips = [];
      for (var tripJson in response['data']) {
        Tripv2 trip = Tripv2.fromJson(tripJson);
        await trip.updateAddresses(); // Fetch the address for pickup and dropoff
        loadedTrips.add(trip);
      }
      loadedTrips.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort trips to show latest first
      trips.assignAll(loadedTrips);
      statusRequest(StatusRequest.success);
    } else {
      statusRequest(StatusRequest.failure);
    }
  } catch (e) {
    print('Error fetching data: $e');
    statusRequest(StatusRequest.failure);
  } finally {
    isLoading(false);
  }
}
Future<void> cancelTrip(int id)async{
  try {
    isLoading(true);
    var response = await tripv2data.canceleData(id);
    if (response is String) {
      response = json.decode(response);
    }

    if (response['status'] == 'success') {
     Get.snackbar("63".tr, "66".tr);
    } else {
      statusRequest(StatusRequest.failure);
    }
  } catch (e) {
    print('Error fetching data: $e');
    statusRequest(StatusRequest.failure);
  } finally {
    isLoading(false);
  }
}
}
