import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:starter/screens/my_account/controller/my_account_controller.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/models/location_model.dart';
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
  List<LocationModel> locations = [];

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  int? cityId ;
  final _formKey = GlobalKey<FormState>();
  Map<String,dynamic> ? coordinates;
  final MyAccountController _controller = getIt<MyAccountController>();

  late Future f ;
  @override
  void initState() {

    f = _controller.getLocationsList();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(context),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(

          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildATitle(context, "list_locations".tr),

              SizedBox(height: 20,),
              Expanded(
                child: Container(

                  child: FutureBuilder(future: f, builder: (c,snap){
                    if(snap.connectionState == ConnectionState.waiting){
                      return Center(child: getLoader(),);
                    }
                    if(snap.hasError){
                      return Center(child: Text("error".tr),);
                    }
                    locations = snap.data!;
                    return ListView.builder(
                      itemCount: locations.length,
                      shrinkWrap: true,
                      itemBuilder: (c,i){
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: HexColor.fromHex(AppTheme.filledBox),
                            border: Border.all(color: HexColor.fromHex(AppTheme.primaryColor)),
                          ),
                          child: ListTile(
                            leading: SvgPicture.asset('assets/icons/pin.svg'),
                            title: Text(locations[i].address,maxLines: 1,overflow: TextOverflow.ellipsis,),
                            trailing: SvgPicture.asset('assets/icons/location_target.svg'),
                            subtitle: Text(cities.firstWhereOrNull((test)=>test.id.toString() == locations[i].cityId.toString())?.name ?? ""),
                            onTap: () async{
                              await openInGoogleMaps(double.parse(locations[i].latitude), double.parse(locations[i].longitude));
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Divider(),
              ),
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
                      controller: cityController,
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
                        int idCity = cities.firstWhereOrNull((test)=>test.name.trim() == coordinates!["address"].split(",")[1].trim())?.id ?? 0;
                        if(idCity != 0){
                          cityController.text = coordinates!["address"].split(",")[1];
                          cityId = idCity;

                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text(coordinates != null ? "${coordinates!["address"]}" : "choose_site_from_map".tr,maxLines: 1,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: HexColor.fromHex(AppTheme.primaryColor),fontWeight: FontWeight.w400),)),
                        SvgPicture.asset('assets/icons/location_target.svg')
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

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
                        log("Params city ${{
                          "city_id": cityId,
                          "latitude": coordinates!["latitude"],
                          "longitude": coordinates!["longitude"],
                          "address": coordinates!["address"],
                        }}");
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
