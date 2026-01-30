import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:starter/core/config/utils.dart';

import '../../screens/main_screen/controller/main_screen_controller.dart';
import '../di/di.dart';
import '../theme/app_theme.dart';

typedef OnItemTapped = void Function(int index);

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key, required this.onItemTapped});

  final OnItemTapped onItemTapped;

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _selectedIndex = 0;
  final MainScreenController _controller = getIt();

  final items = [
    {'icon': 'assets/icons/home.svg', 'label': 'home'.tr},
    {'icon': 'assets/icons/add.svg', 'label': 'create_new_deal'.tr},
    {'icon': 'assets/icons/account.svg', 'label': 'my_account'.tr},
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller.indexWidget,
      builder: (context, v, _) {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_){
      setState(() {
        _selectedIndex = v;
      });
    });
        return Container(
          constraints: BoxConstraints(maxHeight: 120),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xfff8f8fc),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final selected = _selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);

                  widget.onItemTapped(index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      item['icon']!,
                      color:
                          selected
                              ? HexColor.fromHex(
                                AppTheme.primaryColor,
                              ) // dark blue
                              : HexColor.fromHex("#393942"),
                    ),

                    const SizedBox(height: 7),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        color:
                            selected
                                ? HexColor.fromHex(AppTheme.primaryColor)
                                : HexColor.fromHex("#393942"),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: selected ? 20 : 0,
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xff1e1b57),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
