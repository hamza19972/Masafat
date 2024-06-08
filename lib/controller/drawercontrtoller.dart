// UserController.dart
import 'package:get/get.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/core/constant/routes.dart';
import 'package:masafat/core/services/services.dart';

class UserController extends GetxController {
  StatusRequest statusRequest = StatusRequest.none;
  MyServices myServices = Get.find();
  String? username;
  String? surename;
  String? phone;

  @override
  void onInit() {
    
    username = myServices.sharedPreferences.getString("username");
    surename = myServices.sharedPreferences.getString("surename");
    phone = myServices.sharedPreferences.getString("phone");
    super.onInit();
  }

  void logOut(){
    myServices.sharedPreferences.clear();
    Get.offAllNamed(AppRoute.welcome);
  }
}
