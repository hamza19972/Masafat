import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/core/functions/handingdatacontroller.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/data/datasource/remote/auth/otpcode.dart';
import 'package:masafat/data/datasource/remote/editnamedata.dart';
import 'package:masafat/view/screen/home/homepage.dart';

class EditNameController extends GetxController {
  String gender = 'male';
  EditNameData editNameData = EditNameData(Get.find());

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  MyServices myServices = Get.find();

  StatusRequest statusRequest = StatusRequest.none;

  String? phone;

  late TextEditingController name;
  late TextEditingController surename;

  @override
  void onInit() {
    phone = Get.arguments['phone'];
    name = TextEditingController();
    surename = TextEditingController();

    super.onInit();
  }

  void setGender(String value) {
    gender = value;
    update();
  }

  

  insertName() async {
    if (gender == "male") {
      gender = "1";
    } else {
      gender = "0";
    }
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var response = await editNameData.postdata(
          name.text, surename.text, phone.toString(), gender);
      print("=============================== Controller $response ");
      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success") {
          myServices.sharedPreferences
              .setInt("id", response['data']['user_id']);
          myServices.sharedPreferences.setString("step", "2");
          myServices.sharedPreferences
              .setString("username", response['data']['user_name']);
          myServices.sharedPreferences
              .setString("surename", response['data']['user_surename']);
          myServices.sharedPreferences
              .setInt("gender", response['data']['user_gender']);
          myServices.sharedPreferences
              .setString("phone", response['data']['user_phone']);
          Get.offAll(() => Homepage());

          update();
        } else {
          Get.showSnackbar(GetSnackBar(
            message: "22".tr,
          ));
        }
      }
    }
  }
}
