import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/config/utils.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/models/lookup_model.dart';
import '../../../core/theme/app_theme.dart';

class BankList extends StatefulWidget {
  const BankList({super.key});
  static String _displayStringForOption(LookUpModel lookup) => lookup.name;

  @override
  State<BankList> createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  int? bankId;
  final _bankNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/icons/company.svg",color: HexColor.fromHex(AppTheme.primaryColor),),
                SizedBox(width: 10,),
                Text("bank_info".tr,style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 18,
                    color:  HexColor.fromHex(AppTheme.primaryColor)
                ),)
              ],
            ),
            SizedBox(height: 20,),
            Autocomplete<LookUpModel>(
              optionsViewBuilder: (context,v,r){

                return Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin:  EdgeInsets.only(left: 40,top: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: r.length,
                        itemBuilder: (context, index) {
                          final option = r.elementAt(index);
                          return InkWell(
                            onTap: () {


                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              child: Text(
                                option.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              //   initialValue: TextEditingValue(text: cities.isNotEmpty ?cities.first.name :"" ) ,
              displayStringForOption: BankList._displayStringForOption,
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,

                  decoration: InputDecoration(
                    hintText: 'bank_name'.tr,


                  ).applyDefaults(Theme.of(context).inputDecorationTheme),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {

                 return banks
                    .where(
                      (city) => city.name.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                )
                    .toList();
              },
              onSelected: (LookUpModel city) {
                _bankNameController.text = city.name;
                bankId= city.id;
              },
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                hintText: "card_num".tr
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
            ),

            SizedBox(height: 40,),
            ElevatedButton(onPressed: (){

            }, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [


                Text("add_new_bank_account".tr),
                Icon(Icons.add),
              ],
            ),style: AppTheme.outlinedButtonStyle,),
            Spacer(),

            ElevatedButton(onPressed: (){}, child: Text("save".tr))
          ],
        ),
      ),
    );
  }
}
