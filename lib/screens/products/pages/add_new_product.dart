import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starter/core/config/app_constants.dart';
import 'package:starter/screens/products/models/product_model.dart';

import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/models/lookup_model.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/products_controller.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  final ProductController _productController = getIt();
  LookUpModel? selectedCategory;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile?> _images = [];
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ProductModel? product;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) product = Get.arguments[0];
    if (product != null) {
      _productNameController.text = product!.name;
      _productDescriptionController.text = product!.description;
      selectedCategory = LookUpModel(
        id: product!.productCategorie!.id,
        name: product!.productCategorie!.name,
      );
    }
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(context),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildATitle(context, "add_new_product".tr),
                SizedBox(height: 20),
                buildUploadPicture(context),
                SizedBox(height: 20),
                pushUpAnimation(
                  TextFormField(
                    controller: _productNameController,
                    decoration: InputDecoration(
                      hintText: "product_name".tr,
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  ),
                ),
                SizedBox(height: 10),

                pushUpAnimation(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      border: Border.all(
                        color: HexColor.fromHex(AppTheme.borderGrey),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<LookUpModel>(
                        isExpanded: true,
                        value: productCategories.firstWhereOrNull(
                          (item) =>
                              selectedCategory?.id.toString() ==
                              item.id.toString(),
                        ),
                        hint: Text("category".tr,style: AppTheme.getHintStyle(),),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        items:
                            productCategories
                                .map(
                                  (e) => DropdownMenuItem<LookUpModel>(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              selectedCategory = v;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                pushUpAnimation(
                  TextFormField(
                    controller: _productDescriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "description".tr,

                      contentPadding: EdgeInsets.all(20),
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  ),
                ),
                SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, loading, _) {
                    return loading
                        ? Center(child: getLoader())
                        : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              isLoading.value = true;
                              try {
                                await _productController.addProduct(
                                  _images.map((e)=>e!.path).toList(),
                                  {
                                    "name": _productNameController.text,
                                    "description":
                                        _productDescriptionController.text,
                                    "sku":
                                        "${_productNameController.text}_${selectedCategory!.id}_${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10)}",
                                    "product_categorie_id":
                                        selectedCategory!.id,
                                  },
                                );
                                Get.back(result: "success");
                              } catch (e, s) {
                                log("$e , $s");
                              }
                              isLoading.value = false;
                            }
                          },
                          child: Text("save".tr),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategoriesDropDown() {
    return FutureBuilder(
      future: _productController.getProductCategories(),
      builder: (context, snap) {
        if (snap.hasError) {
          log("message ${snap.error}");
          return Center(child: Text("error".tr));
        }
        if (snap.hasData && snap.data!.isNotEmpty) {
          List<LookUpModel> list = (snap.data as List<LookUpModel>);
          log("message ${list.first.toJson()}");
          if (list.isEmpty) {
            return Container();
          }
          return pushUpAnimation(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                border: Border.all(
                  color: HexColor.fromHex(AppTheme.borderGrey),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<LookUpModel>(
                  isExpanded: true,
                  value: list.firstWhereOrNull(
                    (item) =>
                        selectedCategory?.id.toString() == item.id.toString(),
                  ),
                  hint: Text("category".tr),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  items:
                      list
                          .map(
                            (e) => DropdownMenuItem<LookUpModel>(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        selectedCategory = v;
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

  Widget buildUploadPicture(BuildContext context) {
    return InkWell(
      onTap: () async {
        List<XFile?> image = await _imagePicker.pickMultiImage();
        if (image.isNotEmpty) {
          setState(() {
            _images = image;
          });
        }
      },
      child: Container(
        width: double.infinity,
        color: HexColor.fromHex("#F8F8FF"),

        child: DottedBorder(
          animation: controller,
          options: RoundedRectDottedBorderOptions(
            dashPattern: [10, 5],
            strokeWidth: 1,
            radius: Radius.circular(15),

            color: HexColor.fromHex(AppTheme.primaryColor),
            padding: EdgeInsets.all(2),
          ),
          child:
              _images.isNotEmpty
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Image.file(File(_images.first!.path)),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(

                            color: Colors.black54,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _images.map((e) => Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                    width: 50,
                                    height: 50,
                                    margin: EdgeInsets.all(5),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: Image.file(File(e!.path),fit: BoxFit.cover,)),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              _images.remove(e);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white
                                              ),
                                              child: Icon(Icons.close,color: Colors.red,size: 20,)),
                                        )
                                      ],
                                    ))).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          SvgPicture.asset(
                            "assets/icons/upload.svg",
                            color: HexColor.fromHex(AppTheme.primaryColor),
                            width: 25,
                          ),
                          SizedBox(height: 30),

                          Text(
                            'upload_product_image'.tr,
                            style: Theme.of(
                              context,
                            ).textTheme.displayLarge?.copyWith(
                              color: HexColor.fromHex(AppTheme.primaryColor),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'upload_product_image_guide'.tr,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: HexColor.fromHex(AppTheme.primaryColor),

                              letterSpacing: 0.2,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
