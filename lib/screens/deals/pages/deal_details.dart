import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/screens/deals/widgets/slider_image.svg.dart';

import '../../../core/theme/app_theme.dart';

class DealDetails extends StatelessWidget {
  const DealDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              pushUpAnimation(
                Row(
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
                    SizedBox(width: 10),
                    Text(
                      "#14445",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: HexColor.fromHex(AppTheme.primaryColor),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
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
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: sideInAnimation(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor.fromHex("#F9F9F9"),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: HexColor.fromHex("#E8E5E5")),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/pin.svg", width: 15),
                            SizedBox(width: 7),
                            Text(
                              "update_location".tr,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: HexColor.fromHex(AppTheme.primaryColor),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: sideInAnimation(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor.fromHex("#F9F9F9"),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: HexColor.fromHex("#E8E5E5")),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "end_deal".tr,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: HexColor.fromHex(AppTheme.primaryColor),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 7),
                            Icon(
                              Icons.close,
                              color: HexColor.fromHex(AppTheme.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SliderImages(),
              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),

                  border: Border.all(
                    color: HexColor.fromHex(AppTheme.borderGrey),
                  ),
                ),
                child: Text("PRD-1001"),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("${"category".tr} :",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HexColor.fromHex(AppTheme.primaryColor),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    fontSize: 14,
                  ),),
                  SizedBox(width: 10),
                  Text("مشروبات باردة",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HexColor.fromHex("#B3B3B3"),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    fontSize: 14,
                  ),),
                ],
              ),
              SizedBox(height: 10),
              ReadMoreText(
                "مشروب بارد ومنعش يجمع بين نكهة الشاي الأخضر الياباني ماتشا والكريمة المخفوقة الغنية، ليمنحك لحظة استرخاء بطعم فريد. مثالي لعشاق النكهات ",
                trimLines: 1,
                colorClickableText: Colors.blue,
                trimMode: TrimMode.Line,
                trimCollapsedText: "show_more".tr,
                trimExpandedText: "show_less".tr,
              ),
              SizedBox(height: 20),
              buildRowDeal(context,"product_number".tr,   "PRD-1001",false),
              Divider(),
              buildRowDeal(context,"price".tr,   "35000",true),
              Divider(),

              buildRowDeal(context,"stores".tr,   "Store A +2",false),
              Divider(),

              buildRowDeal(context,"quantity_storage".tr,   "65412",false),
              Divider(),

              buildRowDeal(context,"total_sold".tr,   "1001",false),
              Divider(),

              buildRowDeal(context,"revenue".tr,   "121.001",true),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  Container buildRowDeal(BuildContext context,String title,String value,bool isPrice) {
    return Container(

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
