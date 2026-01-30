import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../core/config/utils.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/reset_step_one.dart';
import '../widgets/reset_step_three.dart';
import '../widgets/reset_step_two.dart';

class ResetPassword extends StatelessWidget {
   ResetPassword({super.key});

  final ValueNotifier<int> steps = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              

              Row(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: 0.5 + (value * 0.5),
                          child: InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: HexColor.fromHex(AppTheme.primaryColor),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 30,),
                  Text("reset_password".tr,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: HexColor.fromHex(AppTheme.primaryColor),
                  ),),
                ],
              ),


              Expanded(
                child: ValueListenableBuilder(valueListenable: steps, builder: (c,i,_){

                  switch(i){
                    case 0:
                      return ResetStepOne(onNextTap: () {
                        steps.value = 1;
                      },);
                    case 1:
                      return ResetStepTwo(onNextTap: () {
                        steps.value = 2;
                      },);
                    case 2:
                      return ResetStepThree();
                      default:
                        return ResetStepOne(onNextTap: () {  },);
                  }
                }),
              )

            ],
          ),
        ),
      ),
    );
  }
}
