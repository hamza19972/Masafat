import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/view/screen/home/homepage.dart';

class RatingController extends GetxController {
  var rating = 0.obs;
  var commentController = TextEditingController();
  String? driverId;
  MyServices myServices = Get.find();

  @override
  void onInit() {
    super.onInit();
    driverId=Get.arguments['driverID'];
  }

  void submitRating() async {
    int? userid=myServices.sharedPreferences.getInt("id");
    if (rating.value > 0) {
      var response = await http.post(
        Uri.parse('http://93.127.163.86/driver/submit_rating.php'),
        body: {
          'driver_id': driverId.toString(),
          'rating': rating.value.toString(),
          'comment': commentController.text,
          'user_id': userid.toString(),
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('63'.tr, '67'.tr, backgroundColor: Colors.green, colorText: Colors.white);
        commentController.clear();
        rating.value = 0;
        Get.offAll(()=>Homepage());
      } else {
        Get.snackbar('65'.tr, '68'.tr, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar('65'.tr, '69'.tr, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
