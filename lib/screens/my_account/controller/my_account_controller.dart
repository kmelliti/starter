import 'package:starter/core/services/my_account_services.dart';
import 'package:starter/screens/my_account/models/updateUserParams.dart';

class MyAccountController {


  final MyAccountServices _services;

  MyAccountController(this._services);


  Future<void> updateUserParams(UpdateUserParams params)async {

    return _services.updateUserParams(params);
  }
}