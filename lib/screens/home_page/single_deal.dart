import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/routes/app_routes.dart';
import 'package:starter/screens/home_page/models/deal_model.dart';
import 'package:starter/screens/new_deal/models/store_location_model.dart';

import '../../core/config/app_constants.dart';
import '../../core/config/utils.dart';
import '../../core/theme/app_theme.dart';

class SingleDeal extends StatelessWidget {
  const SingleDeal(this.deal, {super.key});

  final DealModel deal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: HexColor.fromHex("#E8E5E5")),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: HexColor.fromHex('#F9F9F9'),
              borderRadius: BorderRadius.circular(40),
              border: Border(
                bottom: BorderSide(color: HexColor.fromHex("#E8E5E5")),
                left: BorderSide(color: HexColor.fromHex("#E8E5E5")),
                right: BorderSide(color: HexColor.fromHex("#E8E5E5")),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "deal_id".tr,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: HexColor.fromHex("#B4B4B4"),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "#${deal.id}",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: HexColor.fromHex(AppTheme.primaryColor),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: getStatusColor(deal.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    deal.status.tr,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildRowDeal(
            context,
            "product_number".tr,
            deal.product.id.toString(),
            false,
          ),
          buildRowDeal(
            context,
            "price".tr,
            deal.wholesalePrice.toString(),
            true,
          ),
          buildStoreLocationRow(
            context,
            "stores".tr,
            deal.locations.map((e) => e.location).toList(),
          ),
          buildRowDeal(
            context,
            "quantity_storage".tr,
            deal.quantity.toString(),
            false,
          ),
          buildRowDeal(
            context,
            "total_sold".tr,
            deal.quantitySold.toString(),
            false,
          ),
          buildRowDeal(
            context,
            "revenue".tr,
            deal.totalInvested.toString(),
            true,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.dealDetails, arguments: deal);
              },
              child: Text("edit_deal".tr),
              style: AppTheme.outlinedButtonStyle,
            ),
          ),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "open":
        return HexColor.fromHex("#4BC27E");
      case "closed":
        return HexColor.fromHex("#E62F29");
      case "draft":
        return HexColor.fromHex("#FF7700");
      default:
        return HexColor.fromHex(AppTheme.primaryColor);
    }
  }

  Container buildStoreLocationRow(
    BuildContext context,
    String title,
    List<StoreLocationModel> stores,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: HexColor.fromHex(AppTheme.primaryColor),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        builder: (c) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: stores.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: ListTile(
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
                                  title: Text(
                                    stores[index].address,
                                    textAlign: TextAlign.start,
                                  ),
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
                                      color: HexColor.fromHex(
                                        AppTheme.hintColor2,
                                      ),
                                    ),
                                  ),
                                  trailing: InkWell(
                                    onTap: (){

                                    },
                                    child:   Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset('assets/icons/location_target.svg'),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 100,
                      child: Text(
                        stores.length > 1
                            ? "show_stores".tr
                            : stores.isEmpty
                            ? ""
                            : stores.first.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          fontSize: 16,

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* <<<<<<<<<<<<<<  ✨ Windsurf Command ⭐ >>>>>>>>>>>>>>>> */

  /// Builds a row with a title and a value.
  ///
  /// The [title] is displayed on the left side of the row with
  /// the style of [AppTheme.primaryColor] and font size of 16.
  ///
  /// The [value] is displayed on the right side of the row with
  /// the style of [HexColor.fromHex("#5E5D68")] and font size of 16.
  ///
  /// If [isPrice] is true, a SAR icon is displayed next to the [value].
  ///
  /// The row has a margin of 5 pixels on the vertical axis.
  ///
  /* <<<<<<<<<<  1d13621c-4ccd-4bd8-832a-c87281bef4ec  >>>>>>>>>>> */
  Container buildRowDeal(
    BuildContext context,
    String title,
    String value,
    bool isPrice,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: HexColor.fromHex(AppTheme.primaryColor),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    value,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: HexColor.fromHex("#5E5D68"),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      fontSize: 16,
                    ),
                  ),

                  isPrice ? SizedBox(width: 8) : SizedBox(),
                  isPrice
                      ? SvgPicture.asset(
                        "assets/icons/sar.svg",
                        color: HexColor.fromHex("#5E5D68"),
                      )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
