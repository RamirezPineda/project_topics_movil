import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  String _notificationData = '';

  String get notificationData => _notificationData;

  void setNotificationData(String data) {
    _notificationData = data;
    notifyListeners();
  }
}
