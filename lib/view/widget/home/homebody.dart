import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/controller/driver_controller.dart';
import 'package:masafat/core/constant/color.dart';
import 'package:masafat/view/screen/home/finalmap.dart';
import 'package:masafat/view/screen/homepagev2.dart';

class Homebody extends StatelessWidget {
   Homebody({super.key});
  DriverController controller = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    var isRtl = Directionality.of(context) == TextDirection.rtl;
    var dynamicPadding =
        isRtl ? const EdgeInsets.only(right: 16.0) : const EdgeInsets.only(left: 16.0);

    return ListView(children: [
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 2.0),
      //   child: TextField(
      //     decoration: InputDecoration(
      //       filled: true,
      //       fillColor: Colors.white,
      //       prefixIcon: const Icon(Icons.search),
      //       hintText: 'Search',
      //       alignLabelWithHint: true,
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(20),
      //         borderSide: BorderSide.none,
      //       ),
      //     ),
      //   ),
      // ),
      const SizedBox(height: 15),
      Padding(
        padding: dynamicPadding,
        child: Text(
          "43".tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 10),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 120,
              width: 90,
              child: InkWell(
                onTap: () {
                  Get.to(() =>  RideScreen());
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/luggage.gif",
                    ),
                    Text("13".tr,textAlign: TextAlign.center,)
                  ],
                ),
              )),
          const SizedBox(width: 30),
          SizedBox(
            height: 146,
            width: 90,
            child: InkWell(
              onTap: () {
                Get.dialog(
                  const Center(
                      child: Text(
                    "Soon",
                    style: TextStyle(color: AppColor.secondColor),
                  )),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/route.gif",
                  ),
                  Text(
                    "14".tr,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ]);
  }
}
