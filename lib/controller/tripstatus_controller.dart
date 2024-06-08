import 'package:get/get.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/data/datasource/remote/mytripdata.dart';
import 'package:masafat/view/screen/driverinfo.dart';
import 'package:masafat/view/screen/home/homepage.dart';
import 'package:masafat/view/screen/tripdetalis.dart';

class RideRequest {
  final int requestId;
  final String pickupLocation;
  final String dropoffLocation;
  final String date;
  final String time;
  final int seats;
  final int status;
  final int userId;
  final int driverid;
  final String pickupName;
  final String dropoffName;
  final num price;

  RideRequest({
    required this.requestId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.date,
    required this.time,
    required this.seats,
    required this.status,
    required this.userId,
    required this.driverid,
    required this.pickupName,
    required this.dropoffName,
    required this.price,
  });

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      requestId: json['request_id'],
      pickupLocation: json['pickup_location'],
      dropoffLocation: json['dropoff_location'],
      date: json['date'],
      time: json['time'],
      seats: json['seats'],
      status: json['status'],
      userId: json['user_id'],
      driverid: json['driver_id'],
      pickupName: json['pickup_name'],
      dropoffName: json['dropoff_name'],
      price: json['price'],
    );
  }
}




class RideRequestController extends GetxController {
  int? userid;
  List<RideRequest> rideRequests = <RideRequest>[].obs;
  StatusRequest? statusRequest;
  MyTripData myTripData = MyTripData(Get.find());
  MyServices myServices = Get.find();
  @override
  void onInit() {
    userid = myServices.sharedPreferences.getInt("id");
    getMyTrip();

    super.onInit();
  }

  getMyTrip() async {
    try {
      var response = await myTripData.getData(userid!);
      print("=============================== Controller $response ");

      if (response['status'] == "success") {
        List<dynamic> tripList = response['data'];
        // Convert JSON to Trip objects and sort them in decreasing order by tripId
        var tripsTemp =
            tripList.map((tripJson) => RideRequest.fromJson(tripJson)).toList();
        // Sorting in decreasing order
        tripsTemp.sort((a, b) => b.requestId.compareTo(a.requestId));

        rideRequests
            .clear(); // Clear the existing list before adding sorted trips
        rideRequests.addAll(tripsTemp); // Add the sorted list to trips
        statusRequest = StatusRequest.success;
      } else {
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      print('Error fetching data: $e');
      statusRequest = StatusRequest.failure;
    }
    update(); // Notify listeners to
  }

  cancelTrip(int requestId) async {
    try {
      var response = await myTripData.cancelTrip(userid!, requestId);
      print("=============================== Controller $response ");

      if (response['status'] == "success") {
        Get.offAll(()=>Homepage());
        statusRequest = StatusRequest.success;
      } else {
        Get.defaultDialog(middleText: "22".tr);

        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      print('Error fetching data: $e');
      statusRequest = StatusRequest.failure;
    }
    update(); // N
  }

  void goTovehiclePage(int driverid) {
    Get.to(() => VehiclePage(),arguments: {"driverid":driverid});
  }

  void goToDetailsPage(RideRequest rideRequest) {
    // Navigate to the details page, passing the RideRequest object
    Get.to(() => DetailsPage(rideRequest: rideRequest));
  }
}
