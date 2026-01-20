import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/lookup_model.dart';
import '../../../../core/config/app_constants.dart';
import '../../../core/config/utils.dart';
import '../../../core/theme/app_theme.dart';

class CitySelectionScreen extends StatefulWidget {
  final List<LookUpModel> selectedCities;
  final Function(List<LookUpModel>) onCitiesSelected;

  const CitySelectionScreen({
    Key? key,
    required this.selectedCities,
    required this.onCitiesSelected,
  }) : super(key: key);

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen>  with SingleTickerProviderStateMixin {
  late List<LookUpModel> _selectedCities;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward();

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    _selectedCities = List.from(widget.selectedCities);
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onCitySelected(LookUpModel city, bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedCities.add(city);
      } else {
        _selectedCities.removeWhere((c) => c.id == city.id);
      }
    });
    widget.onCitiesSelected(_selectedCities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: HexColor.fromHex(AppTheme.primaryColor))
          ),
         child  : InkWell(
           onTap: () {

             Navigator.pop(context,_selectedCities);
           },
           child: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress: animation,
                color: HexColor.fromHex(AppTheme.primaryColor),
                size: 40.0,
                semanticLabel: 'Show menu',
              ),
         )
        ),

      ),
      body:
          cities.isEmpty
              ? const Center(child: Text('No cities available'))
              : ListView.separated(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  final isSelected = _selectedCities.any(
                    (c) => c.id == city.id,
                  );

                  return CheckboxListTile(
                    title: Text(city.name ,style: TextStyle(color: HexColor.fromHex(AppTheme.primaryColor)),),
                    visualDensity: VisualDensity.compact,
                    selectedTileColor: HexColor.fromHex(AppTheme.primaryColor),
                    checkColor: Colors.white,
                    activeColor: HexColor.fromHex(AppTheme.primaryColor),
                    value: isSelected,
                    onChanged: (bool? value) => _onCitySelected(city, value),
                    secondary:  Icon(Icons.location_city,color: HexColor.fromHex(AppTheme.primaryColor),),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 150),
                    child:  Divider(color: HexColor.fromHex(AppTheme.primaryColor),),
                  );
                },
              ),
    );
  }
}
