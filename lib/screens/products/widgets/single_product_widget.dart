import 'package:flutter/material.dart';
import 'package:starter/core/config/app_constants.dart';

import '../../../core/config/utils.dart';
import '../../../core/theme/app_theme.dart';
import '../models/product_model.dart';
import 'flip_widgets.dart';

typedef OnEdit = void Function();
typedef OnDelete = void Function();
class SingleProductWidget extends StatelessWidget {
   SingleProductWidget(this.product, {required this.onEdit, required this.onDelete});

   final OnEdit onEdit;
   final OnDelete onDelete;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HexColor.fromHex(AppTheme.filledBox2)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           FlipCard(image:product.productPictures.isEmpty?null:
           product.productPictures.first.picture, onEdit: () { onEdit(); }, onDelete: () { onDelete(); },),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,maxLines:1,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: HexColor.fromHex("#1E1D33"),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis
                ),),
                SizedBox(height: 5,),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: HexColor.fromHex("#1E1D33"),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
          
        ],
      ),
    );
  }
}
