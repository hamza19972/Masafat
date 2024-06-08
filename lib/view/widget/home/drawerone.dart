import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/controller/drawercontrtoller.dart';
import 'package:masafat/core/constant/color.dart';
import 'package:masafat/view/screen/mytrip.dart';
import 'package:masafat/view/screen/mytripsv2.dart';
import 'package:url_launcher/url_launcher.dart';

class Drawerone extends StatelessWidget {
  const Drawerone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    return GetBuilder<UserController>(
      builder: (userController) => ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:
                Text(userController.username! + " " + userController.surename!),
            accountEmail: Text("0${userController.phone}"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "M",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: const BoxDecoration(
              color: AppColor.primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.drive_eta),
            title: Text('28'.tr),
            onTap: () {
              Get.to(() => MyTripsv2());
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.help),
            title: Text('42'.tr),
            onTap: () {
              launchUrl(Uri.parse("tel:00962771643128"));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('21'.tr),
            onTap: () {
              // Update the state of the app
              // Then close the drawer
              userController.logOut();
            },
          ),
        ],
      ),
    );
  }
}
