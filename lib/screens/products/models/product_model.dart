// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  int id;
  int merchantId;
  int productCategorieId;
  String sku;
  String name;
  String description;
  String costBasis;
  int isDeleted;
  dynamic deletedAt;
  int createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<ProductPicture> productPictures;
  ProductCategorie? productCategorie;

  ProductModel({
    required this.id,
    required this.merchantId,
    required this.productCategorieId,
    required this.sku,
    required this.name,
    required this.description,
    required this.costBasis,
    required this.isDeleted,
    required this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.productPictures,
    required this.productCategorie,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    merchantId: json["merchant_id"],
    productCategorieId: json["product_categorie_id"],
    sku: json["sku"],
    name: json["name"],
    description: json["description"],
    costBasis: json["cost_basis"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    productPictures: List<ProductPicture>.from(json["product_pictures"].map((x) => ProductPicture.fromJson(x))),
    productCategorie: json["product_categorie"] == null ? null : ProductCategorie.fromJson(json["product_categorie"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "merchant_id": merchantId,
    "product_categorie_id": productCategorieId,
    "sku": sku,
    "name": name,
    "description": description,
    "cost_basis": costBasis,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product_pictures": List<dynamic>.from(productPictures.map((x) => x.toJson())),
    "product_categorie": productCategorie?.toJson(),
  };
}

class ProductCategorie {
  int id;
  String name;
  int isDeleted;
  dynamic deletedAt;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  dynamic updatedAt;

  ProductCategorie({
    required this.id,
    required this.name,
    required this.isDeleted,
    required this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategorie.fromJson(Map<String, dynamic> json) => ProductCategorie(
    id: json["id"],
    name: json["name"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
  };
}

class ProductPicture {
  int id;
  int productId;
  String picture;
  DateTime createdAt;
  DateTime updatedAt;

  ProductPicture({
    required this.id,
    required this.productId,
    required this.picture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductPicture.fromJson(Map<String, dynamic> json) => ProductPicture(
    id: json["id"],
    productId: json["product_id"],
    picture: json["picture"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "picture": picture,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
