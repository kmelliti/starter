// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import '../config/app_constants.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String name;
  dynamic picture;
  String phone;
  String email;
  DateTime? birthdate;
  String gender;
  String role;
  String kycStatus;
  int isDeleted;
  dynamic deletedAt;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  DateTime updatedAt;
  Merchant merchant;

  UserModel({
    required this.id,
    required this.name,
    required this.picture,
    required this.phone,
    required this.email,
    required this.birthdate,
    required this.gender,
    required this.role,
    required this.kycStatus,
    required this.isDeleted,
    required this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.merchant,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    picture:json["picture"]== null ? null : json["picture"],
    phone: json["phone"],
    email: json["email"],
    birthdate:json["birthdate"] == null ? null : df.parse(json["birthdate"]),
    gender: json["gender"],
    role: json["role"],
    kycStatus: json["kyc_status"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    merchant: Merchant.fromJson(json["merchant"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "picture": picture,
    "phone": phone,
    "email": email,
    "birthdate":birthdate != null ? df.format(birthdate!) : null,
    "gender": gender,
    "role": role,
    "kyc_status": kycStatus,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "merchant": merchant.toJson(),
  };
}

class Merchant {
  int id;
  int userId;
  int categoryId;
  String companyName;
  String? picture;
  String? tradeLicenseNumber;
  String address;
  String? taxCertificate;
  dynamic copyTradeLicense;
  dynamic linkTiktok;
  dynamic linkInstagram;
  dynamic linkFacebook;
  dynamic linkX;
  int isActive;
  int isDeleted;
  dynamic deletedAt;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  DateTime updatedAt;

  Merchant({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.companyName,
    required this.picture,
    required this.tradeLicenseNumber,
    required this.address,
    required this.taxCertificate,
    required this.copyTradeLicense,
    required this.linkTiktok,
    required this.linkInstagram,
    required this.linkFacebook,
    required this.linkX,
    required this.isActive,
    required this.isDeleted,
    required this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
    id: json["id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    companyName: json["company_name"],
    picture: json["picture"] == null ? null : json["picture"],
    tradeLicenseNumber: json["trade_license_number"],
    address: json.containsKey("Address") ? json["Address"] : json["address"],
    taxCertificate: json["tax_certificate"],
    copyTradeLicense: json["copy_trade_license"],
    linkTiktok: json["link_tiktok"],
    linkInstagram: json["link_instagram"],
    linkFacebook: json["link_facebook"],
    linkX: json["link_x"],
    isActive: json["is_active"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "category_id": categoryId,
    "company_name": companyName,
    "picture": picture,
    "trade_license_number": tradeLicenseNumber,
    "Address": address,
    "tax_certificate": taxCertificate,
    "copy_trade_license": copyTradeLicense,
    "link_tiktok": linkTiktok,
    "link_instagram": linkInstagram,
    "link_facebook": linkFacebook,
    "link_x": linkX,
    "is_active": isActive,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
