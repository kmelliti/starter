// To parse this JSON data, do
//
//     final accountCreationParams = accountCreationParamsFromJson(jsonString);

import 'dart:convert';


String accountCreationParamsToJson(AccountCreationParams data) => json.encode(data.toJson());

class AccountCreationParams {
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? password;
  DateTime? birthday;
  String? categoryId;
  String? companyName;
  String? tradeLicenseNumber;
  String? address;
  String? taxCertificate;
  String? copyTradeLicense;
  String? companyLogo;

  AccountCreationParams({
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.password,
    this.birthday,
    this.categoryId,
    this.companyName,
    this.tradeLicenseNumber,
    this.address,
    this.taxCertificate,
    this.copyTradeLicense,
    this.companyLogo,
  });



  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "gender": gender,
    "password": password,
    "birthday": "${birthday?.year.toString().padLeft(4, '0')}-${birthday?.month.toString().padLeft(2, '0')}-${birthday?.day.toString().padLeft(2, '0')}",
    "category_id": categoryId,
    "company_name": companyName,
    "trade_license_number": tradeLicenseNumber,
    "Address": address,
    "tax_certificate": taxCertificate,
    "copy_trade_license": copyTradeLicense,
    "picture": companyLogo,
  };
}
