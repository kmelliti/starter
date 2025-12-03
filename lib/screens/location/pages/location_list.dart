import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:starter/screens/my_account/controller/my_account_controller.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/models/lookup_model.dart';
import '../../../core/theme/app_theme.dart';
import 'map.dart';

class LocationList extends StatefulWidget {
   LocationList({super.key});

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  final TextEditingController cityController = TextEditingController();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  int? cityId ;
  final _formKey = GlobalKey<FormState>();
  Map<String,dynamic> ? coordinates;
  final MyAccountController _controller = getIt<MyAccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(context),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ButtonTheme(
                alignedDropdown: true,
                child: Autocomplete<LookUpModel>(
                  //   initialValue: TextEditingValue(text: cities.isNotEmpty ?cities.first.name :"" ) ,

                  displayStringForOption: displayStringForOption,


                  fieldViewBuilder: (
                      context,
                      controller,
                      focusNode,
                      onFieldSubmitted,
                      ) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: (v){
                        if(v.isEmpty){
                          setState(() {
                            cityId = null;
                            cityController.text = "";
                          });
                        }
                      },
                      validator: (value) {

                        if (value == null || value.isEmpty) {
                          return 'field_is_required'.tr;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'city'.tr,
                      ).applyDefaults(Theme.of(context).inputDecorationTheme),
                    );
                  },

                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return cities
                        .where(
                          (city) => city.name.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    )
                        .toList();
                  },
                  onSelected: (LookUpModel city) {
                    setState(() {
                      cityController.text = city.name;
                      cityId = city.id;
                    });

                  },
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: HexColor.fromHex(AppTheme.filledBox),
                  border: Border.all(color: HexColor.fromHex(AppTheme.primaryColor)),
                ),
                child: Material(
                  child: InkWell(
                    onTap: () async{
                      Map<String,dynamic>? newCoordinated  = await showModalBottomSheet(context: context,
                          isScrollControlled: true,
                          builder: (c){
                        return MapApp();
                      });
                      if(newCoordinated != null){
                        setState(() {
                          coordinates = newCoordinated;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(coordinates != null ? "${coordinates!["address"]}" : "choose_site_from_map".tr,style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: HexColor.fromHex(AppTheme.primaryColor),fontWeight: FontWeight.w400),),
                        SvgPicture.asset('assets/icons/location_target.svg')
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context,v,_) {
                  return v ? Center(child: getLoader(),) : ElevatedButton(onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      isLoading.value = true;
                      try{
                        await _controller. addLocation({
                          "city_id": cityId,
                          "latitude": coordinates!["latitude"],
                          "longitude": coordinates!["longitude"],
                          "address": coordinates!["address"],
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("location_added_successfully".tr))
                        );
                        Get.back();
                      }catch(e){
                        handleException(context, e  );
                      }
                      isLoading.value = false;

                    }
                  }, child: Text("save".tr));
                }
              ),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),

    );
  }
}
