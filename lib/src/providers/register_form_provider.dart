import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

class RegisterFormProvider extends ChangeNotifier {
  final _dio = Dio();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String ci = '';
  String photo = '';
  String name = '';
  String address = '';
  String phone = '';
  String email = '';
  String password = '';

  int generateCode = 0;
  int verificationCode = -1;

  String photoUrl = '';
  File? newPictureFile;

  bool _isLoading = false;

  RegisterFormProvider() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options.baseUrl = HttpConfig.baseUrl;
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

  Future<Map<String, dynamic>> verifyDataUser() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print('tokenMovil $fcmToken');
//  eIvMCsYVTXStli4KyW_RYz:APA91bE-qeKMs0wU5iS_mOgy0B9_miTsY2GCg9VBoyTS_qBQsKqrtftP6RygYu-wBaYxWDHtIyX1i1kHWq_S5cAP1EP5hpwk_vxcOzanHifX9aAU0dYSvtycqbousGNWdINu2is_7KOt
      var formData = FormData.fromMap({
        'ci': ci,
        'image': await MultipartFile.fromFile(photoUrl),
      });
      // formData.fields.add(MapEntry('name', name));
      final response = await _dio.post('/api/verify-data-user', data: formData);

      name = response.data['name'];
      phone = response.data['phone'];
      address = response.data['address'];
      photo = response.data['photo'];

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response?.data);
        // print(e.response?.statusCode);
        return e.response?.data;
      } else {
        // print(e.requestOptions);
        // print(e.message);
        return {'message': "Ocurrio un error en el server"};
      }
    } catch (error) {
      return {'message': "Ocurrio un error en el server"};
    }
  }

  Future<Map<String, dynamic>> registerNewUser() async {
    try {
      if (generateCode != verificationCode) {
        int randomCode = _random(1000, 9999);
        final data = {'email': email, 'code': randomCode};
        final response = await _dio.post('/api/send-email', data: data);
        generateCode = randomCode;
        return response.data;
      }

      final fcmToken = await FirebaseMessaging.instance.getToken();

      print('Token del movil $fcmToken');

      final data = {
        'ci': ci,
        'name': name,
        'phone': phone,
        'address': address,
        'photo': photo,
        'email': email,
        'password': password,
        'tokenMovil': fcmToken,
      };
      final response = await _dio.post('/api/register', data: data);
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) return e.response?.data;

      return {'message': "Ocurrio un error en el server"};
    }
  }

  void uploadPhoto(String path) {
    newPictureFile = File.fromUri(Uri(path: path));
    photoUrl = path;
    notifyListeners();
  }

  int _random(int min, int max) {
    return Random().nextInt(max - min) + min;
  }

  Future<Map<String, dynamic>> updateProfile() async {
    try {
      final prefs = UserPreferences();
      final data = {'address': address, 'phone': phone};
      if (password != '') {
        data['password'] = password;
      }

      final response =
          await _dio.post('/api/update-profile/${prefs.id}', data: data);

      prefs.address = response.data['address'];
      prefs.phone = response.data['phone'];
      if (password != '') {
        prefs.password = password;
        prefs.lastPasswordChange =
            DateTime.parse(response.data['lastPasswordChange'])
                .toLocal()
                .toString();
        password = '';
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) return e.response?.data;

      return {'message': "Ocurrio un error en el server"};
    }
  }
}
