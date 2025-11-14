
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/utils.dart';
import '../../../core/theme/app_theme.dart';



typedef OnNextTap = void Function();
class ResetStepOne extends StatelessWidget {
  const ResetStepOne({super.key, required this.onNextTap});
  final OnNextTap onNextTap;

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        SizedBox(height: 60,),
        TextField(
          decoration: InputDecoration(
            hintText: "email".tr
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: Divider(color: HexColor.fromHex("#CDCCE0"),)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text("or".tr,style:  Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: HexColor.fromHex(AppTheme.primaryColor),
                fontWeight: FontWeight.bold
              ),),
            ),
            Expanded(child: Divider(color: HexColor.fromHex("#CDCCE0"),)),

          ],
        ),
        SizedBox(height: 20,),
        TextField(
          decoration: InputDecoration(
              hintText: "mobile".tr
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
        ),


        Spacer(),
        ElevatedButton(onPressed: (){
          onNextTap();
        }, child: Text("next".tr)),
      ],
    );
  }
}
