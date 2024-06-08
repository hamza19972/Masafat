import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:masafat/controller/auth/otpcodecontroller.dart';
import 'package:masafat/core/class/handlingdataview.dart';
import 'package:masafat/core/constant/color.dart';
import 'package:masafat/view/widget/auth/customtextbodyauth.dart';
import 'package:masafat/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
class VerfiyOtp extends StatelessWidget {
  const VerfiyOtp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     Get.put(OtpCodeControllerImp());
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60; // 60 seconds from now

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text('37'.tr,
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: AppColor.grey)),
      ),
      body: GetBuilder<OtpCodeControllerImp>(
          builder: (controller) => HandlingDataRequest(
              statusRequest: controller.statusRequest,
              widget: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: ListView(children: [
                  const SizedBox(height: 20),
                   CustomTextTitleAuth(text: "38".tr),
                  const SizedBox(height: 10),
                  CustomTextBodyAuth(text: "39".tr + " ${controller.phone}"),
                  const SizedBox(height: 15),
                  // Wrap the OtpTextField with Directionality
                  Directionality(
                    textDirection: TextDirection.ltr, // Force LTR direction
                    child: OtpTextField(
                      fieldWidth: 45.0,
                      borderRadius: BorderRadius.circular(20),
                      numberOfFields: 6,
                      borderColor: const Color(0xFF512DA8),
                      showFieldAsBox: true,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) {
                        controller.goToSuccessSignUp(verificationCode);
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  CountdownTimer(
                    endTime: endTime,
                    widgetBuilder: (_, CurrentRemainingTime? time) {
                      if (time == null) {
                        return InkWell(
                          onTap: () {
                            controller.reSend();
                            endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
                          },
                          child: Center(
                            child: Text("40".tr,
                                style: const TextStyle(
                                    color: AppColor.primaryColor, fontSize: 20)),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Resend in ${time.min ?? 0}:${(time.sec ?? 0).toString().padLeft(2, '0')}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }
                    },
                  ),
                ]),
              ))),
    );
  }
}
