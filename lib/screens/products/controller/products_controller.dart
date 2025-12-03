import 'package:starter/core/models/lookup_model.dart';
import 'package:starter/screens/products/models/product_model.dart';

import '../../../core/services/product_service.dart';

class ProductController {
  final ProductService _productService;

  ProductController(this._productService);

  Future<List<LookUpModel>> getProductCategories() async{
    return await _productService.getProductCategories();
  }

 Future<List<ProductModel>> getProducts(int pageKey) async{
    return _productService.getProducts(pageKey);
 }

 Future<void> addProduct(List<String> image,Map<String,dynamic> params) async{
    return _productService.addProduct(image, params);
 }

 Future<void> deleteProduct(String id) async{
    return await _productService.deleteProduct(id);
 }
}