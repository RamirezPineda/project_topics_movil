import 'package:flutter/material.dart';

import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:project_topics_movil/src/db/index.dart';
import 'package:project_topics_movil/src/models/index.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

class NotificationService with ChangeNotifier {
  List<NotificationModel> notificationsList = [];
  bool _isLoading = false;

  NotificationService() {
    getAllNotifications();
  }

  bool get isLoading => _isLoading;

  Future<void> getAllNotifications() async {
    _isLoading = true;
    notifyListeners();
    print('get All Notifications');
    try {
      final prefs = UserPreferences();

      final response =
          await DioConfig.dio.get('/api/notifications/user/${prefs.id}');
      List<dynamic> allNotifications = response.data;

      notificationsList = [];
      for (var element in allNotifications) {
        final notification = NotificationModel.fromMap(element);
        notificationsList.add(notification);
      }
    } catch (e) {
      // print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateData() async {
    try {
      var dataBaseLocal = DBSQLiteLocal();
      await dataBaseLocal.openDataBaseLocal();

      final allNotificationDBLocal =
          await dataBaseLocal.getAllItems('notification');

      if (allNotificationDBLocal.isNotEmpty) {
        final notificationData = allNotificationDBLocal.first;
        final id = notificationData['_id'];
        final title = notificationData['title'];
        final description = notificationData['description'];

        NotificationModel newNotification =
            NotificationModel(id: id, title: title, description: description);

        notificationsList.insert(0, newNotification);

        await dataBaseLocal.clearTable('notification');
      }

      await dataBaseLocal.closeDataBase();
    } catch (e) {
      // print(e);
    } finally {
      notifyListeners();
    }
  }
}
