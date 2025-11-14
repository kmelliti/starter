import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/routes/app_routes.dart';

import '../../core/config/utils.dart';
import '../../core/theme/app_theme.dart';

class SingleDeal extends StatelessWidget {
  const SingleDeal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: HexColor.fromHex("#E8E5E5")),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: HexColor.fromHex('#F9F9F9'),
              borderRadius: BorderRadius.circular(40),
              border: Border(
                bottom: BorderSide(color: HexColor.fromHex("#E8E5E5")),
                left: BorderSide(color: HexColor.fromHex("#E8E5E5")),
                right: BorderSide(color: HexColor.fromHex("#E8E5E5")),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "deal_id".tr,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: HexColor.fromHex("#B4B4B4"),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "#14445",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: HexColor.fromHex(AppTheme.primaryColor),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "rejected".tr,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildRowDeal(context,"product_number".tr,   "PRD-1001",false),
          buildRowDeal(context,"price".tr,   "35000",true),
          buildRowDeal(context,"stores".tr,   "Store A +2",false),
          buildRowDeal(context,"quantity_storage".tr,   "65412",false),
          buildRowDeal(context,"total_sold".tr,   "1001",false),
          buildRowDeal(context,"revenue".tr,   "121.001",true),
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.dealDetails);
              },
              child: Text("edit_deal".tr),
              style: AppTheme.outlinedButtonStyle,
            ),
          ),
        ],
      ),
    );
  }

  Container buildRowDeal(BuildContext context,String title,String value,bool isPrice) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: HexColor.fromHex(AppTheme.primaryColor),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                 value,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: HexColor.fromHex("#5E5D68"),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      fontSize: 16,
                    ),
                  ),

                    isPrice ? SizedBox(width: 8,):SizedBox(),
                  isPrice?  SvgPicture.asset("assets/icons/sar.svg",color: HexColor.fromHex("#5E5D68"),):SizedBox(),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
