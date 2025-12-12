import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapApp extends StatelessWidget {
  MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapLayer(),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              children: [
                InkWell(
                  onTap: (){
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
                          SvgPicture.asset(
                            "assets/icons/search.svg".tr,

                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "search_location".tr,
                                focusedErrorBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ).applyDefaults(Theme.of(context).inputDecorationTheme),
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
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("حي العليا، شارع الملك فهد"),
                  subtitle: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/pin_filled.svg",
                        width: 10,
                      ),
                      SizedBox(width: 5),
                      Text("الرياض 12241"),
                    ],
                  ),
                  leading: Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://media.gettyimages.com/id/652628318/photo/caffee-on-table-and-blured-cafe.jpg?s=612x612&w=gi&k=20&c=GjH2_Y3O41125DmnhK0Ecqq3P27MFT455hM8qtp-_zM=",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
               Get.back(result: {
                 "address":"4 Rue farhat hached ",
                 "longitude":"13.12563",
                 "latitude":"10.65423",
               });
              },
              child: Text('save_location'.tr),
            ),
          ),
        ],
      ),
    );
  }
}

class MapLayer extends StatefulWidget {
  const MapLayer({super.key});

  @override
  State<MapLayer> createState() => MapLayerState();
}

class MapLayerState extends State<MapLayer> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
