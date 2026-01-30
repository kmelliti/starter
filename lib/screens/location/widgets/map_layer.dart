import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../my_account/controller/my_account_controller.dart';

typedef void OnAddressSelected(String address,LatLng position);
class MapLayer extends StatefulWidget {
  const MapLayer({super.key, required this.onAddressSelected, this.marker});
  final OnAddressSelected onAddressSelected;
  final Marker? marker;

  @override
  State<MapLayer> createState() => MapLayerState();
}

class MapLayerState extends State<MapLayer> {
  LatLng? selectedPosition;
  Set<Marker> markers = {};
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(24.725118962911782, 46.64921132187667),
    zoom: 14.4746,
  );

  final MyAccountController myAccountController = getIt<MyAccountController>();
  @override
  void initState() {
    myAccountController.controller = _controller;
    if(widget.marker != null){
      log("Initial marker not null");
      markers.add(widget.marker!);
    }else{
      log("marker is null");
    }
    super.initState();
  }
  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
        onTap: (position)async{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedPosition = position;
              markers.clear();
              markers.add(Marker(markerId: MarkerId(position.toString()), position: position));
            });
          });
          String address = await getAddressFromLatLng(position.latitude, position.longitude);
          log(address);
          widget.onAddressSelected(address, position);
        },
      ),

    );
  }

  Future<void> goToAddress(CameraPosition cp) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(cp));
  }


}