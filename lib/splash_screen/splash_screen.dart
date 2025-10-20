import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter/core/di/di.dart';
import 'package:starter/screens/forget_pass1.dart';
import 'package:starter/screens/login/presentation/pages/log_in.dart';
import 'package:starter/screens/login/presentation/pages/sign_up2.dart';

import '../screens/login/presentation/pages/sign_up1.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkUser(),
        builder: (context, snap) {
          if (snap.hasData) {
            WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
              Get.to(() => LoginPage());
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
