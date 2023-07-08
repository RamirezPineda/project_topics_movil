import 'package:dio/dio.dart';
// import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

// final prefs = UserPreferences();

class DioConfig {
  static final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.43.226:3000',
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  // void _configureDio() {
  //   _dio.options.baseUrl = HttpConfig.BASE_URL;
  //   _dio.options.connectTimeout = const Duration(seconds: 60);
  //   _dio.options.receiveTimeout = const Duration(seconds: 60);
  // _dio.options.sendTimeout = const Duration(seconds: 60);
  // }
}

class HttpConfig {
  static const String baseUrl = 'http://192.168.43.226:3000';

  // static Map<String, String> HEADERS = {
  //   HttpHeaders.contentTypeHeader: 'application/json',
  //   HttpHeaders.acceptHeader: 'application/json'
  // };
}

//    HttpHeaders.authorizationHeader: 'Bearer ${prefs.token}',

//https://assets9.lottiefiles.com/packages/lf20_dfvrnyjk.json //calles
//https://assets2.lottiefiles.com/private_files/lf30_nep75hmm.json //agua y alcantarillado
//https://assets6.lottiefiles.com/packages/lf20_tnxlbtdv.json // basura
//https://assets1.lottiefiles.com/private_files/lf30_yhljh5ij.json //accidente de autos
//https://assets6.lottiefiles.com/packages/lf20_fgvmiyev.json //transporte publico