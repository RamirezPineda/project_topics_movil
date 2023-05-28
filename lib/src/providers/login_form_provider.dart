import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

class LoginFormProvider extends ChangeNotifier {
  final _dio = Dio();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;

  LoginFormProvider() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options.baseUrl = HttpConfig.BASE_URL;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    // _dio.options.sendTimeout = const Duration(seconds: 60);
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  Future<Map<String, dynamic>> authenticate() async {
    try {
      final Map<String, String> data = {'email': email, 'password': password};
      final response = await _dio.post('/api/login', data: data);
      // print(response.data);
      saveUserPreferences(response.data);

      return response.data;
    } on DioError catch (e) {
      if (e.response != null) return e.response?.data;

      return {'message': "Ocurrio un error en el server"};
    }
  }

  void saveUserPreferences(Map<String, dynamic> dataMap) {
    final prefs = UserPreferences();

    prefs.token = dataMap['token'];
    prefs.id = dataMap['_id'];
    prefs.email = dataMap['email'];
    prefs.name = dataMap['name'];
    prefs.ci = dataMap['ci'];
    prefs.address = dataMap['address'];
    prefs.phone = dataMap['phone'];
    prefs.photo = dataMap['photo'];
    prefs.personId = dataMap['personId'];

    prefs.password = password;
  }
}
