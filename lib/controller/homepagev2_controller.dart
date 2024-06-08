// ride_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masafat/core/class/statusrequest.dart';
import 'package:masafat/core/services/services.dart';
import 'package:masafat/data/datasource/remote/lanesdata.dart';
import 'package:masafat/view/screen/trips.dart';

class City {
  final int cityId;
  final String cityName;
  final String cityNamear;

  City({required this.cityId, required this.cityName,required this.cityNamear});

  factory City.fromJson(Map<dynamic, dynamic> json) {
    return City(
      cityId: json['city_id'],
      cityName: json['city_name'],
      cityNamear: json['city_name_ar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city_id': cityId,
      'city_name': cityName,
      'city_name_ar': cityNamear,
    };
  }
}

class CityResponse {
  final String status;
  final List<City> data;

  CityResponse({required this.status, required this.data});

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<City> cityList = dataList.map((i) => City.fromJson(i)).toList();

    return CityResponse(
      status: json['status'],
      data: cityList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((city) => city.toJson()).toList(),
    };
  }
}

class Route {
  final int routeId;
  final String startProvince;
  final String endProvince;
  final String start;
  final String end;
  final double price;

  Route({
    required this.routeId,
    required this.startProvince,
    required this.endProvince,
    required this.start,
    required this.end,
    required this.price,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      routeId: json['RouteID'],
      startProvince: json['StartProvince'],
      endProvince: json['EndProvince'],
      start: json['start'],
      end: json['end'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RouteID': routeId,
      'StartProvince': startProvince,
      'EndProvince': endProvince,
      'start': start,
      'end': end,
      'price': price,
    };
  }
}

class RouteResponse {
  final String status;
  final List<Route> data;

  RouteResponse({required this.status, required this.data});

  factory RouteResponse.fromJson(Map<String, dynamic> json) {
    var routeList = json['data'] as List;
    List<Route> routes =
        routeList.map((routeJson) => Route.fromJson(routeJson)).toList();

    return RouteResponse(
      status: json['status'],
      data: routes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((route) => route.toJson()).toList(),
    };
  }
}

class RideController extends GetxController {
  var cityList = <City>[].obs;
  var routes = <Route>[].obs;
  var departureCity = ''.obs;
  var arrivalCity = ''.obs;
  var seatCount = 1.obs;
  var statusRequest = StatusRequest.loading.obs;
  LanesData lanesData = LanesData(Get.find());
   var discountPercentage = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var voucherCodeController = TextEditingController();
  String voucher="NO";
  MyServices myServices = Get.find();
  String? lang;

  @override
  void onInit() {
    super.onInit();
    getCities();
    lang = myServices.sharedPreferences.getString("lang");
  }

  Future<void> getCities() async {
  try {
    var response = await lanesData.getData();
    if (response['status'] == "success") {
      List<dynamic> cityData = response['data'];
      cityList.value = cityData.map((city) => City.fromJson(city)).toList();
      statusRequest.value = StatusRequest.success;
       update(['cities']);
    } else {
      statusRequest.value = StatusRequest.failure;
    }
  } catch (e) {
    statusRequest.value = StatusRequest.failure;
  }
  update(['cities']);
  update(); // Notify listeners that cities data has been updated
}


  void updateDepartureCity(String city) {
    if (departureCity.value != city) {
      departureCity.value = city;
      update(['departure']);
      getRoutes();
    }
  }

  void updateArrivalCity(String city) {
    if (arrivalCity.value != city) {
      arrivalCity.value = city;
      update(['arrival']);
      getRoutes();
    }
  }

  Future<void> getRoutes() async {
    try {
      var response =
          await lanesData.getRoutes(departureCity.value, arrivalCity.value);
      if (response['status'] == "success") {
        List<dynamic> routeData = response['data'];
        routes.value = routeData.map((route) => Route.fromJson(route)).toList();
        update(['routes']);
      } else {
        routes.clear();
        update(['routes']);
      }
    } catch (e) {
      routes.clear();
      update(['routes']);
    }
  }

  void updateSeatCount(int count) {
    if (seatCount.value != count) {
      seatCount.value = count;
      update(['seats']);
      update();
    }
    
  }

  void validateVoucher() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await http.post(
      Uri.parse('http://93.127.163.86/auth/validate_voucher.php'),
      body: {'voucher_code': voucherCodeController.text},
    );

    isLoading.value = false;
   
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success']) {
        voucher=voucherCodeController.text;
        try {
          discountPercentage.value = int.parse(result['discount_percentage'].toString());
          Get.snackbar(
            '63'.tr, 
            '${'64'.tr}${discountPercentage.value}%',
            backgroundColor: Colors.green, 
            colorText: Colors.white,
          );
        } catch (e) {
          print(response);
          errorMessage.value = 'Invalid discount percentage format';
          Get.snackbar(
            '65'.tr, 
            errorMessage.value, 
            backgroundColor: Colors.red, 
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = result['message'];
        Get.snackbar(
          '65'.tr, 
          errorMessage.value, 
          backgroundColor: Colors.red, 
          colorText: Colors.white,
        );
      }
    } else {
      errorMessage.value = 'Failed to validate voucher';
      Get.snackbar(
        '65'.tr, 
        errorMessage.value, 
        backgroundColor: Colors.red, 
        colorText: Colors.white,
      );
    }
    update();
  }

  gotoTrips(String routeID,double price){
  
  Get.to(()=> TripsScreen(),arguments: {"routeID":routeID,"seats":seatCount.value,"price":price,"voucher":voucher});
  }
}
