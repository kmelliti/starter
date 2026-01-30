import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:starter/screens/home_page/models/stats_model.dart';

import '../config/utils.dart';

class HomePageServices {
  final Dio _dio;

  HomePageServices(this._dio);


  Future<StatsModel> getStats()async{
    try {
      final response = await _dio.get(
        "BorsaNow/public/api/v1/merchant/dashboard/${getLang()}",
      );
      log("${response.data}");
      if (response.data["result"] == false) {
        throw Exception(response.data["message"]);
      }

      return statsModelFromJson(jsonEncode(response.data['data']));
    } catch (e,s) {
      log("$e ,$s");
      rethrow;
    }
  }
}