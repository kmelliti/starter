import 'dart:convert';
import 'dart:developer';


import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_constants.dart';
import '../config/utils.dart';
import '../models/lookup_model.dart';
import '../models/user_model.dart';

class AppServices {

  final Dio _dio;
  final SharedPreferences _prefs;

  AppServices(this._dio, this._prefs);


  Future<void> getMerchantCategories() async {

    try {
      final response = await _dio.get(
        'BorsaNow/public/api/v1/general/categories/${getLang()}',
      );

      if (response.statusCode == 200) {
        merchantCategories =  lookUpModelFromJson(jsonEncode(response.data['data']));
        return;
      } else {
        throw Exception('Failed to load merchant categories');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCities() async {

    try {
      final response = await _dio.get(
        'BorsaNow/public/api/v1/general/cities/${getLang()}',
      );
      log("Response cities ${response.data}");

      if (response.statusCode == 200) {
        cities = lookUpModelFromJson(jsonEncode(response.data['data']));
        return;

      }
      throw Exception('Failed to load cities');
    } catch (e,s) {
      log("$e $s");

      throw Exception('Failed to load cities: $e');
    }
  }

  Future<void> getBanks() async {

    try {
      final response = await _dio.get(
        'BorsaNow/public/api/v1/general/banks/${getLang()}',
      );

      if (response.statusCode == 200) {
        banks =  lookUpModelFromJson(jsonEncode(response.data['data']));
        return;
      }
      throw Exception('Failed to load Banks ${response.data}');
    } catch (e,s) {
      log("$e $s");

      throw Exception('Failed to load Banks: $e ,$s');
    }
  }
  void setUser(UserModel user) {
    _prefs.setString(spUser, jsonEncode(user.toJson()));
  }

  void setToken (String token){
    _prefs.setString(spToken, token);
  }

  UserModel getUser() {
    final String user = _prefs.getString(spUser) ?? '';
    return userModelFromJson(user);
  }
  String? getToken() {
    return _prefs.getString(spToken);
  }


  void removeUserAndToken() {
    _prefs.clear();

  }

}