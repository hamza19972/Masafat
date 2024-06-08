import 'package:masafat/controller/onboarding_controller.dart';
import 'package:masafat/core/constant/color.dart';
import 'package:masafat/view/widget/onboarding/custombutton.dart';
import 'package:masafat/view/widget/onboarding/customslider.dart';
import 'package:masafat/view/widget/onboarding/dotcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OnBoardingControllerImp()) ;
    return const Scaffold(
        backgroundColor: AppColor.backgroundcolor,
        body: SafeArea(
          minimum: EdgeInsets.only(top: 100),
          child: Column(children: [
            Expanded(
              flex: 4,
              child: CustomSliderOnBoarding(),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    CustomDotControllerOnBoarding(),
                    Spacer(flex: 2),
                    CustomButtonOnBoarding()
                  ],
                ))
          ]),
        ));
  }
}
