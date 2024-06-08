// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get/get.dart';

// class DriverController extends GetxController {
//   var isWaiting = true.obs;
//   var driverName = ''.obs;
//   var driverCar = ''.obs;
//   var driverPhone = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     setupFCM();
//   }

//   void setupFCM() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.data['status'] == 'accepted') {
//         driverName.value = message.data['driver_name'];
//         driverCar.value = message.data['driver_car'];
//         driverPhone.value = message.data['driver_phone'];
//         isWaiting.value = false;
//       }
//     });
//   }
// }
