import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:project_topics_movil/src/models/index.dart';

class TypeComplaintService extends ChangeNotifier {
  final _dio = Dio();

  List<TypeComplaint> typesOfComplaintList = [];
  List<DropdownMenuItem<String>> dropdownList = [];

  bool _isLoading = false;

  TypeComplaintService() {
    _configureDio();
    getAllCategories();
  }

  void _configureDio() {
    _dio.options.baseUrl = HttpConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

  bool get isLoading => _isLoading;

  Future<void> getAllCategories() async {
    _isLoading = true;
    notifyListeners();
    print('llamada');

    try {
      final response = await _dio.get('/api/types');
      final List<dynamic> allCategories = response.data;

      for (var element in allCategories) {
        final TypeComplaint category = TypeComplaint.fromMap(element);
        typesOfComplaintList.add(category);
      }
      loadDropdownList(typesOfComplaintList);
    } on DioException {
      // if (e.response != null) return [];
      // print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadDropdownList(List<TypeComplaint> typesOfComplaint) {
    dropdownList.add(const DropdownMenuItem(
        value: "", enabled: false, child: Text('Tipos de denuncia')));

    for (var i = 0; i < typesOfComplaint.length; i++) {
      dropdownList.add(
        DropdownMenuItem(
          value: typesOfComplaint[i].id,
          child: Text(typesOfComplaint[i].name),
        ),
      );
    }
  }
}
