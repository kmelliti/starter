import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_color_builder/image_color_builder.dart';
import 'package:starter/core/config/app_constants.dart';
import 'package:starter/core/config/utils.dart';

import '../../../core/theme/app_theme.dart';
import '../../products/models/product_model.dart';

class SliderImages extends StatefulWidget {
  SliderImages({super.key, required this.pictures});

  final List<ProductPicture> pictures;

  @override
  State<SliderImages> createState() => _SliderImagesState();
}

class _SliderImagesState extends State<SliderImages> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  late final ValueNotifier<String> img;

  @override
  void initState() {
    img = ValueNotifier(widget.pictures.first.picture);
    log(img.value);
    super.initState();
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
              url: "$baseUrlImage/$value",
              builder: (c, image, color) {
                return Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: HexColor.fromHex(AppTheme.borderGrey),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(child: image),
                      Positioned(
                        bottom: 0,
                        top: 0,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            int currentIndex = widget.pictures.indexWhere(
                              (element) => element.picture == value,
                            );
                            log(
                              "arroww back $currentIndex ${widget.pictures.length}",
                            );
                            if (currentIndex + 1 == widget.pictures.length) {
                              img.value = widget.pictures.first.picture;
                            } else {
                              img.value =
                                  widget.pictures[currentIndex + 1].picture;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: HexColor.fromHex(AppTheme.primaryColor),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        top: 0,
                        left: 10,
                        child: InkWell(
                          onTap: () {
                            int currentIndex = widget.pictures.indexWhere(
                              (element) => element.picture == value,
                            );
                            log(
                              "arroww back $currentIndex ${widget.pictures.length}",
                            );
                            if (currentIndex == 0) {
                              img.value = widget.pictures.last.picture;
                            } else {
                              img.value =
                                  widget.pictures[currentIndex - 1].picture;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: HexColor.fromHex(AppTheme.primaryColor),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        SizedBox(height: 10),
        Container(
          height: 90,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            key: _listKey,
            itemCount: widget.pictures.length,
            itemBuilder: (context, index) {
              return ValueListenableBuilder(
                valueListenable: img,
                builder: (context, value, child) {
                  return Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    //   border: Border.all(color: HexColor.fromHex(AppTheme.borderGrey)),
                    // ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),

                      border:
                          value == widget.pictures[index].picture
                              ? Border.all(
                                color: HexColor.fromHex(AppTheme.primaryColor),
                                width: 3,
                              )
                              : Border.all(color: Colors.grey),
                    ),
                    margin: EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        img.value = widget.pictures[index].picture;
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        child: ImageColorBuilder(
                          url: "$baseUrlImage/${widget.pictures[index].picture}",
                          // url: 'assets/images/local.jpg',
                          fit: BoxFit.cover,
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
                                color:
                                    imageColor?.withOpacity(0.8) ?? Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
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
                              child: CircleAvatar(backgroundImage: image?.image),
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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
