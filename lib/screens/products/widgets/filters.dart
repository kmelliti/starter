import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/core/config/utils.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/models/lookup_model.dart';

typedef OnSelected = void Function(List<LookUpModel> filters);
class ProductFilters extends StatelessWidget {
   ProductFilters({super.key, required this.onSelected,required this.productSelectedCategories});
  final OnSelected onSelected;
  final ValueNotifier<bool> shakeUp =ValueNotifier(false);


   List<LookUpModel> productSelectedCategories = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTitle("category".tr),

          ValueListenableBuilder(
            valueListenable: shakeUp,
            builder: (context, value, child) {
              return ListView(
                shrinkWrap: true,
                children: productCategories.map((e) => ListTile(
                  onTap: (){
                    if(!productSelectedCategories.contains(e)){
                      productSelectedCategories.add(e);
                    }else{
                      productSelectedCategories.remove(e);
                    }
                    shakeUp.value = !shakeUp.value;
                    onSelected(productSelectedCategories);
                  },
                  title: Text(e.name),
                  trailing: Checkbox(value: productSelectedCategories.contains(e), onChanged: (value){

                  }),
                )).toList(),
              );
            }
          ),
        ],
      ),
    );
  }
}
