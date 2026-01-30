// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:starter/core/config/app_constants.dart';


class UpdateUserParams {

  String name;
  String phone;
  String email;
  DateTime? birthdate;
  String gender;


  UpdateUserParams({
    required this.name,
    required this.phone,
    required this.email,
    required this.birthdate,
    required this.gender,

  });

  factory UpdateUserParams.fromJson(Map<String, dynamic> json) => UpdateUserParams(
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    birthdate: json["birthdate"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "email": email,
    "birthdate":birthdate != null ? df.format(birthdate!) : null,
    "gender": gender,

  };
}

