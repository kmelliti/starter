
import 'package:flutter/material.dart';
import 'package:image_color_builder/image_color_builder.dart';

Widget v (){
  return ImageColorBuilder(
    url: 'https://picsum.photos/',
    // url: 'assets/images/local.jpg',
    fit: BoxFit.cover,
    maxCachedCount: 10,
    builder: (BuildContext context, Image? image, Color? imageColor) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: imageColor?.withOpacity(0.8) ?? Colors.red,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: image ?? const Center(child: Text('No image?')),
      );
    },
    placeholder: (contect, url) => Image.asset(
      'assets/images/placeholder.png',
      fit: BoxFit.fill,
    ),
    errorWidget: (context, url, error) => Image.asset(
      'assets/images/error.png',
      fit: BoxFit.fill,
    ),
  );
}