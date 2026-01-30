// To parse this JSON data, do
//
//     final accountCreationParams = accountCreationParamsFromJson(jsonString);

import 'dart:convert';

//AccountCreationParams accountCreationParamsFromJson(String str) => AccountCreationParams.fromJson(json.decode(str));

//String accountCreationParamsToJson(AccountCreationParams data) => json.encode(data.toJson());

class AccountCreationParams {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? birthday;
  String? postalCode;
  int? cityId;
  String? cityName;
  String? buildingNumber;
  String? unitNumber;
  String? street;
  String? district;
  String? idNumber;
  String? idDocumentPath;
  String? accountNumber;
  String? ibanNumber;
  String? picture;
  String? gender;
  int? bankId;
  String? bankName;

  AccountCreationParams({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.birthday,
    this.postalCode,
    this.cityId,
    this.cityName,
    this.buildingNumber,
    this.unitNumber,
    this.street,
    this.district,
    this.idNumber,
    this.idDocumentPath,
    this.accountNumber,
    this.ibanNumber,
    this.picture,
    this.gender,
    this.bankId,
  });

  // factory AccountCreationParams.fromJson(Map<String, dynamic> json) => AccountCreationParams(
  //   name: json["name"],
  //   email: json["email"],
  //   phone: json["phone"],
  //   password: json["password"],
  //   birthday: json["birthday"] ,
  //   postalCode: json["postal_code"],
  //   cityId: json["city_id"],
  //   buildingNumber: json["building_number"],
  //   unitNumber: json["unit_number"],
  //   street: json["street"],
  //   district: json["district"],
  //   idNumber: json["id_number"],
  //   idDocumentPath: json["id_document_path"],
  //   accountNumber: json["account_number"],
  //   ibanNumber: json["iban_number"],
  //   picture: json["picture"],
  //   gender: json["gender"],
  //   bankId: json["bank_id"],
  // );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "password": password,
    "birthday": birthday,
    "postal_code": postalCode,
    "city_id": cityId,
    "building_number": buildingNumber,
    "unit_number": unitNumber,
    "street": street,
    "district": district,
    "id_number": idNumber,
    "id_document_path": idDocumentPath,
    "account_number": accountNumber,
    "iban_number": ibanNumber,
    "picture": picture,
    "gender": gender,
    "bank_id": bankId,
  };
}
