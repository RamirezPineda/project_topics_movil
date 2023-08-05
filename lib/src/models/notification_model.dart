import 'dart:convert';

class NotificationModel {
  String id;
  String title;
  String description;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
  });

  String toJson() => json.encode(toMap());
  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
          id: json['_id'],
          title: json['title'],
          description: json['description']);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
      };
}
