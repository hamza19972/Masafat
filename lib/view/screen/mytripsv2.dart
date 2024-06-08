import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/controller/mytripsv2_controller.dart';
import 'package:masafat/view/screen/home/homepage.dart';

class MyTripsv2 extends StatelessWidget {
  final TripController tripController = Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('28'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (tripController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (tripController.trips.isEmpty) {
          return Center(child: Text('105'.tr));
        } else {
          return ListView.builder(
            itemCount: tripController.trips.length,
            itemBuilder: (context, index) {
              return TripCard(trip: tripController.trips[index]);
            },
          );
        }
      }),
    );
  }
}

class TripCard extends StatelessWidget {
  final Tripv2 trip;

  TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showCancelDialog(context, trip);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.green, width: 1),
        ),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.green[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(trip),
                const SizedBox(height: 6),
                const Divider(color: Colors.grey),
                const SizedBox(height: 6),
                _buildSectionHeader('106'.tr),
                _buildTripDetail(Icons.numbers, '107'.tr, trip.id.toString()),
                _buildTripDetail(Icons.calendar_today, '108'.tr, '${trip.createdAt.toLocal()}'.split('.')[0]),
                _buildTripDetail(Icons.attach_money, '109'.tr, '${trip.price} JOD', highlight: true),
                _buildTripDetail(Icons.event_seat, '110'.tr, '${trip.seatsBooked}'),
                _buildSectionHeader('111'.tr),
                _buildTripDetail(Icons.location_on, '18'.tr, trip.pickupAddress),
                _buildTripDetail(Icons.location_off, '17'.tr, trip.dropoffAddress),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Tripv2 trip) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Chip(
          label: Text(
            trip.status,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: _getStatusColor(trip.status),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Icon(
          _getStatusIcon(trip.status),
          color: _getStatusColor(trip.status),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTripDetail(IconData icon, String title, String detail, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Text(
            '$title ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              detail,
              style: TextStyle(
                color: highlight ? Colors.green : Colors.black87,
                fontSize: 16,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'declined':
        return Colors.red;
        case 'Canceled':
        return Colors.black;
        case 'driverCanceled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'declined':
        return Icons.cancel;
        case 'Canceled':
        return Icons.cancel;
        case 'driverCanceled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  void _showCancelDialog(BuildContext context, Tripv2 trip) {
      final TripController oneuse = Get.put(TripController());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('26'.tr),
          content: Text('55'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('26'.tr),
            ),
            TextButton(
              onPressed: () {
                oneuse.cancelTrip(trip.id);
                Get.offAll(()=>const Homepage());
              },
              child: Text('56'.tr),
            ),
          ],
        );
      },
    );
  }
}
