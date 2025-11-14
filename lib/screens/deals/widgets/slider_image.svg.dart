import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_color_builder/image_color_builder.dart';
import 'package:starter/core/config/utils.dart';

import '../../../core/theme/app_theme.dart';

class SliderImages extends StatefulWidget {
  SliderImages({super.key});

  @override
  State<SliderImages> createState() => _SliderImagesState();
}

class _SliderImagesState extends State<SliderImages> {
  List<String> imgs = [
    "https://www.pngall.com/wp-content/uploads/4/Starbucks-Coffee-PNG.png",
    "https://www.pngall.com/wp-content/uploads/4/Starbucks-Cup-PNG-Free-Image.png",
    "https://wallpapers.com/images/high/starbucks-frappuccino-transparent-background-w40q1jshuhn9xurj.png",
    "https://www.pngkey.com/png/full/36-361680_related-products-starbucks-new-logo-2011.png",
  ];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  late final ValueNotifier<String> img;

  @override
  void initState() {
    img = ValueNotifier(imgs.first);
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      addItems();
    });
  }

  List<String> newImgs = [];

  void addItems() {
    for (int i = 0; i < newImgs.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        imgs.add(newImgs[i]);
        _listKey.currentState!.insertItem(imgs.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: img,
          builder: (context, value, child) {
            return ImageColorBuilder(
                url: value,
                builder: (c,image,color){
              return Container(
                height: 300,

                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Center(child: image),
                    Positioned(
                      bottom: 0,
                      top: 0,
                      right: 10,
                      child: InkWell(
                        onTap: (){
                          if(imgs.indexOf(value) == 0){

                            img.value = imgs.last;
                            return;
                          }
                          img.value = imgs[imgs.indexOf(value) - 1];
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: HexColor.fromHex(AppTheme.primaryColor),
                            shape: BoxShape.circle,

                          ),
                          child: Icon(Icons.arrow_back,color: Colors.white,size: 20,),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      top: 0,
                      left: 10,
                      child: InkWell(
                        onTap: (){
                          if(imgs.indexOf(value) == imgs.length-1){
                            img.value = imgs.first;
                            return;
                          }
                          img.value = imgs[imgs.indexOf(value) + 1];

                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: HexColor.fromHex(AppTheme.primaryColor),
                            shape: BoxShape.circle,

                          ),
                          child: Icon(Icons.arrow_forward,color: Colors.white,size: 20,),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        ),
        SizedBox(height: 10),
        Container(
          height: 90,
          child: AnimatedList(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            key: _listKey,
            initialItemCount: imgs.length,
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: ValueListenableBuilder(
                  valueListenable: img,
                  builder: (context, value, child) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: InkWell(
                        onTap: () {
                          img.value = imgs[index];
                        },
                        child: ImageColorBuilder(
                          url: imgs[index],
                          // url: 'assets/images/local.jpg',
                          fit: BoxFit.contain,
                          maxCachedCount: 10,
                          builder: (
                            BuildContext context,
                            Image? image,
                            Color? imageColor,
                          ) {
                            return Container(
                              height: 80,
                              width: 80,

                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),

                                border:
                                    value == imgs[index]
                                        ? Border.all(
                                          color: HexColor.fromHex(
                                            AppTheme.primaryColor,
                                          ),
                                      width: 3,
                                        )
                                        : Border.all(color: Colors.grey),
                                color:
                                    imageColor?.withOpacity(0.8) ??
                                    Colors.white,
                              ),
                              child: image ?? Container(),
                            );
                            return Container(
                              height: 80,
                              width: 80,
                              padding: const EdgeInsets.all(40),

                              decoration: BoxDecoration(
                                //  color: imageColor?.withOpacity(0.8) ?? Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: image?.image,
                              ),
                            );
                          },
                          placeholder:
                              (contect, url) => Center(
                                child: Image.asset(
                                  'assets/0484aab0c5a24014f17a6bf62f729f73711ad0ed.gif',
                                  fit: BoxFit.fill,
                                ),
                              ),

                          // errorWidget: (context, url, error) => Image.asset(
                          //   'assets/images/error.png',
                          //   fit: BoxFit.fill,
                          // ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
