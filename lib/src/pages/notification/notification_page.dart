import 'package:flutter/material.dart';
import 'package:project_topics_movil/src/db/index.dart';
import 'package:project_topics_movil/src/models/notification_model.dart';

import 'package:provider/provider.dart';

import 'package:project_topics_movil/src/services/index.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool thereIsNotification = false;

  Future<void> _init() async {
    try {
      var dataBaseLocal = DBSQLiteLocal();
      await dataBaseLocal.openDataBaseLocal();

      bool isEmptyTable = await dataBaseLocal.isTheTableEmpty('notification');

      if (!isEmptyTable) {
        thereIsNotification = true;
        setState(() {});
      }

      dataBaseLocal.closeDataBase();
    } catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);

    if (notificationService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (thereIsNotification) {
      thereIsNotification = false;
      notificationService.updateData();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          //TITLE
          const Text(
            'Notificaciones',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 10),

          // LIST OF NOTIFICATIONS
          Expanded(
            child: ListView.builder(
              itemCount: notificationService.notificationsList.length,
              itemBuilder: (context, index) {
                // GET NOTIFICATION INDIVIDUAL
                NotificationModel notification =
                    notificationService.notificationsList[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      notification.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notification.description),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
