import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:starter/core/config/exceptions/api_exception.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/core/models/lookup_model.dart';
import 'package:starter/screens/products/models/product_model.dart';

import '../config/app_constants.dart';
import '../di/di.dart';
import 'app_service.dart';

class ProductService {
  final Dio _dio;

  ProductService(this._dio);

  Future<List<LookUpModel>> getProductCategories() async {
    try {
      final response = await _dio.get(
        "BorsaNow/public/api/v1/general/product/categories/${getLang()}",
      );

      if (response.data["result"] == false) {
        throw ApiException(response.data["message"]);
      }
      productCategories = lookUpModelFromJson(jsonEncode(response.data['data']));
      return lookUpModelFromJson(jsonEncode(response.data['data']));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(List<String> image, Map<String, dynamic> params) async {
    try {
      FormData formData = FormData.fromMap(params);
      for(int i = 0; i < image.length ; i ++){
        formData.files.add(MapEntry("images[$i]", await MultipartFile.fromFile(image[i])));

      }
      final response = await _dio.post(
        "BorsaNow/public/api/v1/merchant/product/add/${getLang()}",
        data: formData,
      );

      if (response.data["result"] == false) {
        throw ApiException(response.data["message"]);
      }
     // addProductPicture(image, response.data["data"]["id"]);
    } catch (e) {
      rethrow;
    }
  }

  void addProductPicture(String path, productId) async {
    FormData formData = FormData();
    formData.files.add(MapEntry("picture", await MultipartFile.fromFile(path)));
    formData.fields.add(MapEntry("product_id", productId.toString()));
    try {
      final response = await _dio.post(
        "BorsaNow/public/api/v1/merchant/product/picture/add/${getLang()}",
        data: formData,
      );

      if (response.data["result"] == false) {
        throw ApiException(response.data["message"]);
      }
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getProducts(int pageKey) async {
    try {
      final response = await _dio.post(
        "BorsaNow/public/api/v1/merchant/products/${getLang()}?page=$pageKey",
      );

      if (response.data["result"] == false) {
        throw ApiException(response.data["message"]);
      }

      print("This is the response ${response.data}");
      List<ProductModel> products = [];


        products = productModelFromJson(jsonEncode(response.data['data']['data']));

      return products ;

    } catch (e, s) {
      log("$e , $s");
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final response = await _dio.post(
        "BorsaNow/public/api/v1/merchant/product/delete/${getLang()}",
        data: FormData.fromMap({"product_id": id}),
      );

      if (response.data["result"] == false) {
        throw ApiException(response.data["message"]);
      }
      return;
    } catch (e) {
      rethrow;
    }
  }
}
