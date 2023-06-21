import 'package:flutter/material.dart';

import 'package:project_topics_movil/src/models/index.dart';

class ComplaintFormController extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Complaint complaint;
  bool _isLoading = false;

  ComplaintFormController(this.complaint);

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isImageExtensionValid(String filePath) {
    final validExtensions = ['.jpg', '.jpeg'];
    final fileExtension = filePath.toLowerCase().split('.').last;
    return validExtensions.contains(fileExtension);
  }
}
