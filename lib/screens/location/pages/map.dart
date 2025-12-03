import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapApp extends StatelessWidget {
  MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(
                  'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-s+ff9a4d(21.379631,39.791532)/21.379631,39.791532,10/400x200@2x?access_token=pk.eyJ1IjoiZ2hhc3Nlbm0iLCJhIjoiY21oY201bXY5MGd1MDJpczhhamc1dTI1MyJ9.qcYuXI_X9cIb_pLQFaQ0ng',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
