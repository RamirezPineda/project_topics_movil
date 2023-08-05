import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool _thereIsNotification = false;

  bool get thereIsNotification => _thereIsNotification;

  set thereIsNotification(bool value) {
    _thereIsNotification = value;
    notifyListeners();
  }
}
