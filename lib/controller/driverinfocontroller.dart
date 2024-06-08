import 'package:get/get.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/data/datasource/remote/mytripdata.dart';

class Vehicle {
  int vehicleId;
  int driverId;
  String driverName;
  int driverPhone;
  String registrationNumber;
  int totalSeats;
  String make;
  String model;
  int year;
  String driverPictureUrl;

  Vehicle({
    required this.vehicleId,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.registrationNumber,
    required this.totalSeats,
    required this.make,
    required this.model,
    required this.year,
    required this.driverPictureUrl,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicle_id'],
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      driverPhone: json['driver_phone'],
      registrationNumber: json['registration_number'],
      totalSeats: json['total_seats'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      driverPictureUrl: json['driver_picture_url'],
    );
  }
}

class DriverInofController extends GetxController {
  List<Vehicle> vehicle = <Vehicle>[].obs;
  MyTripData myTripData = MyTripData(Get.find());
  MyServices myServices = Get.find();
  StatusRequest? statusRequest;
  int? driverid;

  @override
  void onInit() {
    driverid = Get.arguments['driverid'];
    viewdriver();
    super.onInit();
  }

  viewdriver() async {
    try {
      var response = await myTripData.driverview(driverid!);
      print("=============================== Controller $response ");

      if (response['status'] == "success") {
        List<dynamic> vehicleList = response['data'];

        // Convert each Map in the list to a Vehicle object
        var vehicleTemp = vehicleList.map((v) => Vehicle.fromJson(v)).toList();

        // Assuming you want to clear the existing vehicles and add the new ones
        vehicle.clear();
        vehicle.addAll(
            vehicleTemp); // Add the newly created Vehicle objects to the list
        statusRequest = StatusRequest.success;
      } else {
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      print('Error fetching data: $e');
      statusRequest = StatusRequest.failure;
    }
    update(); // Notify listeners to rebuild the UI
  }
}
