import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:starter/core/services/app_service.dart';
import 'package:starter/screens/my_account/models/updateUserParams.dart';

import '../config/utils.dart';
import '../di/di.dart';
import '../models/user_model.dart';

class MyAccountServices {

  final Dio _dio;

  MyAccountServices(this._dio);


  Future<void> updateUserParams (UpdateUserParams params)async {
    try{
      final response = await _dio.put(
        'BorsaNow/public/api/v1/merchant/information/update/${getLang()}',
        data: params.toJson()
      );
      if(response.data["result"] == false){
        throw Exception(response.data["message"]);
      }



      log("User updated ${response.data['data']}");

      final AppServices _appServices = getIt();
      _appServices.setUser(UserModel.fromJson(response.data['data']));
    }catch(e,s){
      log("$e , $e");
      rethrow;
    }
  }
}