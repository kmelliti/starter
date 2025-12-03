import 'dart:convert';
import 'dart:developer';


import 'package:dio/dio.dart';
import 'package:starter/core/config/exceptions/api_exception.dart';

import '../../screens/sign_up/model/account_creation_params.dart';
import '../config/utils.dart';
import '../di/di.dart';

import '../models/user_model.dart';
import 'app_service.dart';

class AuthService{

  final Dio _dio;
  AuthService(this._dio);
  final AppServices appServices = getIt();

  Future<void> signUp(AccountCreationParams accountCreationParams) async {
    try {

      log(accountCreationParams.toJson().toString());
      FormData formData = FormData.fromMap(accountCreationParams.toJson());
      if(accountCreationParams.companyLogo != null) {
        formData.files.add(MapEntry("picture", await MultipartFile.fromFile(accountCreationParams.companyLogo!)));
      }
      if(accountCreationParams.taxCertificate != null) {
        formData.files.add(MapEntry("tax_certificate", await MultipartFile.fromFile(accountCreationParams.taxCertificate!)));
      }
      if(accountCreationParams.copyTradeLicense != null) {
        formData.files.add(MapEntry("copy_trade_license", await MultipartFile.fromFile(accountCreationParams.copyTradeLicense!)));
      }

      final response = await _dio.post(
        'BorsaNow/public/api/v1/merchant/register/${getLang()}',
        data: formData,
      );
      print("Data ${response.data} ");
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }

      
      return response.data;
    } catch (e) {

      throw e;
    }
  }

  Future<String> resetPassword(Map<String,dynamic> params) async {
    try {
      final response = await _dio.post(
        'BorsaNow/public/api/v1/general/password/update/${getLang()}',
        data: FormData.fromMap(params),
      );
      print("Data ${response.data} ");
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }

      return response.data["data"].toString();
    } catch (e) {

      rethrow;
    }
  }

  Future<String> codeResetPassword(Map<String,dynamic> params) async {
    try {
      final response = await _dio.post(
        'BorsaNow/public/api/v1/general/password/code/${getLang()}',
        data: FormData.fromMap(params),
      );
      print("Data ${response.data} ");
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }

      return response.data["data"].toString();
    } catch (e) {

      rethrow;
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
      final response = await _dio.post(
        'BorsaNow/public/api/v1/merchant/login/${getLang()}',
        data: FormData.fromMap({
          "email": email,
          "password": password,
        }),
      );
      print("Data 1 ${response.data} ");
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }

      appServices.setToken(response.data["token"]);
      log("Prentable token ${appServices.getToken()}");


      return await getUser();
    } catch (e) {

      rethrow;
    }
  }


  Future<UserModel> getUser() async {
    try {
      final response = await _dio.get(
        'BorsaNow/public/api/v1/merchant/${getLang()}',
        queryParameters: {
          "token":appServices.getToken()
        }
      );
      print("Data 2 ${response.data} ");
      if(response.data["result"] == false){
        throw ApiException(response.data["message"]);
      }

      appServices.setUser(userModelFromJson(jsonEncode(response.data['data'])));
      return userModelFromJson(jsonEncode(response.data['data']));
    } catch (e,s) {
      log("$e,$s");

      throw e;
    }
  }


  Future<void> signOut() async {

    try {
      final response = await _dio.get(
        'BorsaNow/public/api/v1/merchant/logout/${getLang()}?token=${appServices.getToken()}',
      );
      print("Data ${response.data} ");
      if(response.data["result"] == false){
        throw Exception();
      }


    } catch (e) {

      throw e;
    }
  }
}