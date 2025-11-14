// To parse this JSON data, do
//
//     final lookUpModel = lookUpModelFromJson(jsonString);

import 'dart:convert';

List<LookUpModel> lookUpModelFromJson(String str) => List<LookUpModel>.from(json.decode(str).map((x) => LookUpModel.fromJson(x)));

String lookUpModelToJson(List<LookUpModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LookUpModel {
  int id;
  String name;

  LookUpModel({
    required this.id,
    required this.name,
  });

  factory LookUpModel.fromJson(Map<String, dynamic> json) => LookUpModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
