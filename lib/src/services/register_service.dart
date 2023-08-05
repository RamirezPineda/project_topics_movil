import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:project_topics_movil/src/models/index.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

class RegisterService {
  int generateCode = 0;
  int verificationCode = -1;

  Future<Map<String, dynamic>> verifyDataUser(Person person) async {
    try {
      // final fcmToken = await FirebaseMessaging.instance.getToken();
      // print('tokenMovil $fcmToken');
      var formData = FormData.fromMap({
        'ci': person.ci,
        'image': await MultipartFile.fromFile(person.photo),
      });
      // formData.fields.add(MapEntry('name', name));
      final response =
          await DioConfig.dio.post('/api/verify-data-user', data: formData);

      person.name = response.data['name'];
      person.phone = response.data['phone'];
      person.address = response.data['address'];
      person.photo = response.data['photo'];

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

  Future<Map<String, dynamic>> registerNewUser(User user, Person person) async {
    try {
      if (generateCode != verificationCode) {
        int randomCode = _random(1000, 9999);

        final data = {'email': user.email, 'code': randomCode};
        final response =
            await DioConfig.dio.post('/api/send-email', data: data);

        generateCode = randomCode;
        return response.data;
      }

      final fcmToken = await FirebaseMessaging.instance.getToken();

      print('Token del movil $fcmToken');

      final data = person.toMap();
      data['email'] = user.email;
      data['password'] = user.password;
      data['tokenMovil'] = fcmToken;

      final response = await DioConfig.dio.post('/api/register', data: data);
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) return e.response?.data;

      return {'message': "Ocurrio un error en el server"};
    }
  }

  int _random(int min, int max) {
    return Random().nextInt(max - min) + min;
  }

  Future<Map<String, dynamic>> updateProfile(User user, Person person) async {
    try {
      final prefs = UserPreferences();
      final Map<String, dynamic> data = {
        'address': person.address,
        'phone': person.phone,
        'password': user.password != '' ? user.password : null
      };

      final response = await DioConfig.dio
          .post('/api/update-profile/${prefs.id}', data: data);

      prefs.address = response.data['address'];
      prefs.phone = response.data['phone'];

      if (user.password != '') {
        prefs.password = user.password;
        prefs.lastPasswordChange =
            DateTime.parse(response.data['lastPasswordChange'])
                .toLocal()
                .toString();
        user.password = '';
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) return e.response?.data;

      return {'message': "Ocurrio un error en el server"};
    } catch (e) {
      return {'message': "Ocurrio un error en el server"};
    }
  }
}
