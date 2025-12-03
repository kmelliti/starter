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
import 'package:starter/screens/new_deal/widgets/store_list.dart';
import 'package:starter/screens/products/controller/products_controller.dart';
import 'package:starter/screens/products/models/product_model.dart';

import '../../../core/di/di.dart';
import '../../../core/theme/app_theme.dart';
import '../models/store_location_model.dart';
import '../widgets/product_list.dart';

class NewDeal extends StatefulWidget {
  NewDeal({super.key});

  @override
  State<NewDeal> createState() => _NewDealState();
}

class _NewDealState extends State<NewDeal> {
  final ProductController _productController = getIt();

  ProductModel? selectedProduct;
  List<StoreLocationModel> selectedStores = [];

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _priceOnStoreController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool productError = false;
  bool storeError = false;

  final DealController _dealController = getIt();

  @override
  void initState() {

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
                pushUpAnimation(
                  InkWell(
                    onTap: () async {
                      ProductModel? product = await showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: (c) {
                          return ProductList();
                        },
                      );

                      if (product != null) {
                        setState(() {
                          selectedProduct = product;
                        });
                      }
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: productError ? Colors.red : HexColor.fromHex("#CDCCE0"),
                        ),
                      ),
                      child: Row(
                        children: [
                          selectedProduct != null
                              ? Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(

                                      child: Image.network(
                                        "${baseUrlImage}${selectedProduct!.productPictures.first.picture}",
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ),
                              )
                              : Container(),
                          SizedBox(width: 10,),
                          selectedProduct == null ?  Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7.0),
                            child: Text( "choose_product".tr,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: HexColor.fromHex(AppTheme.hintColor2)
                            )),
                          ):Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7.0),
                            child: Text(selectedProduct!.name),
                          ),
                        ],
                      ),
                    ),

                  ),
                ),
                // SizedBox(height: 20),
                // getProductDropDown(),
                SizedBox(height: 20),
                pushUpAnimation(
                  InkWell(
                    onTap: () async {
                      List<StoreLocationModel>? stores = await showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: (c) {
                          return StoreList(stores: selectedStores);
                        },
                      );

                      if (stores != null) {
                        setState(() {
                          selectedStores = stores;
                        });
                      }
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: storeError ? Colors.red : HexColor.fromHex("#CDCCE0"),
                        ),
                      ),
                      child: Row(
                        children: [
                          selectedStores.isEmpty ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7.0),
                            child: Text("choose_store".tr,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: HexColor.fromHex(AppTheme.hintColor2)
                            ),)
                          ):Container(
                            padding: EdgeInsets.symmetric(vertical: 7.0),
                            child: Text(selectedStores.map((e) => e.address).join(", "),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          )
                        ],
                      ),
                    ),

                  ),
                ),
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

                    onTapOutside: (p) {
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
                    onTapOutside: (p) {
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
                    onTapOutside: (p) {
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
                              if(selectedStores.isEmpty){
                                storeError = true;
                                setState(() {

                                });
                                return;
                              }
                              if(selectedProduct == null){
                                productError = true;
                                setState(() {

                                });
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                isLoading.value = true;
                                Map<String, dynamic> params = {
                                  "product_id": selectedProduct!.id,
                                  "location_ids": jsonEncode(selectedStores.map((e) => e.id).toList()),
                                  "wholesale_price": _priceController.text,
                                  "store_price": _priceOnStoreController.text,
                                  "quantity": _quantityController.text,
                                };

                                try {
                                  await _dealController.createDeal(params);
                                  _dealController.showSuccessDialog(context);
                                } catch (e, s) {
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
      future: _productController.getProducts(1),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(child: Text("error".tr));
        }
        if (snap.hasData) {
          List<ProductModel> list = (snap.data as List<ProductModel>);

          if (list.isEmpty) {
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
                    Text("no_products".tr),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.addProduct);
                      },
                      child: Text("add_new_product".tr),
                    ),
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
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<ProductModel>(
                    padding: EdgeInsets.symmetric(vertical: 5),
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
                    hint: Text(
                      "choose_product".tr,
                      style: AppTheme.getHintStyle(),
                    ),
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    items:
                        list
                            .map(
                              (e) => DropdownMenuItem<ProductModel>(
                                value: e,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 30,
                                      width: 30,
                                      child:
                                          e.productPictures.isEmpty
                                              ? Container()
                                              : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.network(
                                                  "${baseUrlImage}${e.productPictures.first.picture}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(e.name, textAlign: TextAlign.center),
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
            ),
          );
        }
        if (snap.connectionState == ConnectionState.waiting)
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

  // Widget getStoreDropDown() {
  //   return FutureBuilder(
  //     future: _future,
  //     builder: (context, snap) {
  //       if (snap.hasError) {
  //         log("message ${snap.error}");
  //         return Center(child: Text("error".tr));
  //       }
  //       if (snap.connectionState == ConnectionState.done && snap.hasData) {
  //         List<StoreLocationModel> locations = snap.data!;
  //         if (locations.isEmpty) {
  //           return pushUpAnimation(
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(30),
  //                 color: Colors.white,
  //                 border: Border.all(
  //                   color: HexColor.fromHex(AppTheme.borderGrey),
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text("no_stores".tr),
  //                   TextButton(
  //                     onPressed: () {
  //                       Get.toNamed(AppRoutes.locations);
  //                     },
  //                     child: Text("add_new_store".tr),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }
  //
  //         return pushUpAnimation(
  //           Container(
  //             // padding: EdgeInsets.symmetric(horizontal: 20),
  //             // height: 60,
  //             // decoration: BoxDecoration(
  //             //   borderRadius: BorderRadius.circular(30),
  //             //   color: Colors.white,
  //             //   border: Border.all(
  //             //     color: HexColor.fromHex(AppTheme.borderGrey),
  //             //   ),
  //             // ),
  //             child: ButtonTheme(
  //               alignedDropdown: true,
  //               child: DropdownButtonHideUnderline(
  //                 child: DropdownButtonFormField<StoreLocationModel>(
  //                   padding: EdgeInsets.symmetric(vertical: 5),
  //                   validator: (v) {
  //                     if (v == null) {
  //                       return "field_required".tr;
  //                     }
  //                     return null;
  //                   },
  //                   isExpanded: true,
  //                   value: locations.firstWhereOrNull(
  //                     (item) => selectedStore == item.id,
  //                   ),
  //                   hint: Text(
  //                     "choose_store".tr,
  //                     style: AppTheme.getHintStyle(),
  //                   ),
  //                   icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
  //                   items:
  //                       locations
  //                           .map(
  //                             (e) => DropdownMenuItem<StoreLocationModel>(
  //                               value: e,
  //                               child: Row(
  //                                 children: [
  //                                   Container(
  //                                     margin: EdgeInsets.symmetric(vertical: 2),
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(10),
  //                                     ),
  //                                     height: 30,
  //                                     width: 30,
  //                                     child: Icon(
  //                                       Icons.store,
  //                                       color: HexColor.fromHex(
  //                                         AppTheme.primaryColor,
  //                                       ),
  //                                       size: 30,
  //                                     ),
  //                                   ),
  //                                   SizedBox(width: 10),
  //                                   Text(
  //                                     e.address,
  //                                     overflow: TextOverflow.ellipsis,
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           )
  //                           .toList(),
  //                   onChanged: (v) {
  //                     if (v != null) {
  //                       setState(() {
  //                         selectedStore = v.id;
  //                       });
  //                     }
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       }
  //       return Center(
  //         child: LoadingAnimationWidget.staggeredDotsWave(
  //           color: HexColor.fromHex(AppTheme.primaryColor),
  //           size: 40,
  //         ),
  //       );
  //     },
  //   );
  // }
}
