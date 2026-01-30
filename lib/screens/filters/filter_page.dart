
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/config/utils.dart';
import '../../core/theme/app_theme.dart';

enum Status {
  draft,
  open,
  funded,
  active,
  closed,
  cancelled
}

typedef FilterCallback = void Function(Map<String,dynamic> filters);
class Filters extends StatefulWidget {
  const Filters({super.key, required this.onFilter});
  final FilterCallback onFilter;

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<String> items = [];
  RangeValues _currentPriceRangeValues = const RangeValues(0, 100);
  RangeValues _quantityRangeValues = const RangeValues(0, 100000);
  RangeValues _reqQuantityRangeValues = const RangeValues(0, 20);
  bool discounted = false;
  String? selectedCategory;
  Map<String,dynamic> filters = {};

  @override
  void initState() {

    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      addItems();
    });
  }

  void addItems() {
    List<String> newItems = Status.values.map((e) => e.name).toList();

    for (int i = 0; i < newItems.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        items.add(newItems[i]);
        _listKey.currentState!.insertItem(items.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getBottomNavigation(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 40),

          quantityRange(),
          SizedBox(height: 10),
          getStatusFilters(),
        ],
      ),
    );
  }

  Widget getDiscounted() {
    return pushUpAnimation(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "applied_discount_products".tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: HexColor.fromHex("#1E1D33"),
                fontSize: 16,
              ),
            ),
            CupertinoSwitch(
              activeTrackColor: HexColor.fromHex(AppTheme.primaryColor),
              value: discounted,
              onChanged: (val) {
                setState(() {
                  discounted = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }



  Widget quantityRange() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: pushUpAnimation(
            Row(
              children: [
                Text(
                  "available_quantity".tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HexColor.fromHex(AppTheme.primaryColor),
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Text(
                  _quantityRangeValues.end.toInt().toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HexColor.fromHex("#5B5B5B"),
                    fontSize: 16,
                  ),
                ),

                SizedBox(width: 10),
                Text("-"),
                SizedBox(width: 10),
                Text(
                  _quantityRangeValues.start.toInt().toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: HexColor.fromHex("#5B5B5B"),
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
        ),
        bounceAnimation(
          c: RangeSlider(
            values: _quantityRangeValues,
            min: 0,
            max:100000,
            inactiveColor: HexColor.fromHex("#DEDDFF"),
            activeColor: HexColor.fromHex(AppTheme.primaryColor),
            labels: RangeLabels(
              RangeValues(0, 100).start.roundToDouble().toString(),
              RangeValues(0, 100).end.roundToDouble().toString(),
            ),
            onChanged: (values) {
              setState(() {
                _quantityRangeValues = values;
              });
            },
          ),
        ),
      ],
    );
  }



  Widget getBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: HexColor.fromHex("#F9F8FF"),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () {

            filters.putIfAbsent("quantity_min", ()=> _quantityRangeValues.start);
            filters.putIfAbsent("quantity_max", ()=> _quantityRangeValues.end);
            if(selectedCategory != null){
              filters.putIfAbsent("status", ()=> selectedCategory);
            }
            widget.onFilter(filters);
            Get.back();
          }, child: Text("apply_filers".tr)),
          TextButton(
            onPressed: () {},
            child: Text(
              "reset_filters".tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: HexColor.fromHex(AppTheme.primaryColor),
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  getStatusFilters() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "status_deal".tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: HexColor.fromHex("#1E1D33"),
              fontSize: 16,
            ),
          ),

          SizedBox(height: 10),
          Container(
            height: 40,

            child: AnimatedList(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              key: _listKey,
              initialItemCount: items.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color:
                      selectedCategory == items[index]
                          ? HexColor.fromHex("#DEDDFF")
                          : Colors.white,
                      border: Border.all(
                        color: HexColor.fromHex(AppTheme.borderGrey),
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = items[index];
                          log("message ${selectedCategory}");
                        });
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(items[index].tr),
                            selectedCategory == items[index]
                                ? Icon(
                              Icons.check,
                              color: HexColor.fromHex(
                                AppTheme.primaryColor,
                              ),
                            )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
