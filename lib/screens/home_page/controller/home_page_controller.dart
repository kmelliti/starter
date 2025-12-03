import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/routes/app_routes.dart';
import 'package:starter/core/services/deal_services.dart';
import 'package:starter/core/services/home_page_services.dart';
import 'package:starter/screens/home_page/models/stats_model.dart';

import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/theme/app_theme.dart';
import '../../main_screen/controller/main_screen_controller.dart';
import '../models/deal_model.dart';

class HomePageController {


  final HomePageServices _homePageServices ;
  final DealServices _dealServices ;

  HomePageController(this._homePageServices, this._dealServices);
  ValueNotifier<bool> isLoading = ValueNotifier(false);


  Future<StatsModel> getStats()async{
    return await _homePageServices.getStats();
  }

  Future<List<DealModel>> getDealProducts(int page,Map<String,dynamic>? filters)async{
    return await _dealServices.getDeals(page,filters);
  }


  void showCloseDealAlert(BuildContext context,String dealId) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,

        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/alert_circle.svg"),
              SizedBox(height: 20),

              Text(
                "alert_close_deal".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: HexColor.fromHex("#1E1D33"),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("continue_deal".tr),
                style: AppTheme.outlinedButtonStyle,
              ),
              SizedBox(height: 20),
              ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context,v,_) {
                    return v ? getLoader() : TextButton(
                      onPressed: () async {
                        isLoading.value = true;
                        try{
                          await _dealServices.closeDeal(dealId);
                          Get.back();
                          showSuccessCloseDeal(context);
                        }catch(e){
                          handleException(context, e);
                        }
                        isLoading.value = false;
                      },
                      child: Text(
                        "cancel".tr,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: HexColor.fromHex("#E62F29"),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showSuccessCloseDeal(BuildContext context) {

    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,

        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/check_green.svg"),
              SizedBox(height: 20),

              Text(
                "deal_closed".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: HexColor.fromHex("#1E1D33"),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {

                  Get.back();
                  Get.offAllNamed(AppRoutes.mainScreen);

                },
                child: Text("home_page".tr),
                style: AppTheme.outlinedButtonStyle,
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}