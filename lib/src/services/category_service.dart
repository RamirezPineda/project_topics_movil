import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:project_topics_movil/src/models/index.dart';

class CategoryService extends ChangeNotifier {
  final _dio = Dio();

  List<Category> categoryList = [];
  bool _isLoading = false;

  CategoryService() {
    _configureDio();
    getAllCategories();
  }

  void _configureDio() {
    _dio.options.baseUrl = HttpConfig.BASE_URL;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

  bool get isLoading => _isLoading;

  Future<void> getAllCategories() async {
    _isLoading = true;
    print('llamada');
    try {
      final response = await _dio.get('/api/categories');
      final List<dynamic> allCategories = response.data;

      for (var element in allCategories) {
        final Category category = Category.fromMap(element);
        categoryList.add(category);
      }
    } on DioError catch (e) {
      // if (e.response != null) return [];
      // print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
