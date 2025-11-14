import 'package:flutter/material.dart';
import 'package:starter/core/config/app_constants.dart';

import '../../../core/config/utils.dart';
import '../../../core/theme/app_theme.dart';
import '../models/product_model.dart';

class SingleProductWidget extends StatelessWidget {
   SingleProductWidget(this.product);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HexColor.fromHex(AppTheme.borderGrey)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 100,

            decoration: BoxDecoration(
              color: HexColor.fromHex("#E8E5E5"),
              border: Border(
                bottom: BorderSide(color: HexColor.fromHex(AppTheme.borderGrey)),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: product.productPictures.isEmpty?Container(): ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network("${baseUrlImage}${product.productPictures.first.picture}",fit: BoxFit.fitWidth,)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: HexColor.fromHex("#1E1D33"),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  fontSize: 20,
                ),),
                SizedBox(height: 5,),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: HexColor.fromHex("#1E1D33"),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    fontSize: 14,
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
