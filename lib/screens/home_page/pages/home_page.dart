import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starter/core/config/utils.dart';
import 'package:starter/screens/filters/filter_page.dart';
import 'package:starter/screens/home_page/models/stats_model.dart';

import '../../../core/di/di.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/home_page_controller.dart';
import '../single_deal.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomePageController _controller = getIt<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
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

              pushUpAnimation(
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColor.fromHex(AppTheme.primaryColor),
                      ),
                      child: SvgPicture.asset("assets/icons/add_stack.svg"),
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
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: true,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              builder: (c) {
                                return Filters();
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "filter_options".tr,
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
              ),
              SizedBox(height: 30),

              sideInAnimation(child: SingleDeal()),
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

                      getPriceInText(double.parse(stats.totalProfits.toString())),

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
