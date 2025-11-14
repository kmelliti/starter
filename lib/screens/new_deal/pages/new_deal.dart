import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starter/core/config/app_constants.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/core/routes/app_routes.dart';
import 'package:starter/screens/new_deal/controller/deal_controller.dart';
import 'package:starter/screens/products/controller/products_controller.dart';
import 'package:starter/screens/products/models/product_model.dart';

import '../../../core/di/di.dart';
import '../../../core/theme/app_theme.dart';
import '../models/store_location_model.dart';

class NewDeal extends StatefulWidget {
  NewDeal({super.key});

  @override
  State<NewDeal> createState() => _NewDealState();
}

class _NewDealState extends State<NewDeal> {
  final ProductController _productController = getIt();


  ProductModel? selectedProduct;
  int? selectedStore;
  late Future _future;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _priceOnStoreController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final DealController _dealController = getIt();

  @override
  void initState() {
    _future = _dealController.getStoreLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                buildATitle(context, "create_new_deal".tr),
                SizedBox(height: 20),
                getProductDropDown(),
                SizedBox(height: 20),
                getStoreDropDown(),
                SizedBox(height: 20),
                pushUpAnimation(
                  TextFormField(
                    controller: _priceController,

                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "field_required".tr;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,

                    onTapOutside: (p){
                      FocusScope.of(context).unfocus();

                    },
                    decoration: InputDecoration(
                      hintText: "price".tr,

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      suffixIcon: Container(
                        padding: EdgeInsets.all(15),
                        child: SvgPicture.asset(
                          "assets/icons/sar.svg",
                          height: 15,
                        ),
                      ),
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  ),
                ),
                SizedBox(height: 20),
                pushUpAnimation(
                  TextFormField(
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "field_required".tr;
                      }
                      return null;
                    },
                    controller: _priceOnStoreController,
                    keyboardType: TextInputType.number,
                    onTapOutside: (p){
                      FocusScope.of(context).unfocus();

                    },
                    decoration: InputDecoration(
                      hintText: "price_on_store".tr,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      suffixIcon: Container(
                        padding: EdgeInsets.all(15),
                        child: SvgPicture.asset(
                          "assets/icons/sar.svg",
                          height: 15,
                        ),
                      ),
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  ),
                ),
                SizedBox(height: 20),
                pushUpAnimation(
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onTapOutside: (p){
                      FocusScope.of(context).unfocus();

                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "field_required".tr;
                      }
                      return null;
                    },
                    controller: _quantityController,
                    decoration: InputDecoration(
                      hintText: "quantity".tr,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  ),
                ),
                SizedBox(height: 20),
                sideInAnimation(
                  child: ValueListenableBuilder(
                    valueListenable: isLoading,
                    builder: (context, val, _) {
                      return val
                          ? Center(child: getLoader())
                          : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() && selectedProduct!= null && selectedStore!= null) {
                                isLoading.value = true;
                                Map<String, dynamic> params = {
                                  "product_id": selectedProduct!.id,
                                  "location_ids": jsonEncode([selectedStore!]),
                                  "wholesale_price": _priceController.text,
                                  "retail_price":
                                      _priceOnStoreController.text,
                                  "quantity": _quantityController.text,
                                };

                                try {
                                  await _dealController.createDeal(params);
                                  _dealController.showSuccessDialog(context);
                                } catch (e,s) {
                                  log("Deal eroro $e , $s");
                                  showErrorDialog(context, "error_body".tr);
                                }
                                isLoading.value = false;
                              }
                            },
                            child: Text("create".tr),
                          );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getProductDropDown() {
    return FutureBuilder(
      //TODO should not be a pagination
      future: _productController.getProducts(1),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(child: Text("error".tr));
        }
        if (snap.hasData ) {
          List<ProductModel> list = (snap.data as List<ProductModel>);

          if (list.isEmpty) {
            return pushUpAnimation(
               Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
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
                    Text("no_products".tr),
                    TextButton(onPressed: (){

                      Get.toNamed(AppRoutes.addProduct);
                    }, child: Text("add_new_product".tr),)
                  ],
                ),
              ),
            );
          }
          return pushUpAnimation(
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 20),
              // height: 60,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(30),
              //   color: Colors.white,
              //   border: Border.all(
              //     color: HexColor.fromHex(AppTheme.borderGrey),
              //   ),
              // ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<ProductModel>(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  validator: (v) {
                    if (v == null) {
                      return "field_required".tr;
                    }
                    return null;
                  },
                  isExpanded: true,
                  value: list.firstWhereOrNull(
                    (item) =>
                        selectedProduct?.id.toString() == item.id.toString(),
                  ),
                  hint: Text("choose_product".tr),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  items:
                      list
                          .map(
                            (e) => DropdownMenuItem<ProductModel>(
                              value: e,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 30,
                                    width: 30,
                                    child: e.productPictures .isEmpty ? Container():ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        "${baseUrlImage}${e.productPictures.first.picture}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(e.name),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        selectedProduct = v;
                      });
                    }
                  },
                ),
              ),
            ),
          );
        }
        if(snap.connectionState == ConnectionState.waiting)
        return Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: HexColor.fromHex(AppTheme.primaryColor),
            size: 40,
          ),
        );

        return Container();
      },
    );
  }

  Widget getStoreDropDown() {
    return FutureBuilder(
      //TODO should not be a pagination
      future: _future,
      builder: (context, snap) {
        if (snap.hasError) {
          log("message ${snap.error}");
          return Center(child: Text("error".tr));
        }
        if (snap.connectionState == ConnectionState.done && snap.hasData) {
          List<StoreLocationModel> locations = snap.data!;
          return pushUpAnimation(
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 20),
              // height: 60,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(30),
              //   color: Colors.white,
              //   border: Border.all(
              //     color: HexColor.fromHex(AppTheme.borderGrey),
              //   ),
              // ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<StoreLocationModel>(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  validator: (v) {
                    if (v == null) {
                      return "field_required".tr;
                    }
                    return null;
                  },
                  isExpanded: true,
                  value: locations.firstWhereOrNull((item) => selectedStore == item.id),
                  hint: Text("choose_store".tr),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  items:
                  locations
                          .map(
                            (e) => DropdownMenuItem<StoreLocationModel>(
                              value: e,
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 30,
                                    width: 30,
                                    child: Icon(
                                      Icons.store,
                                      color: HexColor.fromHex(
                                        AppTheme.primaryColor,
                                      ),
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(e.address,overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        selectedStore = v.id;
                      });
                    }
                  },
                ),
              ),
            ),
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
