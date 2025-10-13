import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter/core/config/dio_inizializer.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  assert(!getIt.isRegistered<SharedPreferences>(), 'Service locator already initialized');


  // Initialize SharedPreferences asynchronously
  final sharedPrefs = await SharedPreferences.getInstance();

  // Register it as a singleton
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);
  await getIt.allReady();

  getIt.registerLazySingleton(()=> DioInitializer.getDio());

}