import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:starter/core/services/my_account_services.dart';
import 'package:starter/screens/my_account/models/updateUserParams.dart';

import '../../../core/config/utils.dart';
import '../../../core/models/location_model.dart';
import '../../../core/models/lookup_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../banks/models/bank_account_model.dart';

class MyAccountController {


  final MyAccountServices _services;

  MyAccountController(this._services);


  late Completer<GoogleMapController> _controller;
  set controller(Completer<GoogleMapController> value) {
    _controller = value;
  }


  Future<void> goToAddress(CameraPosition cp) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

  Future<void> updateUserParams(UpdateUserParams params)async {

    return _services.updateUserParams(params);
  }

  Future<BankAccountModel> addBankAccount (Map<String,dynamic> params)async {
    return _services.addBankAccount(params);
  }
  Future<void> updateBankAccount (Map<String,dynamic> params)async {
    return _services.updateBankParams(params);
  }

  Future<List<BankAccountModel>> getBankAccountsList()async{
    return _services.getBankAccountsList();
  }
  Future<void> updateMediaLinks (Map<String,dynamic> params)async{
    return _services.updateMediaLinks(params);
  }
  Future<LocationModel> addLocation(Map<String,dynamic> params) async {
    return _services.addLocation(params);
  }
  Future<void> deleteLocation(int locationId) async {
    return _services.deleteLocation(locationId);
  }
  Future<LocationModel> editLocation(Map<String,dynamic> params) async {
    return _services.editLocation(params);
  }
  Future<List<LocationModel>> getLocationsList()async{
    return _services.getLocationsList();
  }

  List<LocationModel> filterLocations(List<LocationModel> allLocations, List<LookUpModel> selectedCities) {
    if (selectedCities.isEmpty) {
      return allLocations; // Return all locations if no cities are selected
    }

    // Get list of selected city IDs
    final selectedCityIds = selectedCities.map((city) => city.id).toSet();
    log(selectedCityIds.toString());

    // Filter locations where cityId is in the selectedCityIds list
    log("Res from res ${allLocations.where((location) => selectedCityIds.contains(location.cityId)).toList()}");
    return allLocations.where((location) => selectedCityIds.contains(location.cityId)).toList();
  }

 Future<bool?> showCloseDealAlert(BuildContext context,int id) async{
    ValueNotifier<bool> isLoading = ValueNotifier(false);

    return Get.dialog(
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
                "alert_delete_location".tr,
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
                child: Text("no_keep".tr),
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
                          await deleteLocation(id);

                          Get.back(result: true);



                        }catch(e){
                          handleException(context, e);
                        }
                        isLoading.value = false;
                      },
                      child: Text(
                        "delete".tr,
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
}
