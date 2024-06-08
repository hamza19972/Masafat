import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/controller/homepagev2_controller.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/view/widget/home/drawerone.dart';

class RideScreen extends StatelessWidget {
  final RideController rideController = Get.put(RideController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:const Drawer(width: 250, child: Drawerone()),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "83".tr,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              height: 300,
            ),
          ),
          GetBuilder<RideController>(builder: (controller) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    citySelectionWidget('84'.tr, true),
                    SizedBox(height: 20),
                    citySelectionWidget('85'.tr, false),
                    SizedBox(height: 20),
                    Text(
                      '86'.tr,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    seatSelectionSlider(),
                    SizedBox(height: 20),
                    applyVoucherSection(),
                    SizedBox(height: 20),
                    routeDisplaySection(),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget citySelectionWidget(String label, bool isDeparture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        GetBuilder<RideController>(
            id: isDeparture ? 'departure' : 'arrival',
            builder: (controller) {
              return SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.cityList.length,
                  itemBuilder: (context, index) {
                    final city = controller.cityList[index];
                    String cityName = controller.lang == 'ar' ? city.cityNamear : city.cityName;
                    bool isSelected = (isDeparture
                        ? controller.departureCity.value == city.cityName
                        : controller.arrivalCity.value == city.cityName);
                    return GestureDetector(
                      onTap: () {
                        if (isDeparture) {
                          controller.updateDepartureCity(city.cityName);
                        } else {
                          controller.updateArrivalCity(city.cityName);
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: isSelected ? Colors.green.shade700 : Colors.green),
                        ),
                        child: Center(
                          child: Text(
                            cityName,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color.fromARGB(255, 18, 75, 19),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
      ],
    );
  }

  Widget seatSelectionSlider() {
    return GetBuilder<RideController>(
        id: 'seats',
        builder: (controller) {
          return Row(
            children: [
              Text('34'.tr, style: TextStyle(color: Colors.black54)),
              Expanded(
                child: Slider(
                  value: controller.seatCount.value.toDouble(),
                  min: 1,
                  max: 4,
                  divisions: 3,
                  label: controller.seatCount.value.toString(),
                  onChanged: (value) => controller.updateSeatCount(value.toInt()),
                  activeColor: Colors.green,
                  inactiveColor: Colors.green.shade100,
                ),
              ),
            ],
          );
        });
  }

  Widget applyVoucherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('87'.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: rideController.voucherCodeController,
                decoration: InputDecoration(
                  hintText: '88'.tr,
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                rideController.validateVoucher();
              },
              child: Text('89'.tr, style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        GetBuilder<RideController>(
          builder: (controller) {
            if (controller.discountPercentage.value > 0) {
              return Text(
                '90'.tr+ '${controller.discountPercentage.value}%',
                style: TextStyle(color: Colors.green, fontSize: 16),
              );
            } else if (controller.errorMessage.isNotEmpty) {
              return Text(
                controller.errorMessage.value,
                style: TextStyle(color: Colors.red, fontSize: 16),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  Widget routeDisplaySection() {
    return GetBuilder<RideController>(
        id: 'routes',
        builder: (controller) {
          if (controller.statusRequest.value == StatusRequest.success &&
              controller.routes.isNotEmpty) {
            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.routes.length,
              separatorBuilder: (_, __) => Divider(color: Colors.grey[300], height: 1),
              itemBuilder: (context, index) {
                final route = controller.routes[index];
                double totalPrice = (route.price * controller.seatCount.value);
                if (rideController.discountPercentage.value > 0) {
                  totalPrice *= (1 - rideController.discountPercentage.value / 100);
                }
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      controller.gotoTrips(route.routeId.toString(), totalPrice);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.directions_car, color: Colors.green.shade700, size: 30),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${route.start} to ${route.end}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                                ),
                                Text(
                                  'من ${route.startProvince} إلى ${route.endProvince}',
                                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Price: ${totalPrice.toStringAsFixed(2)} JOD',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.green.shade700),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (controller.statusRequest.value == StatusRequest.loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('91'.tr));
          }
        });
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 4, size.height - 100, size.width / 2, size.height - 50);
    path.quadraticBezierTo(3 / 4 * size.width, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
