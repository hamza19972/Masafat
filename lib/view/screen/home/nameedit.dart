import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/controller/editname.dart';

class NameEdit extends StatelessWidget {
  const NameEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditNameController controller = Get.put(EditNameController());

    return Scaffold(
      appBar: AppBar(
        title:  Text('70'.tr),
        backgroundColor: Colors.white,
      ),
      body: GetBuilder<EditNameController>(
        builder:(controller) =>  SingleChildScrollView(
          child: Form(
            key: controller.formstate,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: controller.name,
                    decoration:  InputDecoration(
                      labelText: '71'.tr,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.surename,
                    decoration:  InputDecoration(
                      labelText: '72'.tr,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                   Text('73'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  RadioListTile<String>(
                    title:  Text('74'.tr),
                    value: 'male',
                    groupValue: controller.gender,
                    onChanged: (value) => controller.setGender(value!),
                  ),
                  RadioListTile<String>(
                    title:  Text('75'.tr),
                    value: 'female',
                    groupValue: controller.gender,
                    onChanged: (value) => controller.setGender(value!),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.formstate.currentState!.validate()) {
                          controller.insertName();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        side: const BorderSide(color: Colors.green), // Added border color
                      ),
                      child:  Text(
                        '76'.tr,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
