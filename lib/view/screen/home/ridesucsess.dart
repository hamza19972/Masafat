import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/core/constant/color.dart';
import 'package:masafat/view/screen/home/homepage.dart';

class RideSuccess extends StatelessWidget {
  const RideSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColor.primaryColor,
              size: 100, // Larger icon for more impact
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Text(
                "47".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, // Larger font size for readability
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 30), // Add some space before the button
            MaterialButton(
              onPressed: () {
                Get.offAll(() => const Homepage());
              },
              color: AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Make the button larger
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners for a modern look
              ), // Use the app's primary color
              child: Text(
                '48'.tr,
                style: const TextStyle(
                  color: Colors.white, // Text color that contrasts with the button color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
