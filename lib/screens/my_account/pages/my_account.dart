import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/config/utils.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, (1 - value) * 20),
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        "my_profile".tr,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              generalContainer(context,"personal_info".tr, "assets/icons/my_account.svg",(){

                Get.toNamed(AppRoutes.editPersonalInfo);
              }),
              SizedBox(height: 10),
              generalContainer(context,"company_info".tr, "assets/icons/pin.svg",(){

                Get.toNamed(AppRoutes.editCompanyInfo);
              }),
              SizedBox(height: 10),
              generalContainer(context,"products".tr, "assets/icons/product.svg",(){
                Get.toNamed(AppRoutes.products);
              }),   SizedBox(height: 10),
              generalContainer(context,"bank_info".tr, "assets/icons/bank.svg",(){

                Get.toNamed(AppRoutes.bankList);
              }),
              SizedBox(height: 10),
              generalContainer(context,"location".tr, "assets/icons/pin.svg",(){
                Get.toNamed(AppRoutes.locations);

              }),
              SizedBox(height: 10),
              generalContainer(context,"communication".tr, "assets/icons/speaker.svg",(){

                Get.toNamed(AppRoutes.contacts);
              }),
              SizedBox(height: 20),
              pushUpAnimation(
                InkWell(
                  onTap: (){
                    showLogoutAlert(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                    margin: EdgeInsets.symmetric( horizontal: 10),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white,
                      border: Border.all(color: HexColor.fromHex(AppTheme.borderGrey)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icons/logout.svg"),
                        SizedBox(width: 10),
                        Text("logout".tr,style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: HexColor.fromHex(AppTheme.primaryColor),
                        ),),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget generalContainer(BuildContext context,String title, String assets,GestureTapCallback onTap) {
    return bounceAnimation(
      c: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          margin: EdgeInsets.symmetric( horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(color: HexColor.fromHex("#CDCCE0")),
          ),
          child: Row(
            children: [
              SvgPicture.asset(assets),
              SizedBox(width: 20),
              Expanded(child: Text(title,style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HexColor.fromHex("#1E1D33")
              ),)),
              Icon(
                Icons.arrow_forward,
                color: HexColor.fromHex(AppTheme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
