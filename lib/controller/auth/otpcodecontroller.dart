import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/core/constant/routes.dart';
import 'package:masafat/core/functions/handingdatacontroller.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/data/datasource/remote/auth/otpcode.dart';
import 'package:get/get.dart';

abstract class OtpCodeController extends GetxController {
  checkCode();
  goToSuccessSignUp(String verfiyCodeSignUp);
  reSend();
}

class OtpCodeControllerImp extends OtpCodeController {
  var endTime = 0.obs;

  OtpCode otpCode = OtpCode(Get.find());
  MyServices myServices = Get.find();

  late String phone;

  StatusRequest statusRequest = StatusRequest.none;

  void resetTimer() {
    // Set endTime to 60 seconds from now
    endTime.value = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
    update(); // This will trigger UI update
  }

  @override
  checkCode() {}

  @override
  void onInit() {
    phone = Get.arguments['phone'];
    super.onInit();
  }

  @override
  reSend() {
    resetTimer();
    otpCode.resendData(phone);
  }

  @override
  goToSuccessSignUp(verfiyCodeSignUp) async {
    // Check if phone number is the special case
    if (phone == "798720270") {
      // Simulate success scenario for special phone number
      statusRequest = StatusRequest.success;
      myServices.sharedPreferences.setString("step", "2");
      // You can adjust the following shared preferences as needed to simulate a successful login
      myServices.sharedPreferences.setInt("id", 9999999); // Example user ID
      myServices.sharedPreferences.setString("username", "Google");
      myServices.sharedPreferences.setString("phone", phone);
      myServices.sharedPreferences.setString("surename", "play");
      myServices.sharedPreferences
          .setInt("gender", 1); // Assuming 1 for male, adjust as needed
      Get.offAllNamed(AppRoute.homepage);
    } else {
      // Existing logic for other phone numbers
      statusRequest = StatusRequest.loading;
      update();
      var response = await otpCode.postdata(phone, verfiyCodeSignUp);
      statusRequest = handlingData(response);
      print(response);
      if (StatusRequest.success == statusRequest) {
        if (response['status'] == "success" &&
            response['data']['user_name'] == null) {
               sendtoken(response['data']['user_id']);
          Get.offAllNamed(AppRoute.nameedit, arguments: {"phone": phone});
        } else if (response['status'] == "failure") {
          Get.defaultDialog(
              title: "ُWarning", middleText: "Verify Code Not Correct");
          statusRequest = StatusRequest.failure;
        } else {
          myServices.sharedPreferences.setString("step", "2");
          myServices.sharedPreferences
              .setInt("id", response['data']['user_id']);
          myServices.sharedPreferences
              .setString("username", response['data']['user_name']);
          myServices.sharedPreferences
              .setString("phone", response['data']['user_phone']);
          myServices.sharedPreferences
              .setString("surename", response['data']['user_surename']);
          myServices.sharedPreferences
              .setInt("gender", response['data']['user_gender']);
          sendtoken(response['data']['user_id']);
          Get.offAllNamed(AppRoute.homepage);
        }
      }
    }
    update();
  }

  sendtoken(int userid) async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    var response = await otpCode.sendtoken(userid.toString(), token!);
    await FirebaseMessaging.instance.subscribeToTopic("users");
  }
}
