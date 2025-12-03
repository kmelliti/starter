import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/screens/products/controller/products_controller.dart';
import 'package:starter/screens/products/models/product_model.dart';

import '../../../core/di/di.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/single_product_widget.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductController _controller = getIt();


  bool shownAlert = false;
  late final _pagingController = PagingController<int, ProductModel>(
    getNextPageKey:
        (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => _controller.getProducts(pageKey),
  );

  @override
  void initState() {
    _pagingController.addListener(() {
      debugPrint("Updated item count: ${_pagingController.items?.length}");

    });


    _pagingController.addListener((){

      if(_pagingController.status == PagingStatus.completed){
        if(!shownAlert)
        WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("click_image_for_options".tr),
              duration: Duration(seconds: 3),
            ),
          );
          shownAlert  = true;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBarWithBack(context),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            pushUpAnimation(
              Row(
                children: [
                  SvgPicture.asset("assets/icons/product.svg", width: 24),
                  SizedBox(width: 10),
                  Text(
                    "products".tr,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            pushUpAnimation(
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await Get.toNamed(AppRoutes.addProduct);
                        if (res == "success") {
                          _pagingController.refresh();
                        }
                      },
                      child: Text("add_new_product".tr),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: HexColor.fromHex(AppTheme.filledBox),
                        border: Border.all(
                          color: HexColor.fromHex(AppTheme.borderGrey),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "filter_options".tr,
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: HexColor.fromHex(AppTheme.primaryColor),
                            ),
                          ),
                          SizedBox(width: 10),
                          SvgPicture.asset(
                            "assets/icons/filters.svg",
                            width: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Expanded(
              child: PagingListener(

                controller: _pagingController,

                builder:
                    (
                      context,
                      state,
                      fetchNextPage,
                    ) => PagedGridView<int, ProductModel>(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      builderDelegate: PagedChildBuilderDelegate(
                        animateTransitions: true,
                        // [transitionDuration] has a default value of 250 milliseconds.
                        transitionDuration: const Duration(milliseconds: 500),
                        itemBuilder:
                            (context, item, index) => InkWell(
                              onTap: (){
                                Get.toNamed(AppRoutes.productDetails,arguments: item);
                              },
                              child: SingleProductWidget(item,onEdit: ()async {
                                final res = await Get.toNamed(AppRoutes.addProduct,arguments: [item]);

                              }, onDelete: () async{
                                await deleteItem(context, item);
                              },),
                            ),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                    ),
              ),
            ),

            // Expanded(
            //   child: GridView.builder(
            //     shrinkWrap: true,
            //     itemCount: 10,
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 10,
            //       childAspectRatio: 0.8,
            //     ),
            //     itemBuilder: (context, index) {
            //       return SingleProductWidget();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteItem(BuildContext context, ProductModel item) async {
           final  res  = await showDeleteAlert(context);
    if(res == true){
     await _controller.deleteProduct(item.id.toString());
      _pagingController.refresh();
    }else{
      _pagingController.refresh();
    }
  }
}
