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
import '../widgets/city_selection_widget.dart';

import 'map.dart';

class LocationList extends StatefulWidget {
  LocationList({super.key});

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  final TextEditingController cityController = TextEditingController();
  List<LocationModel> locations = [];
  List<LocationModel> originalLocations = [];

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> toggle = ValueNotifier(false);
  int? cityId;

  final ValueNotifier<Map<String, dynamic>?> coordinates = ValueNotifier(null);
  final _formKey = GlobalKey<FormState>();

  final MyAccountController _controller = getIt<MyAccountController>();

  late Future f;
  List<LookUpModel> selectedCities = [];

  @override
  void initState() {
    f = _controller.getLocationsList();
    super.initState();
  }

  @override
  void dispose() {
    coordinates.value = null;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildATitle(context, "list_locations".tr),
                  IconButton(
                    icon: Icon(Icons.sort),
                    onPressed: () async {
                      final result = await Navigator.push<List<LookUpModel>>(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CitySelectionScreen(
                                selectedCities: List.from(selectedCities),
                                onCitiesSelected: (cities) {
                                  // This callback is called when cities are selected in the CitySelectionScreen

                                },
                              ),
                        ),
                      );
                      log(result.toString());


                      if (result != null) {


                          selectedCities = result;
                          log("result ${_controller.filterLocations(originalLocations, selectedCities).length}");
                          List<LocationModel> temp = _controller.filterLocations(originalLocations, selectedCities);

                          locations = [...temp];
                          // locations = _controller.filterLocations(locations, selectedCities);
                        toggle.value = !toggle.value;



                      }
                    },
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: toggle,
                builder: (context,_,_) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          selectedCities
                              .map(
                                (city) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 3),
                                  child: Chip(
                                    deleteIconColor: HexColor.fromHex(AppTheme.primaryColor),
                                    labelStyle: TextStyle(color: HexColor.fromHex(AppTheme.primaryColor)),

                                    label: Text(city.name ),
                                    onDeleted: () {
                                      selectedCities.removeWhere(
                                            (c) => c.id == city.id,
                                      );
                                      if(selectedCities.isEmpty){
                                        locations = originalLocations;
                                        toggle.value = !toggle.value;
                                        return;
                                      }

                                      locations = _controller.filterLocations(originalLocations, selectedCities);
                                      toggle.value = !toggle.value;
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  );
                }
              ),

