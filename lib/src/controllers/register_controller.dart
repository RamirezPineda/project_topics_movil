import 'package:flutter/material.dart';
// import 'dart:io';

import 'package:project_topics_movil/src/models/index.dart';

class RegisterFormController extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  User user;
  Person person;

  bool _isLoading = false;

  RegisterFormController(this.user, this.person);

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // void uploadPhoto(String path) {
  //   File? newPictureFile = File.fromUri(Uri(path: path));
  //   person.photo = path;
  //   notifyListeners();
  // }
}
