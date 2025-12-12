import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:starter/core/services/my_account_services.dart';
import 'package:starter/screens/my_account/models/updateUserParams.dart';

import '../../../core/models/location_model.dart';
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
  Future<void> addLocation(Map<String,dynamic> params) async {
    return _services.addLocation(params);
  }
  Future<List<LocationModel>> getLocationsList()async{
    return _services.getLocationsList();
  }
}
