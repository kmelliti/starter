import 'package:dio/dio.dart';

import 'app_constants.dart';

class DioInitializer {
  static Dio getDio() {
    Dio _dio = Dio(
      BaseOptions(
        // baseUrl: dotenv.get("BASE_URL", fallback: ""),
        baseUrl: baseUrl,
      ),
    );
    _dio.interceptors.add(getInterceptor());
    return _dio;
  }

  /*
  Adding interceptor
   */
  static InterceptorsWrapper getInterceptor() {
    return InterceptorsWrapper(
      onRequest: (request, handler) async {
        // final AppController appController = getIt();
        // UserAuthModel? userAuthModel = appController.getUserAuthFromSp();
        // if (userAuthModel != null) {
        //   DateTime timeExpires = userAuthModel.loggedAt
        //       .add(Duration(seconds: userAuthModel.expiresIn));
        //   DateTime tNow = DateTime.now();
        //   final LoginController _loginController = getIt();
        //

        request.headers.putIfAbsent("Content-Type", () => "application/json");
        request.headers.putIfAbsent("Accept", () => "application/json");
        // request.headers.putIfAbsent(
        //   "lang",
        //   () => appController.getAppLanguage() ?? "en",
        // );
        // request.headers.putIfAbsent(
        //   "Authorization",
        //   () => "Bearer ${appController.getUserAuthFromSp()?.token}",
        // );

        return handler.next(request);
      },
      onError: (e, handler) async {


        print(
          "Dio error for ${e.requestOptions.path} : ${e.message} ${e.response}",
        );



        return handler.next(e);
      },
    );
  }
}
