import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/services/auth_services.dart';

import '../../../core/config/utils.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class ResetPasswordController {

  final AuthService authService;

  ResetPasswordController(this.authService);

  String? code ;
  Map<String,dynamic>? userContacts;

  Future<String> codeResetPassword(Map<String,dynamic> params) async {
    return authService.codeResetPassword(params);
  }

  Future<String> resetPassword(Map<String,dynamic> params) async {
      return authService.resetPassword(params);
  }

  void showSuccessDialog(BuildContext context) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20),),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/check_green.svg"),
              SizedBox(height: 20,),
              Text("password_updated".tr,textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: HexColor.fromHex("#717088"),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                fontSize: 16,
              ),),
              SizedBox(height: 40,),
              ElevatedButton(onPressed: (){

                Get.toNamed(AppRoutes.login);
              }, child: Text("start_now".tr),style: AppTheme.outlinedButtonStyle,)
            ],
          ),
        ),
      ),
    );
  }


}