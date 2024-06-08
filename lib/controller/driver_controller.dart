import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverController extends GetxController {
  var driverName = ''.obs;
  var driverCar = ''.obs;
  var driverPhone = ''.obs;
  var driverPic = ''.obs;
  var driverID = ''.obs;
  var tripID = ''.obs;
  var registrationNumber = ''.obs;
  var model = ''.obs;

  @override
  void onInit() {
    super.onInit();
    setupFCM();
    checkDriverInfo();
  }

  void setupFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleNotificationData(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationData(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        handleNotificationData(message.data);
      }
    });
  }

  void handleNotificationData(Map<String, dynamic> data) async {
    if (data['screen'] == 'driver_info') {
      driverName.value = data['driver_name'];
      driverCar.value = data['make'];
      driverPhone.value = data['driver_phone'];
      driverPic.value = data['driver_picture_url'];
      driverID.value = data['driverID'];
      tripID.value = data['trip_id'];
      registrationNumber.value = data['registration_number'];
      model.value = data['model'];

      // Save data in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('driver_name', driverName.value);
      await prefs.setString('driver_car', driverCar.value);
      await prefs.setString('driver_phone', driverPhone.value);
      await prefs.setString('driver_picture_url', driverPic.value);
      await prefs.setString('driver_id', driverID.value);
      await prefs.setString('trip_id', tripID.value);
      await prefs.setString('registration_number', registrationNumber.value);
      await prefs.setString('model', model.value);

      Get.offNamed('/driver_info');
    } else if (data['status'] == 'declined') {
      Get.dialog(
        AlertDialog(
          title: Text('61'.tr),
          content: Text('62'.tr),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('27'.tr),
            ),
          ],
        ),
      );
    }
  }

  void checkDriverInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('driver_name');
    String? car = prefs.getString('driver_car');
    String? phone = prefs.getString('driver_phone');
    String? pic = prefs.getString('driver_picture_url');
    String? id = prefs.getString('driver_id');
    String? tripId = prefs.getString('trip_id');
    String? regNumber = prefs.getString('registration_number');
    String? carModel = prefs.getString('model');

    if (name != null && car != null && phone != null && pic != null && id != null && tripId != null && regNumber != null && carModel != null) {
      driverName.value = name;
      driverCar.value = car;
      driverPhone.value = phone;
      driverPic.value = pic;
      driverID.value = id;
      tripID.value = tripId;
      registrationNumber.value = regNumber;
      model.value = carModel;
      Get.offNamed('/driver_info');
    }
  }

}
