import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:starter/core/config/exceptions/api_exception.dart';
import 'package:starter/core/services/app_service.dart';
import 'package:starter/screens/banks/models/bank_account_model.dart';
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

  Future<void> updateBankParams (Map<String,dynamic> params)async {
    try{
      final response = await _dio.put(
        'BorsaNow/public/api/v1/merchant/banks/update/${getLang()}',
        data: params
      );
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }



      log("User updated ${response.data['data']}");


    }catch(e,s){
      log("$e , $e");
      rethrow;
    }
  }
  Future<BankAccountModel> addBankAccount (Map<String,dynamic> params)async{
    try{
      final response = await _dio.post(
        'BorsaNow/public/api/v1/merchant/banks/add/${getLang()}',
        data: params
      );
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }



      log("User bank responded ${response.data['data']}");

      return BankAccountModel.fromJson(response.data['data']);
    }catch(e,s){
      log("$e , $e");
      rethrow;
    }
  }

  Future<List<BankAccountModel>> getBankAccountsList()async{
    try{
      final response = await _dio.get(
        'BorsaNow/public/api/v1/merchant/banks/${getLang()}'
      );
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }



      log("User bank responded ${response.data['data']}");
      return bankAccountModelFromJson(jsonEncode(response.data['data']));

    }catch(e,s){
      log("$e , $e");
      rethrow;
    }
  }

  Future<void> addLocation(Map<String,dynamic> params) async {
    try{

      final response = await _dio.post(
          'BorsaNow/public/api/v1/merchant/locations/add/${getLang()}',
          data: jsonEncode(params)
      );
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }

    }catch(e,s){
      log("$e , $e");
      rethrow;
    }
  }

  Future<void> updateMediaLinks (Map<String,dynamic> params)async{
    try{

      final response = await _dio.put(
        'BorsaNow/public/api/v1/merchant/media/update/${getLang()}',
        data: jsonEncode(params)
      );
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }


    }catch(e,s){
      log("$e , $e");
      rethrow;
    }
  }


}