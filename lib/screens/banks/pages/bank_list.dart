import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/core/services/app_service.dart';
import 'package:starter/core/services/my_account_services.dart';
import 'package:starter/screens/banks/models/bank_account_model.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/di/di.dart';
import '../../../core/models/lookup_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../my_account/controller/my_account_controller.dart';

class BankList extends StatefulWidget {
  const BankList({super.key});

  static String _displayStringForOption(LookUpModel lookup) => lookup.name;

  @override
  State<BankList> createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  int? bankId;
  int? bankAccountId;
  final _bankNameController = TextEditingController();
  final _ibanNumberController = TextEditingController();

  MyAccountController _myAccountController = getIt();
  late Future f;
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    f = _myAccountController.getBankAccountsList();
    super.initState();
  }
  List<BankAccountModel> accounts = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        height: 60,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context,value,_) {
                  return value ? getLoader(): ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      if (_ibanNumberController.text.isNotEmpty && bankId != null) {
                        isLoading.value = true;
                        try {
                          if (bankAccountId != null) {
                            await _myAccountController.updateBankAccount({
                              "bank_id": bankId,
                              "account_number": _ibanNumberController.text,
                              "user_bank_id": bankAccountId,
                            });

                            accounts.where((element) => element.id == bankAccountId).first.accountNumber = _ibanNumberController.text;
                            setState(() {

                            });
                            bankId = null;
                            bankAccountId = null;
                            _bankNameController.text = "";
                            _ibanNumberController.text = "";
                            setState(() {});
                            isLoading.value = false;

                            return;
                          }
                          isLoading.value = true;
                          BankAccountModel  bank = await _myAccountController.addBankAccount({
                            "bank_id": bankId,
                            "account_number": _ibanNumberController.text,
                          });

                          accounts.add(bank);
                          bankId = null;
                          bankAccountId = null;
                          _bankNameController.text = "";
                          _ibanNumberController.text = "";
                          setState(() {});

                        } catch (e, s) {
                          handleException(context, e);
                        }

                        isLoading.value = false;

                      }

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        bankAccountId == null
                            ? Text("add_new_bank_account".tr)
                            : Text("update_bank_account".tr),

                        bankAccountId == null ? Icon(Icons.add) : Icon(Icons.edit),

                      ],
                    ),
                  );
                }
              ),
            ),
            Expanded(
              flex: 0,
                child: Container()),
            Expanded(
              flex: bankAccountId == null ? 0 : 1,
              child: InkWell(
                onTap: (){
                  bankId = null;
                  bankAccountId = null;
                  _bankNameController.text = "";
                  _ibanNumberController.text = "";
                  setState(() {});
                },
                child: AnimatedContainer(

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor.fromHex(AppTheme.primaryColor),
                  ),
                  width: bankAccountId == null ? 0 : 50,
                  height: bankAccountId == null ? 0 : 50,
                  duration: Duration(milliseconds: 500),
                  child: Icon(Icons.close,size:bankAccountId == null ? 0 : 30,color: Colors.white, ),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: buildAppBarWithBack(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/company.svg",
                      color: HexColor.fromHex(AppTheme.primaryColor),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "bank_info".tr,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 18,
                        color: HexColor.fromHex(AppTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: f,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: getLoader());
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      accounts = snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: accounts.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: HexColor.fromHex(AppTheme.primaryColor),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/icons/bank.svg"),
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  bankId = accounts[index].bankId;
                                  bankAccountId = accounts[index].id;
                                  _bankNameController.text =
                                      banks
                                          .firstWhereOrNull(
                                            (p) =>
                                                p.id.toString() ==
                                                accounts[index].bankId.toString(),
                                          )
                                          ?.name ??
                                      "";
                                  _ibanNumberController.text =
                                      accounts[index].accountNumber;
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HexColor.fromHex(
                                      AppTheme.primaryColor,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              title: Text(
                                banks
                                        .firstWhereOrNull(
                                          (p) =>
                                              p.id.toString() ==
                                              accounts[index].bankId.toString(),
                                        )
                                        ?.name ??
                                    "",
                              ),
                              subtitle: Text(accounts[index].accountNumber),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                SizedBox(height: 20),
                bankAccountId == null
                    ? pushUpAnimation(Text("add_new_bank_account".tr))
                    : pushUpAnimation(Text("update_bank_account".tr)),
                SizedBox(height: 20),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<LookUpModel>(
                    value: banks.firstWhereOrNull((test)=>test.id == bankId),
                    decoration: InputDecoration(hintText: 'bank_name'.tr),


                    padding: EdgeInsets.symmetric(vertical: 5),

                    isDense: true,
                    isExpanded: false,

                    items:
                        banks.map((bank) {
                          return DropdownMenuItem<LookUpModel>(
                            value: bank,
                            child: Text(bank.name),
                          );
                        }).toList(),

                    onChanged: (value) {
                      if (value != null) {
                        bankId = value.id;
                      }
                      // setState(() {
                      //   if (value != null) {
                      //     bankId = value.id;
                      //     _bankNameController.text = value.name;
                      //   } else {
                      //     bankId = null;
                      //     _bankNameController.clear();
                      //   }
                      // });
                    },
                  ),
                ),
                //
                // Autocomplete<LookUpModel>(
                //   displayStringForOption: (option) => option.name,
                //   optionsBuilder: (TextEditingValue textEditingValue) {
                //     if (textEditingValue.text == '') {
                //       return const Iterable<LookUpModel>.empty();
                //     }
                //
                //     return banks.where(
                //       (city) => city.name.toLowerCase().contains(
                //         textEditingValue.text.toLowerCase(),
                //       ),
                //     );
                //   },
                //
                //   onSelected: (LookUpModel city) {
                //     _bankNameController.text = city.name;
                //     bankId = city.id;
                //   },
                //
                //   fieldViewBuilder: (
                //     context,
                //     controller,
                //     focusNode,
                //     onFieldSubmitted,
                //   ) {
                //     return TextFormField(
                //       controller: _bankNameController,
                //       onChanged: (t) {
                //         if (t.isEmpty) {
                //           setState(() {
                //             bankId = null;
                //             bankAccountId = null;
                //           });
                //         }
                //       },
                //       focusNode: focusNode,
                //       decoration: InputDecoration(hintText: 'bank_name'.tr),
                //     );
                //   },
                //
                //   optionsViewBuilder: (context, onSelected, options) {
                //     return Align(
                //       alignment: Alignment.topCenter,
                //       child: Material(
                //         color: Colors.transparent,
                //         child: Container(
                //           margin: const EdgeInsets.only(left: 40, top: 20),
                //           decoration: BoxDecoration(
                //             color: const Color(0xFF2C2C2C),
                //             borderRadius: BorderRadius.circular(15),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black.withOpacity(0.4),
                //                 blurRadius: 8,
                //                 offset: const Offset(0, 4),
                //               ),
                //             ],
                //           ),
                //           child: ListView.builder(
                //             padding: EdgeInsets.zero,
                //             shrinkWrap: true,
                //             itemCount: options.length,
                //             itemBuilder: (context, index) {
                //               final option = options.elementAt(index);
                //
                //               return InkWell(
                //                 onTap: () {
                //                   onSelected(option); // ✅ Required to select item
                //                 },
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                     horizontal: 12,
                //                     vertical: 14,
                //                   ),
                //                   child: Text(
                //                     option.name,
                //                     style: const TextStyle(
                //                       color: Colors.white,
                //                       fontSize: 16,
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             },
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),

                SizedBox(height: 20),
                TextFormField(
                  controller: _ibanNumberController,
                  validator: (value){
                    if (value == null || value.isEmpty) return "field_required".tr;

                    if (!RegExp(r'^SA\d{22}$').hasMatch(value)) {
                      return 'invalid_iban'.tr;
                    }

                    return null;
                  },
                  onChanged: (t) {
                    // if (t.isEmpty && bankId == null) {
                    //   setState(() {
                    //     bankId = null;
                    //     bankAccountId = null;
                    //   });
                    // }
                  },
                  decoration: InputDecoration(
                    hintText: "iban_number".tr,
                  ).applyDefaults(Theme.of(context).inputDecorationTheme),
                ),

                SizedBox(height: 20),

                //ElevatedButton(onPressed: () {}, child: Text("save".tr)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
