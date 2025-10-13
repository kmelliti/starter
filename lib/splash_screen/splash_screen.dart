import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter/core/di/di.dart';

import '../screens/login/presentation/pages/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkUser(),
        builder: (context, snap) {
          if(snap.hasData){
            WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_){

              Get.to(()=> LoginPage());
            });
          }
          return Center(child: Text("Welcome"));
        },
      ),
    );
  }

  Future<bool?> checkUser() async {
    final SharedPreferences prefs = getIt();
    final bool isLogin = prefs.getBool('isLogin') ?? false;
    await Future.delayed(Duration(seconds: 3));
    return isLogin;
  }
}
