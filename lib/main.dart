import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:masafat/bindings/intialbindings.dart';
import 'package:masafat/core/localization/translation.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/localization/changelocal.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  if (message.data['screen'] == 'driver_info') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('driver_name', message.data['driver_name']);
    await prefs.setString('driver_car', message.data['make']);
    await prefs.setString('driver_phone', message.data['driver_phone']);
  await prefs.setString('driver_picture_url', message.data['driver_picture_url']);
  await prefs.setString('driver_id', message.data['driver_id']);
      await prefs.setString('trip_id', message.data['trip_id']);
      await prefs.setString('registration_number', message.data['registration_number']);
      await prefs.setString('model', message.data['model']);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'Masafat',
      locale: controller.language,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: InitialBindings(),
      getPages: routes,
      //  home: WaitingForDriverPage(),
    );
  }
}
