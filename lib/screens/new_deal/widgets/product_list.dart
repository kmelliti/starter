import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starter/screens/products/models/product_model.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/config/utils.dart';
import '../../../core/di/di.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/product_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../home_page/controller/home_page_controller.dart';

class ProductList extends StatefulWidget {
  ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ProductService _controller = getIt<ProductService>();

  late final _pagingController = PagingController<int, ProductModel>(
    getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => _controller.getProducts(pageKey),
  );

  @override
  void initState() {


    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => PagingListener(

    controller: _pagingController,
    builder: (context, state, fetchNextPage) => PagedListView<int, ProductModel>(
      shrinkWrap: true,
      fetchNextPage: fetchNextPage,



      builderDelegate: PagedChildBuilderDelegate(

        itemBuilder: (context, item, index) => ListTile(
          onTap: (){
            Get.back(result: item);
          },
          leading:   item.productPictures.isEmpty
              ? Container(width: 0,)
              : ClipRRect(
            borderRadius:
            BorderRadius.circular(5),
            child: Image.network(
              "${baseUrlImage}${item.productPictures.first.picture}",
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
          title: Text(item.name),
          subtitle: Text(item.description,maxLines: 1,style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: HexColor.fromHex(AppTheme.hintColor2)),),

        ),
        noItemsFoundIndicatorBuilder: (context) => Center(
          child: pushUpAnimation(
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
          ),
        ),
        animateTransitions : true,
        firstPageProgressIndicatorBuilder: (context) => Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: HexColor.fromHex(AppTheme.primaryColor),
            size: 40,
          ),
        ),

      ), state: state,
    ),
  );
}

