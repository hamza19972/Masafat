import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/core/constant/color.dart';
import 'package:masafat/view/screen/homepagev2.dart';
import 'package:masafat/view/widget/home/drawerone.dart';
import 'package:masafat/view/widget/home/homebody.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      // drawer:const Drawer(width: 250, child: Drawerone()),
      // appBar: AppBar(
      //   title:  Text('49'.tr),
      //   centerTitle: true,
        
        
      // ),
      body:  RideScreen()
    );
  }
}
