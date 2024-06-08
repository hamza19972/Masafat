import 'package:masafat/core/constant/routes.dart';
import 'package:masafat/core/middleware/mymiddleware.dart';

import 'package:masafat/view/screen/auth/verfiyotp.dart';
import 'package:masafat/view/screen/auth/welcome.dart';
import 'package:masafat/view/screen/driver_info_page.dart';
import 'package:masafat/view/screen/home/homepage.dart';
import 'package:masafat/view/screen/home/nameedit.dart';
import 'package:masafat/view/screen/language.dart';
import 'package:masafat/view/screen/onboarding.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
      name: "/", page: () => const Language(), middlewares: [MyMiddleWare()]),
  // GetPage(name: "/", page: () =>   TestView()),
//  Auth
  GetPage(name: AppRoute.welcome, page: () => Welcome()),
  GetPage(name: AppRoute.homepage, page: () => Homepage()),
  // GetPage(name: AppRoute.login, page: () => const Login()),

  GetPage(name: AppRoute.onBoarding, page: () => const OnBoarding()),
  GetPage(name: AppRoute.VerfiyOtp, page: () => const VerfiyOtp()),
  GetPage(name: AppRoute.nameedit, page: () => const NameEdit()),
   GetPage(name: '/driver_info', page: () => DriverInfoPage()),

  //
  // GetPage(name: AppRoute.homepage, page: () => const HomeScreen()),

  // GetPage(name: AppRoute.addressadddetails, page: () => const AddressAddDetails()),
];
