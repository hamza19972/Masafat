import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:masafat/controller/rating_controller.dart';

class RatingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RatingController controller = Get.put(RatingController());

    return Scaffold(
      appBar: AppBar(
        title: Text('113'.tr),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                '113'.tr,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: FaIcon(
                          index < controller.rating.value ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                          size: 36,
                        ),
                        color: Colors.amber,
                        onPressed: () {
                          controller.rating.value = index + 1;
                        },
                      );
                    }),
                  )),
              SizedBox(height: 20),
              TextField(
                controller: controller.commentController,
                decoration: InputDecoration(
                  labelText: '114'.tr,
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => controller.submitRating(), // Pass the driver ID here
                icon: Icon(Icons.send),
                label: Text('115'.tr),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
