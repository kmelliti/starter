import 'dart:developer';
import 'dart:ffi';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../core/config/app_constants.dart';
import '../core/di/di.dart';
import '../core/routes/app_routes.dart';
import '../core/services/app_service.dart';
import '../screens/products/controller/products_controller.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppServices appServices = getIt();
  final ProductController _productController = getIt();

  @override
  void initState() {

    super.initState();


    appServices.getBanks();
    appServices.getCities();
    appServices.getMerchantCategories();
    _productController.getProductCategories();

    bool isLoggedIn = appServices.getToken() != null;

    log("${appServices.getToken()}");
    Future.delayed(Duration(seconds: 4), () {
      if (isLoggedIn) {
        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {

         Get.offNamed(AppRoutes.mainScreen);

        });
      } else {
        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
          Get.offNamed(AppRoutes.login);
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/0484aab0c5a24014f17a6bf62f729f73711ad0ed.gif",
          height: 500,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

//git@github.com-giga:kmelliti/starter.git
