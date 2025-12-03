import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/deal_controller.dart';
import '../models/store_location_model.dart';

class StoreList extends StatefulWidget {
  StoreList({super.key, required this.stores});
  final List<StoreLocationModel> stores;

  @override
  State<StoreList> createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  final DealController _dealController = getIt();

  final ValueNotifier<List<StoreLocationModel>> stores = ValueNotifier([]);
  @override
  void initState() {
    stores.value = [...widget.stores];
    log("Stores length ${stores.value.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dealController.getStoreLocation(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(child: Text("error".tr));
        }
        if (snap.connectionState == ConnectionState.done && snap.hasData) {
          List<StoreLocationModel> locations = snap.data!;
          if (locations.isEmpty) {
            return pushUpAnimation(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  border: Border.all(
                    color: HexColor.fromHex(AppTheme.borderGrey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("no_stores".tr),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.locations);
                      },
                      child: Text("add_new_store".tr),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                    valueListenable: stores,
                    builder: (context, list, _) {
                      return ListTile(
                        onTap: () {
                          List<StoreLocationModel> legacyList = stores.value;
                          if (list.contains(locations[index])) {
                            legacyList.remove(locations[index]);
                          } else {
                            legacyList.add(locations[index]);
                          }
                          stores.value = [...legacyList];
                        },
                        leading: Container(
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg",
                              fit: BoxFit.cover,
                              width: 50,
                            ),
                          ),
                        ),
                        title: Text(locations[index].address),
                        subtitle: Text(
                          cities
                                  .firstWhereOrNull(
                                    (test) =>
                                        test.id.toString() ==
                                        cities[index].id.toString(),
                                  )
                                  ?.name ??
                              "",
                          style: TextStyle(
                            color: HexColor.fromHex(AppTheme.hintColor2),
                          ),
                        ),
                        trailing: Checkbox(
                          value: list.contains(locations[index]),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onChanged: (v) {},
                        ),
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                      margin: EdgeInsets.all(20),
                      child: ElevatedButton(onPressed: () {
                        Get.back(result: stores.value);
                      }, child: Text("save".tr),style: AppTheme.outlinedButtonStyle,)),
                ],
              ),
            ],
          );
        }
        return Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: HexColor.fromHex(AppTheme.primaryColor),
            size: 40,
          ),
        );
      },
    );
  }
}
