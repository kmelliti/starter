import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:starter/core/config/app_constants.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/screens/deals/widgets/slider_image.svg.dart';
import 'package:starter/screens/home_page/controller/home_page_controller.dart';
import 'package:starter/screens/products/models/product_model.dart';

import '../../../core/di/di.dart';
import '../../../core/theme/app_theme.dart';
import '../../home_page/models/deal_model.dart';
import '../../new_deal/models/store_location_model.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late ProductModel product;
  final HomePageController _homePageController = getIt();

  @override
  void initState() {
    product = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              SliderImages(pictures: product.productPictures),
              SizedBox(height: 20),

              Container(

                child: Text(product.name,style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: HexColor.fromHex(AppTheme.primaryColor),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  fontSize: 24,
                ),),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "${"category".tr}:",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: HexColor.fromHex(AppTheme.primaryColor),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    productCategories
                        .firstWhereOrNull(
                          (test) =>
                      test.id.toString() ==
                          product.productCategorieId.toString(),
                    )
                        ?.name ??
                        "",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      // Text("product id",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: HexColor.fromHex("#B3B3B3"),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ReadMoreText(
                product.description,
                trimLines: 3,
                colorClickableText: Colors.blue,
                trimMode: TrimMode.Line,


                style: TextStyle(
                  color: HexColor.fromHex("#595959"),
                  fontWeight: FontWeight.w500,

                  letterSpacing: 0.2,
                  fontSize: 14,
                ),
                trimCollapsedText: "show_more".tr,
                trimExpandedText: "show_less".tr,
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
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
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      getMapPictureLink(
                                        stores[index].latitude,
                                        stores[index].longitude,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    stores[index].address,
                                    textAlign: TextAlign.center,
                                  ),
                                  subtitle: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: HexColor.fromHex(
                                          AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text("open_on_map".tr),
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
                          decoration: TextDecoration.underline,
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

  Container buildRowDeal(
      BuildContext context,
      String title,
      String value,
      bool isPrice,
      ) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
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
