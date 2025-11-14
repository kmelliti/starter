import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter/core/config/dio_inizializer.dart';
import 'package:starter/core/services/app_service.dart';
import 'package:starter/core/services/deal_services.dart';
import 'package:starter/core/services/home_page_services.dart';
import 'package:starter/core/services/my_account_services.dart';
import 'package:starter/core/services/product_service.dart';
import 'package:starter/login/presentation/manager/login_controller.dart';
import 'package:starter/screens/my_account/controller/my_account_controller.dart';
import 'package:starter/screens/new_deal/controller/deal_controller.dart';
import 'package:starter/screens/products/controller/products_controller.dart';

import '../../screens/home_page/controller/home_page_controller.dart';
import '../../screens/main_screen/controller/main_screen_controller.dart';
import '../../screens/sign_up/presentation/controller/sign_up_controller.dart';
import '../services/auth_services.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  assert(!getIt.isRegistered<SharedPreferences>(), 'Service locator already initialized');


  // Initialize SharedPreferences asynchronously
  final sharedPrefs = await SharedPreferences.getInstance();

  // Register it as a singleton
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);
  await getIt.allReady();

  getIt.registerLazySingleton(()=> DioInitializer.getDio());
  getIt.registerLazySingleton(()=> AppServices(getIt(), getIt()));
  getIt.registerLazySingleton(()=> AuthService(getIt()));
  getIt.registerLazySingleton(()=> LoginController(getIt()));
  getIt.registerLazySingleton(()=> ProductService(getIt()));
  getIt.registerLazySingleton(()=> ProductController(getIt()));
  getIt.registerLazySingleton(()=> DealServices(getIt()));
  getIt.registerLazySingleton(()=> DealController(getIt()));
  getIt.registerLazySingleton(()=> SignUpController(getIt()));
  getIt.registerLazySingleton(()=> MainScreenController());
  getIt.registerLazySingleton(()=> HomePageServices(getIt()));
  getIt.registerLazySingleton(()=> HomePageController(getIt()));
  getIt.registerLazySingleton(()=> MyAccountServices(getIt()));
  getIt.registerLazySingleton(()=> MyAccountController(getIt()));


}