// To parse this JSON data, do
//
//     final dealModel = dealModelFromJson(jsonString);

import 'dart:convert';

import 'package:starter/screens/new_deal/models/store_location_model.dart';
import 'package:starter/screens/products/models/product_model.dart';

List<DealModel> dealModelFromJson(String str) => List<DealModel>.from(json.decode(str).map((x) => DealModel.fromJson(x)));

String dealModelToJson(List<DealModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DealModel {
  int id;
  int merchantId;
  int productId;
  int quantity;
  String wholesalePrice;
  String retailPrice;
  dynamic minInvestment;
  int quantitySold;
  String totalInvested;
  String targetAmount;
  String status;
  dynamic offerStartAt;
  dynamic offerEndAt;
  int isDeleted;
  dynamic deletedAt;
  int createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  DateTime updatedAt;
  ProductModel product;
  List<LocationElement> locations;

  DealModel({
    required this.id,
    required this.merchantId,
    required this.productId,
    required this.quantity,
    required this.wholesalePrice,
    required this.retailPrice,
    required this.minInvestment,
    required this.quantitySold,
    required this.totalInvested,
    required this.targetAmount,
    required this.status,
    required this.offerStartAt,
    required this.offerEndAt,
    required this.isDeleted,
    required this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
    required this.locations,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) => DealModel(
    id: json["id"],
    merchantId: json["merchant_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    wholesalePrice: json["wholesale_price"],
    retailPrice: json["retail_price"],
    minInvestment: json["min_investment"],
    quantitySold: json["quantity_sold"],
    totalInvested: json["total_invested"],
    targetAmount: json["target_amount"],
    status:json["status"],
    offerStartAt: json["offer_start_at"],
    offerEndAt: json["offer_end_at"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    product: ProductModel.fromJson(json["product"]),
    locations: List<LocationElement>.from(json["locations"].map((x) => LocationElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "merchant_id": merchantId,
    "product_id": productId,
    "quantity": quantity,
    "wholesale_price": wholesalePrice,
    "retail_price": retailPrice,
    "min_investment": minInvestment,
    "quantity_sold": quantitySold,
    "total_invested": totalInvested,
    "target_amount": targetAmount,
    "status": status,
    "offer_start_at": offerStartAt,
    "offer_end_at": offerEndAt,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product": product.toJson(),
    "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
  };
}

class LocationElement {
  int id;
  int wholesaleOfferId;
  int merchantLocationId;
  DateTime createdAt;
  DateTime updatedAt;
  StoreLocationModel location;

  LocationElement({
    required this.id,
    required this.wholesaleOfferId,
    required this.merchantLocationId,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
  });

  factory LocationElement.fromJson(Map<String, dynamic> json) => LocationElement(
    id: json["id"],
    wholesaleOfferId: json["wholesale_offer_id"],
    merchantLocationId: json["merchant_location_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    location: StoreLocationModel.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "wholesale_offer_id": wholesaleOfferId,
    "merchant_location_id": merchantLocationId,
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "updated_at": "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
    "location": location.toJson(),
  };
}









