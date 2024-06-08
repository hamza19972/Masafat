import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/view/screen/rating_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:masafat/controller/driver_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverInfoPage extends StatelessWidget {
  final DriverController controller = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '78'.tr,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(controller.driverPic.value),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '78'.tr,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 20),
            InfoCard(
              title: '79'.tr,
              content: controller.driverName.value,
              icon: Icons.person,
            ),
            SizedBox(height: 10),
            InfoCard(
              title: '80'.tr,
              content: controller.driverCar.value+' '+controller.model.value,
              icon: Icons.directions_car,
            ),
            SizedBox(height: 10),
            InfoCard(
              title: '81'.tr,
              content: controller.registrationNumber.value,
              icon: Icons.format_list_numbered,
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: (){launchUrl(Uri.parse("tel:0${controller.driverPhone.value}"));},
              child: InfoCard(
                title: '82'.tr,
                content: "0${controller.driverPhone.value}",
                icon: Icons.phone,
                
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('driver_name');
                  await prefs.remove('driver_car');
                  await prefs.remove('driver_phone');
                  await prefs.remove('driver_picture_url');
                  await prefs.remove('driver_id');
                  await prefs.remove('trip_id');
                  await prefs.remove('registration_number');
                  await prefs.remove('model');
                  Get.to(() =>RatingScreen(),arguments: {"driverID":controller.driverID.value});
                },
                child: Text('77'.tr),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  InfoCard({required this.title, required this.content, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: InfoCardClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.green),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(content),
        ),
      ),
    );
  }
}

class InfoCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 20);
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
    path.lineTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, 20);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
