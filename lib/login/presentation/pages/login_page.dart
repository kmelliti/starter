import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:starter/core/config/utils.dart';


import '../../../../core/di/di.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../manager/login_controller.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  final TextEditingController usernameController = TextEditingController(text: "souhaib1@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "souhaib1");

  final LoginController _loginController = getIt();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> showPassword= ValueNotifier(false);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
                SvgPicture.asset(
                  "assets/icons/logo.svg",
                  height: 90,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 60,
                ),
                Text(
                  "login".tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(hintText: "username".tr)
                        .applyDefaults(Theme.of(context).inputDecorationTheme),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: ValueListenableBuilder(
                    valueListenable: showPassword,
                    builder: (context,val,_) {
                      return TextField(
                        controller: passwordController,
                        obscureText: !val ,
                        decoration: InputDecoration(hintText: "password".tr,
                        suffixIcon: IconButton(
                          icon: Icon(
                            val ? Icons.visibility : Icons.visibility_off,
                            color: HexColor.fromHex(AppTheme.primaryColor),
                          ),
                          onPressed: () {

                              showPassword.value = !showPassword.value;

                          },
                        ),
                        )
                            .applyDefaults(Theme.of(context).inputDecorationTheme),
                      );
                    }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.resetPassword);
                      },
                      child: Text(
                        "forgot_password".tr,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ValueListenableBuilder(
                    valueListenable: isLoading,
                    builder: (context, value, child) {
                      return value ?  Center(child: getLoader()) : ElevatedButton(onPressed: () async{

                        if(passwordController.text.isNotEmpty && usernameController.text.isNotEmpty){
                          try{
                            isLoading.value = true;
                            await _loginController.signIn(usernameController.text, passwordController.text);
                            Get.toNamed(AppRoutes.mainScreen);
                          }catch(e,s){
                            log("$e $s");
                            handleException(context, e);
                          }

                          isLoading.value = false;
                        }

                      }, child: Text("login".tr));
                    }
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.signUp);
                    },
                    style: AppTheme.outlinedButtonStyle,
                    child: Text("create_account".tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
