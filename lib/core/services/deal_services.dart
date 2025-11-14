import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../screens/new_deal/models/store_location_model.dart';
import '../config/utils.dart';

class DealServices {
  final Dio _dio;

  DealServices(this._dio);

  Future<void> createDeal(Map<String,dynamic> params) async {
    try {

      final response = await _dio.post(
        "BorsaNow/public/api/v1/merchant/deal/add/${getLang()}",
        data: FormData.fromMap(params)
      );

      if (response.data["result"] == false) {
        throw Exception(response.data["message"]);
      }
      log("Response deal ${response.data}");
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StoreLocationModel>> getStoreLocations() async {
    try {

      final response = await _dio.get(
        "BorsaNow/public/api/v1/merchant/locations/${getLang()}",
      );

      if (response.data["result"] == false) {
        throw Exception(response.data["message"]);
      }
      log("Response deal ${response.data}");
      return storeLocationModelFromJson(jsonEncode(response.data['data']));
    } catch (e) {
      rethrow;
    }
  }
}