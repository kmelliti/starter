import 'package:starter/core/services/my_account_services.dart';
import 'package:starter/screens/my_account/models/updateUserParams.dart';

import '../../banks/models/bank_account_model.dart';

class MyAccountController {


  final MyAccountServices _services;

  MyAccountController(this._services);


  Future<void> updateUserParams(UpdateUserParams params)async {

    return _services.updateUserParams(params);
  }

  Future<BankAccountModel> addBankAccount (Map<String,dynamic> params)async {
    return _services.addBankAccount(params);
  }
  Future<void> updateBankAccount (Map<String,dynamic> params)async {
    return _services.updateBankParams(params);
  }

  Future<List<BankAccountModel>> getBankAccountsList()async{
    return _services.getBankAccountsList();
  }
  Future<void> updateMediaLinks (Map<String,dynamic> params)async{
    return _services.updateMediaLinks(params);
  }
  Future<void> addLocation(Map<String,dynamic> params) async {
    return _services.addLocation(params);
  }
}
