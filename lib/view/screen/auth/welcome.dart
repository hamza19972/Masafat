import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/controller/auth/welcome/welcome_controller.dart';
import 'package:masafat/core/functions/validinput.dart';
import 'package:masafat/view/widget/welcome/phonefield.dart';
import 'package:masafat/view/widget/welcome/welcomebutton.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WelcomeControllerImp());
    return Scaffold(
      body: GetBuilder<WelcomeControllerImp>(
        builder: (controller) => Form(
          key: controller.formstate,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.greenAccent, Colors.green],
              ),
            ),
            child: SingleChildScrollView( // Use SingleChildScrollView to avoid overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 80), // Adjust spacing as needed
                  // App Logo
                  Image.asset(
                    'assets/images/logo8.png', // Path to your logo image
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 5), // Space between logo and app name
                  // App Name
                  const Text(
                    'Masafat', // Replace with your app name
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40), // Adjust spacing as needed
                  Phonefield(
                    hinttext: "12".tr,
                    iconData: Icons.phone_enabled_outlined,
                    isNumber: true,
                    labeltext: "12".tr,
                    mycontroller: controller.phone,
                    valid: (val) {
                      return validInput(val!, 9, 14, "phone");
                    },
                    onTapIcon: () {},
                  ),
                  const SizedBox(height: 20), // Adjust spacing as needed
                  Welcomebutton(
                    buttontext: "9".tr,
                    color: const Color.fromARGB(255, 102, 139, 126),
                    onClic: () {
                      controller.login();
                    },
                  ),
                  const SizedBox(height: 20), // Space before checkbox
                  // User Agreement Checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '41'.tr, // Your agreement text
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 400), // Adjust spacing as needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
