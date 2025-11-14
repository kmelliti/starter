
import 'package:flutter/material.dart';
import 'package:starter/core/di/di.dart';
import 'package:starter/screens/main_screen/controller/main_screen_controller.dart';
import 'package:starter/screens/my_account/pages/my_account.dart';
import 'package:starter/screens/new_deal/pages/new_deal.dart';

import '../../../core/config/bottom_navigator.dart';
import '../../home_page/pages/home_page.dart';


class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainScreenController _controller = getIt();


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable:_controller. indexWidget,
        builder: (c,i,_){

          switch(i){
            case 0:
              return HomePage();
            case 1:
              return NewDeal();
            case 2:
              return MyAccount();
            default:
              return HomePage();
          }
        },
      ),
      bottomNavigationBar: CustomBottomNav(onItemTapped: (int index) {
        _controller. indexWidget.value = index;
      }),
    );
  }
}
