import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/config/utils.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../model/account_creation_params.dart';

class SignUpController {

   AccountCreationParams accountCreationParams = AccountCreationParams();

  final AuthService _signUpService ;

  SignUpController(this._signUpService);



  Future<void> signUp(AccountCreationParams accountCreationParams) async {
    try {
      await _signUpService.signUp(accountCreationParams);
    } catch (e,s) {
      log("$e $s");
      throw e;
    }
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
              Text("account_created_title".tr,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                fontSize: 20,
              ),),
              Text("account_created_body".tr,textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: HexColor.fromHex("#717088"),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                fontSize: 20,
              ),),
              SizedBox(height: 60,),
              ElevatedButton(onPressed: (){

                Get.toNamed(AppRoutes.login);
              }, child: Text("start_now".tr),style: AppTheme.outlinedButtonStyle,)
            ],
          ),
        ),
      ),
    );
  }

  void showExitAlert(BuildContext context) {
    Get.dialog(
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
              SvgPicture.asset("assets/icons/alert_rect.svg"),
              SizedBox(height: 20,),
              Text("alert_exit_title".tr,textAlign:TextAlign.center,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                fontSize: 20,
              ),),
              SizedBox(height: 20,),
              Text("alert_exit_body".tr,textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: HexColor.fromHex("#717088"),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                fontSize: 16,
              ),),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){

                Get.back();
              }, child: Text("complete_registration".tr),style: AppTheme.outlinedButtonStyle,),
              SizedBox(height: 20,),
              TextButton(onPressed: (){
                accountCreationParams = AccountCreationParams();
                Get.offNamed(AppRoutes.login);
              }, child: Text("exit_without_saving".tr,style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: HexColor.fromHex("#E62F29"),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                fontSize: 16,
              ),))
            ],
          ),
        ),
      ),
    );
  }




}
