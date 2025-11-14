

import 'package:intl/intl.dart';

import '../models/lookup_model.dart';

final String spUser = "user";
final String spToken = "token";
final String baseUrl = "https://closecnx.com/";
final String baseUrlImage = "https://closecnx.com/BorsaNow/public/";
final DateFormat df = DateFormat("yyyy-MM-dd");

List<LookUpModel> banks = [];
List<LookUpModel> merchantCategories = [];
List<String> genderList = [
  "male",
  "female"
];