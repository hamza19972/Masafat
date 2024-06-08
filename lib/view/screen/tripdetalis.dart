import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/controller/tripstatus_controller.dart';
import 'package:masafat/view/screen/driverinfo.dart';
import 'package:masafat/view/screen/home/homepage.dart';

class ThreeDotLoading extends StatefulWidget {
  final Color color;
  final double size;

  const ThreeDotLoading({Key? key, this.color = Colors.black, this.size = 8.0})
      : super(key: key);

  @override
  State<ThreeDotLoading> createState() => _ThreeDotLoadingState();
}

class _ThreeDotLoadingState extends State<ThreeDotLoading> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % 3; // Cycle through 0, 1, 2
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Opacity(
            opacity: index == _currentIndex ? 1.0 : 0.5,
            child: Container(
              height: widget.size,
              width: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final RideRequest rideRequest;

  const DetailsPage({super.key, required this.rideRequest});

  @override
  Widget build(BuildContext context) {
    final RideRequestController controller = Get.put(RideRequestController());

    // Determine the status message and color based on the rideRequest status
    Widget statusWidget;
    final statusColor = rideRequest.status == 0 ? Colors.orange : Colors.green;
    
    if (rideRequest.status == 0) {
      statusWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "50".tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: statusColor),
          ),
          const SizedBox(width: 8), // Space between text and loading dots
          ThreeDotLoading(color: statusColor, size: 10.0), // Your custom loading widget
        ],
      );
    } else if(rideRequest.status == 1) {
      statusWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "53".tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: statusColor),
          ),
          const SizedBox(width: 8), // Space between text and loading dots
          ThreeDotLoading(color: statusColor, size: 10.0), // Your custom loading widget
        ],
      );
    }else{statusWidget = Text(
        "51".tr,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: statusColor),
      );}

    return Scaffold(
      
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Here you can set your desired color for the back button and other AppBar icons
        ),
        title: Text('52'.tr, style: const TextStyle(color: Colors.white)),
        backgroundColor: statusColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            statusWidget, // Use the status widget here
            const SizedBox(height: 20), // Add some spacing
            Card(
              child: ListTile(
                leading: Icon(Icons.location_on, color: statusColor),
                title: Text('30'.tr),
                subtitle: Text(rideRequest.pickupName),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.flag, color: statusColor),
                title: Text('31'.tr),
                subtitle: Text(rideRequest.dropoffName),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: statusColor),
                title: Text('32'.tr),
                subtitle: Text(rideRequest.date),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.access_time, color: statusColor),
                title: Text('33'.tr),
                subtitle: Text(rideRequest.time),
              ),
            ),
            Card(
              child: ListTile(
                leading:
                    Icon(Icons.airline_seat_recline_normal, color: statusColor),
                title: Text('34'.tr),
                subtitle: Text(rideRequest.seats.toString()),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.attach_money, color: statusColor),
                title: Text('35'.tr),
                subtitle: Text('${rideRequest.price.toStringAsFixed(2)} JOD'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // This will space out children across the main axis.
  children: [
    // Left FloatingActionButton
    Padding(
      padding: const EdgeInsets.only(left: 32), // Adjust the padding as needed
      child: FloatingActionButton(
        heroTag: 'leftFAB',
        onPressed: () {
          controller.goTovehiclePage(rideRequest.driverid);
        }, // Example icon
        backgroundColor: Colors.green,
        child: const Icon(Icons.person_pin_outlined, color: Colors.white), // Example background color
      ),
    ),
    // Right FloatingActionButton
    FloatingActionButton(
      heroTag: 'rightFAB',
      onPressed: () {
        Get.dialog(
          AlertDialog(
            title: Text('44'.tr, textAlign: TextAlign.center),
            content: Text(
              "55".tr,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            actions: [
              TextButton(
                child: Text('26'.tr),
                onPressed: () => Get.back(),
              ),
              TextButton(
                child: Text('56'.tr),
                onPressed: () {
                  // Assuming controller and cancelTrip method exists
                  controller.cancelTrip(rideRequest.requestId);
                  Get.offAll(() => const Homepage()); // Close the dialog and navigate
                },
              ),
            ],
          ),
        );
      },
      backgroundColor: Colors.red,
      child: const Icon(Icons.cancel_outlined, color: Colors.white, size: 45),
    ),
  ],
)

      
    );
  }
}
