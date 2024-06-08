import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/controller/tripstatus_controller.dart';

class RideRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RideRequestController());
    controller.getMyTrip(); // Load the ride requests

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors
              .green, // Here you can set your desired color for the back button and other AppBar icons
        ),
        title: Text(
          '28'.tr,
          style: const TextStyle(
              color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.rideRequests.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
        return ListView.builder(
          itemCount: controller.rideRequests.length,
          itemBuilder: (context, index) {
            final rideRequest = controller.rideRequests[index];
            return ListTile(
              title: Text(
                  '${rideRequest.pickupName} to ${rideRequest.dropoffName}',style: const TextStyle(color: Colors.green),),
              subtitle:
                  Text('Date: ${rideRequest.date}, Time: ${rideRequest.time}'),
              onTap: () => controller.goToDetailsPage(rideRequest),
            );
          },
        );
      }),
    );
  }
}
