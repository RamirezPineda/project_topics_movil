import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:project_topics_movil/src/models/index.dart';

class TypeComplaintService extends ChangeNotifier {
  List<TypeComplaint> typesOfComplaintList = [];
  List<DropdownMenuItem<String>> dropdownList = [];

  bool _isLoading = false;

  TypeComplaintService() {
    getAllTypesComplaint();
  }

  bool get isLoading => _isLoading;

  Future<void> getAllTypesComplaint() async {
    _isLoading = true;
    notifyListeners();
    typesOfComplaintList = [];

    try {
      final response = await DioConfig.dio.get('/api/types');
      final List<dynamic> allTypesComplaint = response.data;

      for (var element in allTypesComplaint) {
        final TypeComplaint typeComplaint = TypeComplaint.fromMap(element);
        typesOfComplaintList.add(typeComplaint);
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
    dropdownList.add(
      const DropdownMenuItem(
        value: "",
        enabled: false,
        child: Text('Tipos de denuncia'),
      ),
    );

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
