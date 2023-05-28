import 'dart:io';

import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

final prefs = UserPreferences();

class HttpConfig {
  // static const String BASE_URL = 'http://192.168.0.58:3000';
  static const String BASE_URL = 'http://192.168.0.58:3000';
  // static Map<String, String> HEADERS = {
  //   HttpHeaders.contentTypeHeader: 'application/json',
  //   HttpHeaders.acceptHeader: 'application/json'
  // };
}

//    HttpHeaders.authorizationHeader: 'Bearer ${prefs.token}',

  // maximo de 40 caracteres para el nombre de las categorias

//https://assets9.lottiefiles.com/packages/lf20_dfvrnyjk.json //calles
//https://assets2.lottiefiles.com/private_files/lf30_nep75hmm.json //agua y alcantarillado
//https://assets6.lottiefiles.com/packages/lf20_tnxlbtdv.json // basura
//https://assets1.lottiefiles.com/private_files/lf30_yhljh5ij.json //accidente de autos
//https://assets6.lottiefiles.com/packages/lf20_fgvmiyev.json //transporte publico