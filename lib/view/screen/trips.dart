import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masafat/controller/trips_controller.dart';
import 'package:masafat/core/class/statusrequest.dart';

class TripsScreen extends StatelessWidget {
  final TripsController tripsController = Get.put(TripsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('100'.tr, style: TextStyle(fontSize: 24, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade600],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: GetBuilder<TripsController>(
        builder: (controller) {
          if (controller.statusRequest.value == StatusRequest.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.trips.isEmpty) {
            return Center(
                child: Text("101".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)));
          } else if (controller.statusRequest.value == StatusRequest.failure) {
            return Center(
                child: Text("102".tr, style: TextStyle(fontSize: 20)));
          }

          return ListView.builder(
            itemCount: controller.trips.length,
            itemBuilder: (context, index) {
              final trip = controller.trips[index];
              return buildTripCard(trip, context);
            },
          );
        },
      ),
    );
  }

  Widget buildTripCard(Trip trip, BuildContext context) {
    String locale = tripsController.lang == "ar" ? 'ar' : 'en';
    String formattedDate = DateFormat('EEEE, MMM d, h:mm a', locale)
        .format(trip.departureDateTime);

    return InkWell(
      onTap: () => tripsController.openPickupMap(
          trip.tripID.toString(), trip.driverID.toString()),
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                blurRadius: 6,
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2)
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    child: Icon(Icons.directions_car,
                        color: Colors.white, size: 28),
                  ),
                  TextButton(
                    onPressed: () {
                      tripsController.openPickupMap(
                          trip.tripID.toString(), trip.driverID.toString());
                    },
                    child: Text('103'.tr, style: TextStyle(fontSize: 16)),
                    style: TextButton.styleFrom(primary: Colors.green.shade600),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${'104'.tr}${4 - trip.seats}',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
