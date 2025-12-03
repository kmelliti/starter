import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/screens/filters/filter_page.dart';
import 'package:starter/screens/home_page/models/deal_model.dart';
import 'package:starter/screens/home_page/models/stats_model.dart';
import 'package:starter/screens/main_screen/controller/main_screen_controller.dart';

import '../../../core/di/di.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/home_page_controller.dart';
import '../single_deal.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomePageController _controller = getIt<HomePageController>();
  ValueNotifier<Map<String,dynamic>?> filters = ValueNotifier(null);

  late final _pagingController = PagingController<int, DealModel>(
    getNextPageKey:
        (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => _controller.getDealProducts(pageKey,filters.value),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar((val) {
        log(val);
        filters.value = {
          "product_name":val
        };
        _pagingController.refresh();
      }),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildATitle(context, "home_page".tr),
              FutureBuilder(
                future: _controller.getStats(),
                builder: (c, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: HexColor.fromHex(AppTheme.primaryColor),
                          size: 40,
                        ),
                      ),
                    );
                  }
                  if (snap.connectionState == ConnectionState.done &&
                      snap.hasData) {
                    if (snap.hasError) {
                      return Container();
                    }
                    return getStatsWidget(snap.data!);
                  }
                  return Container();
                },
              ),

              SizedBox(height: 20),
              buildATitle(context, "total_deals".tr),
              SizedBox(height: 20),

              ValueListenableBuilder(
                valueListenable: filters,
                builder: (context,f,_) {
                  return pushUpAnimation(
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            MainScreenController c = getIt();
                            c.indexWidget.value = 1;
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HexColor.fromHex(AppTheme.primaryColor),
                            ),
                            child: SvgPicture.asset("assets/icons/add_stack.svg"),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: HexColor.fromHex("#F8F8FF"),
                              border: Border.all(
                                color: HexColor.fromHex("#C4C4C4"),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                if(f != null){
                                  filters.value = null;
                                  _pagingController.refresh();
                                  return;
                                }
                                showModalBottomSheet(
                                  context: context,
                                  showDragHandle: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  builder: (c) {
                                    return Filters(onFilter: (Map<String, dynamic> f) {
                                      filters.value = f;
                                      _pagingController.refresh();
                                    },);
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    f!= null ? "${"reset_filters".tr} (${f.length})":"filter_options".tr,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      color: HexColor.fromHex(
                                        AppTheme.primaryColor,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SvgPicture.asset("assets/icons/filters.svg"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
              SizedBox(height: 30),
              PagingListener(
                controller: _pagingController,
                builder: (context, state, fetchNext) {
                  return PagedListView<int, DealModel>(
                    fetchNextPage: fetchNext,
                    shrinkWrap: true,

                    physics: NeverScrollableScrollPhysics(),
                    builderDelegate: PagedChildBuilderDelegate(
                      noItemsFoundIndicatorBuilder: (context) {
                        return Center(child: Text("no_deals".tr));
                      },
                      itemBuilder: (context, item, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),

                          // child: Container(),
                          child: sideInAnimation(child: SingleDeal(item)),
                        );
                      },
                    ),

                    state: state,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  getStatsWidget(StatsModel stats) {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: bounceAnimation(
                c: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex("#E9F0FF"),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: HexColor.fromHex("#EBEBEB")),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/money_light.svg",
                        color: HexColor.fromHex(AppTheme.primaryColor),
                      ),

                      getPriceInText(double.parse(stats.totalDeals.toString())),

                      Text("total_deals".tr),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: bounceAnimation(
                c: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex("#E6FFFA"),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: HexColor.fromHex("#EBEBEB")),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/money_bag.svg",
                        color: HexColor.fromHex(AppTheme.primaryColor),
                      ),

                      getPriceInText(
                        double.parse(stats.totalProfits.toString()),
                      ),

                      Text("total_gains".tr),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: bounceAnimation(
                c: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex("#FFF4D3"),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: HexColor.fromHex("#EBEBEB")),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/fly_money.svg",
                        color: HexColor.fromHex(AppTheme.primaryColor),
                      ),

                      getPriceInText(double.parse(stats.withdrawn)),

                      Text("withdrawn".tr),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: bounceAnimation(
                c: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex("#FFE8ED"),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: HexColor.fromHex("#EBEBEB")),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/wallet.svg",
                        color: HexColor.fromHex(AppTheme.primaryColor),
                      ),

                      getPriceInText(double.parse(stats.totalBalance)),

                      Text("total_balance".tr),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
