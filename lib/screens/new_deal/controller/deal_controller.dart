import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/screens/new_deal/models/store_location_model.dart';

import '../../../core/di/di.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/deal_services.dart';
import '../../../core/theme/app_theme.dart';
import '../../main_screen/controller/main_screen_controller.dart';

class DealController {

  final DealServices _dealServices;
  DealController(this._dealServices);

  Future<void> createDeal(Map<String,dynamic> params) async {
    return await _dealServices.createDeal(params);
  }
  Future<List<StoreLocationModel>> getStoreLocation() async {
    return await _dealServices.getStoreLocations();
  }

  void showSuccessDialog(BuildContext context) {
    Get.dialog(
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
                "deal_created".tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final MainScreenController _controller = getIt();
                  Get.back();
                 _controller.indexWidget.value = 0;
                },
                child: Text("deals".tr),
                style: AppTheme.outlinedButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}