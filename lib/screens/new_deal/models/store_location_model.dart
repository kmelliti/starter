// To parse this JSON data, do
//
//     final storeLocationModel = storeLocationModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

List<StoreLocationModel> storeLocationModelFromJson(String str) => List<StoreLocationModel>.from(json.decode(str).map((x) => StoreLocationModel.fromJson(x)));

String storeLocationModelToJson(List<StoreLocationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreLocationModel extends Equatable{
  int id;
  int merchantId;
  int cityId;
  String address;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;

  StoreLocationModel({
    required this.id,
    required this.merchantId,
    required this.cityId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreLocationModel.fromJson(Map<String, dynamic> json) => StoreLocationModel(
    id: json["id"],
    merchantId: json["merchant_id"],
    cityId: json["city_id"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "merchant_id": merchantId,
    "city_id": cityId,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };

  @override

  List<Object?> get props => [id];
}
