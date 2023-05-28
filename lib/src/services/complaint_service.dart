import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';
import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:project_topics_movil/src/models/index.dart';

class ComplaintService extends ChangeNotifier {
  final _dio = Dio();

  List<Complaint> complaitsList = [];
  late Complaint selectedComplaint;

  ComplaintService() {
    _configureDio();
    getAllComplaint();
  }

  void _configureDio() {
    _dio.options.baseUrl = HttpConfig.BASE_URL;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

  Future<void> getAllComplaint() async {
    final prefs = UserPreferences();
    print('get complaints person');
    try {
      final response =
          await _dio.get('/api/complaints/person/${prefs.personId}');
      List<dynamic> allComplaints = response.data;

      for (var element in allComplaints) {
        final Complaint complaint = Complaint.fromMap(element);
        complaitsList.add(complaint);
      }
      // print(response.data);
    } catch (e) {
      //Todo: hacer algo
    } finally {
      notifyListeners();
    }
  }

  Future<void> registerOrUpdate(Complaint complaint) async {
    if (complaint.id == null) {
      // todo : register complaint
      await registerComplaint(complaint);
    } else {
      // todo: updated complaint
      await updateComplaint(complaint);
    }
  }

  Future<void> registerComplaint(Complaint complaint) async {
    final prefs = UserPreferences();
    try {
      //Todo: verificar que las imagenes sean de menos de 64K
      var formData = FormData.fromMap({
        'title': complaint.title,
        'description': complaint.description,
        'photo1': await MultipartFile.fromFile(complaint.photos[0]),
        'personId': prefs.personId,
        'categoryId': '646e0169bcdb60d381900a9b',
      });

      if (complaint.photos.length == 2) {
        formData.files.add(MapEntry(
            'photo2', await MultipartFile.fromFile(complaint.photos[1])));
      }

      final response = await _dio.post('/api/complaints', data: formData);
      // print(response.data);
      final newComplaint = Complaint.fromMap(response.data);
      // complaitsList.add(newComplaint);
      print(newComplaint);
    } on DioError catch (e) {
      //todo:  hacer algo
    }
  }

  Future<void> updateComplaint(Complaint complaint) async {}

  Future<void> deleteComplaint(String id) async {
    try {
      final response = await _dio.delete('/api/complaints/$id');
      print(response.data);
      // bussca la pos del elemento
      // int index = complaitsList.indexWhere((element) => element.id == id);
      // complaitsList.removeAt(index);

      print(response.data);
    } catch (e) {
      //Todo: hacer algo
    }
  }
}
