import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/controller/driverinfocontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class VehiclePage extends StatelessWidget {
  final DriverInofController vehicleController = Get.put(DriverInofController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('60'.tr,style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.green, // Updated color
        elevation: 0,
      ),
      body: GetBuilder<DriverInofController>(
        builder: (controller) {
          return controller.vehicle.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.vehicle.length,
                  itemBuilder: (context, index) {
                    final vehicle = controller.vehicle[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ClipOval(
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/loading.gif', // Placeholder image
                                image: vehicle.driverPictureUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Captain : ${vehicle.driverName}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InfoRow(title: "Car Model", value: "${vehicle.make} ${vehicle.model}"),
                            InfoRow(title: "58".tr, value: "${vehicle.registrationNumber}"),
                            InfoRow(title: "12".tr, value: "0${vehicle.driverPhone}"),
                            const SizedBox(height: 15),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.phone, color: Colors.white),
                              label: Text('59'.tr),
                              onPressed: () => launchUrl(Uri.parse("tel:0${vehicle.driverPhone}")),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green, // background (button) color
                                onPrimary: Colors.white, // foreground (text) color
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text('57'.tr),
                );
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
