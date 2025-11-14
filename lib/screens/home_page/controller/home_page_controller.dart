import 'package:starter/core/services/home_page_services.dart';
import 'package:starter/screens/home_page/models/stats_model.dart';

class HomePageController {


  final HomePageServices _homePageServices ;

  HomePageController(this._homePageServices);


  Future<StatsModel> getStats()async{
    return await _homePageServices.getStats();
  }
}