              SizedBox(height: 20),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                    future: f,
                    builder: (c, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Center(child: getLoader());
                      }
                      if (snap.hasError) {
                        return Center(child: Text("error".tr));
                      }
                      log("rebuild");
                      locations = snap.data!;
                      originalLocations = List.from(locations);
                      return ValueListenableBuilder(
                        valueListenable: toggle,
                        builder: (context,_,_) {
                          if(locations.isEmpty){
                            return Center(child: Text("no_data".tr));
                          }
                          return ListView.builder(
                            itemCount: locations.length,
                            shrinkWrap: true,
                            itemBuilder: (c, i) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: HexColor.fromHex(AppTheme.filledBox),
                                  border: Border.all(
                                    color: HexColor.fromHex(AppTheme.primaryColor),
                                  ),
                                ),
                                child: ListTile(
                                  leading: Column(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            coordinates.value =
                                                locations[i].toJson();
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: HexColor.fromHex(
                                              AppTheme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            bool? res = await _controller
                                                .showCloseDealAlert(
                                                  context,
                                                  locations[i].id,
                                                );
                                            if (res != null && res) {
                                              log("Deleted successfully");
                                              setState(() {
                                                locations.removeAt(i);
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    locations[i].address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: SvgPicture.asset(
                                    'assets/icons/location_target.svg',
                                  ),
                                  subtitle: Text(
                                    cities
                                            .firstWhereOrNull(
                                              (test) =>
                                                  test.id.toString() ==
                                                  locations[i].cityId.toString(),
                                            )
                                            ?.name ??
                                        "",
                                  ),
                                  onTap: () async {
                                    await openInGoogleMaps(
                                      double.parse(locations[i].latitude),
                                      double.parse(locations[i].longitude),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                      );
                    },
                  ),
                ),
              ),

              bottomSheetLayout(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetLayout(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: coordinates,
      builder: (context, value, _) {
        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
          if (value != null) {
            cityController.text =
                cities
                    .firstWhereOrNull(
                      (test) =>
                          test.id.toString() == value['city_id'].toString(),
                    )
                    ?.name ??
                "";
          } else {
            cityController.text = "";
          }
        });

        return Column(
          children: [
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: HexColor.fromHex(AppTheme.primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              width: 50,
              height: 5,
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (value?.containsKey("merchant_location_id") ?? false)
                      ? "edit_location".tr
                      : "add_location".tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(width: 10),
                value?.containsKey("merchant_location_id") ?? false
                    ? InkWell(
                      onTap: () {
                        coordinates.value = null;
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 10),
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
                    onChanged: (v) {
                      if (v.isEmpty) {
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
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: HexColor.fromHex(AppTheme.filledBox),
                border: Border.all(
                  color: HexColor.fromHex(AppTheme.primaryColor),
                ),
              ),
              child: Material(
                child: InkWell(
                  onTap: () async {
                    Map<String, dynamic>? newCoordinated =
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapApp(coordinated: coordinates.value),
                      ),
                    );
                        // await showModalBottomSheet(
                        //   context: context,
                        //   isScrollControlled: true,
                        //   builder: (c) {
                        //     return MapApp(coordinated: coordinates.value);
                        //   },
                        // );
                    if (newCoordinated != null) {
                      setState(() {
                        coordinates.value = newCoordinated;
                      });
                      int idCity =
                          cities
                              .firstWhereOrNull(
                                (test) =>
                                    test.name.trim() ==
                                    coordinates.value!["address"]
                                        .split(",")[1]
                                        .trim(),
                              )
                              ?.id ??
                          0;
                      if (idCity != 0) {
                        cityController.text =
                            coordinates.value!["address"].split(",")[1];
                        cityId = idCity;
                        coordinates.value!["city_id"] = idCity;
                      } else {
                        cityController.text = "";
                        cityId = null;
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          coordinates.value != null
                              ? "${coordinates.value!["address"]}"
                              : "choose_site_from_map".tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: HexColor.fromHex(AppTheme.primaryColor),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SvgPicture.asset('assets/icons/location_target.svg'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, v, _) {
                return v
                    ? Center(child: getLoader())
                    : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          isLoading.value = true;
                          try {
                            if (!coordinates.value!.containsKey(
                              "merchant_location_id",
                            )) {
                              LocationModel location = await _controller
                                  .addLocation({
                                    "city_id": cityId,
                                    "latitude": coordinates.value!["latitude"],
                                    "longitude":
                                        coordinates.value!["longitude"],
                                    "address": coordinates.value!["address"],
                                  });

                              setState(() {
                                locations.add(location);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "location_added_successfully".tr,
                                  ),
                                ),
                              );
                            } else {
                              LocationModel
                              location = await _controller.editLocation({
                                "merchant_location_id":
                                    coordinates.value!["merchant_location_id"],
                                "city_id": cityId,
                                "latitude": coordinates.value!["latitude"],
                                "longitude": coordinates.value!["longitude"],
                                "address": coordinates.value!["address"],
                              });

                              setState(() {
                                locations.add(location);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "location_updated_successfully".tr,
                                  ),
                                ),
                              );
                            }
                            coordinates.value = null;
                            cityController.text = "";
                            cityId = null;

                            //Get.back();
                          } catch (e, s) {
                            log("$e $s");
                            handleException(context, e);
                          }
                          isLoading.value = false;
                        }
                      },
                      child: Text("save".tr),
                    );
              },
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
