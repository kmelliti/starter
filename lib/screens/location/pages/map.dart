import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../my_account/controller/my_account_controller.dart';
import '../widgets/map_layer.dart';

class MapApp extends StatefulWidget {
  MapApp({super.key, this.coordinated});

  final Map<String, dynamic>? coordinated;

  @override
  State<MapApp> createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  ValueNotifier<String?> address = ValueNotifier(null);

  ValueNotifier<LatLng?> position = ValueNotifier(null);

  ValueNotifier<bool> isSearchLoading = ValueNotifier(false);

  final TextEditingController searchController = TextEditingController();

  final MyAccountController _controller = getIt<MyAccountController>();
  Marker? marker;

  @override
  void didChangeDependencies() {
    if (widget.coordinated != null) {
      marker = Marker(
        markerId: MarkerId(
          widget.coordinated!['merchant_location_id'].toString(),
        ),
        position: LatLng(
          double.parse(widget.coordinated!['latitude'].toString()),
          double.parse(widget.coordinated!['longitude'].toString()),
        ),
      );
      log("Marker has been set");
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    if (widget.coordinated != null) {
      position.value = LatLng(
        double.parse(widget.coordinated!['latitude'].toString()),
        double.parse(widget.coordinated!['longitude'].toString()),
      );
      address.value = widget.coordinated!['address'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapLayer(
            onAddressSelected: (String address, LatLng position) {
              this.address.value = address;
              this.position.value = position;
            },
            marker: marker,
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: isSearchLoading,
                            builder: (context, v, _) {
                              return v
                                  ? getLoader()
                                  : InkWell(
                                    onTap: () async {
                                      isSearchLoading.value = true;
                                      LatLng? newAdd =
                                          await getLatLngFromAddress(
                                            searchController.text,
                                          );
                                      if (newAdd != null) {
                                        log(newAdd.longitude.toString());

                                        _controller.goToAddress(
                                          CameraPosition(
                                            bearing: 192.8334901395799,
                                            target: newAdd,

                                            zoom: 19.151926040649414,
                                          ),
                                        );
                                      } else {
                                        log("not found");
                                      }
                                      isSearchLoading.value = false;
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/search.svg".tr,
                                    ),
                                  );
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "search_location".tr,
                                focusedErrorBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ).applyDefaults(
                                Theme.of(context).inputDecorationTheme,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: address,
            builder: (context, v, _) {
              if (v == null) {
                return Container();
              }
              List<String> address = v.split(",");
              return Positioned(
                bottom: 100,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(address[0]),
                    subtitle: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/pin_filled.svg",
                          width: 10,
                        ),
                        SizedBox(width: 5),
                        Text("${address[1]},${address[2]}"),
                      ],
                    ),
                    leading: SvgPicture.asset(
                      "assets/icons/location_target.svg",
                      width: 30,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (address.value == null) {
                  Get.back();
                } else {
                  Map<String, dynamic> coordinates;
                  if (widget.coordinated == null) {
                    coordinates = {
                      "address": address.value!,
                      "longitude": position.value!.longitude,
                      "latitude": position.value!.latitude,
                    };
                  } else {
                    coordinates = widget.coordinated!;
                    coordinates['address'] = address.value!;
                    coordinates['longitude'] = position.value!.longitude;
                    coordinates['latitude'] = position.value!.latitude;
                  }
                  Get.back(result: coordinates);
                }
              },
              child: Text('save_location'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
