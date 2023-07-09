import 'package:flutter/material.dart';

import 'package:project_topics_movil/src/models/index.dart';

class LoginFormController extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  User user;
  bool _isLoading = false;

  LoginFormController(this.user);

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
