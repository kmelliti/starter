// To parse this JSON data, do
//
//     final statsModel = statsModelFromJson(jsonString);

import 'dart:convert';

StatsModel statsModelFromJson(String str) => StatsModel.fromJson(json.decode(str));

String statsModelToJson(StatsModel data) => json.encode(data.toJson());

class StatsModel {
  String totalDeals;
  String totalProfits;
  String withdrawn;
  String totalBalance;

  StatsModel({
    required this.totalDeals,
    required this.totalProfits,
    required this.withdrawn,
    required this.totalBalance,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) => StatsModel(
    totalDeals: json["total_deals"].toString(),
    totalProfits: json["total_profits"].toString(),
    withdrawn: json["withdrawn"].toString(),
    totalBalance: json["total_balance"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "total_deals": totalDeals,
    "total_profits": totalProfits,
    "withdrawn": withdrawn,
    "total_balance": totalBalance,
  };
}
