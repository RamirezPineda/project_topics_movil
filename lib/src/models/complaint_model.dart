import 'dart:convert';

class Complaint {
  String? id;
  String title;
  String description;
  List<String> photos;

  Complaint({
    this.id,
    required this.title,
    required this.description,
    required this.photos,
  });

  factory Complaint.fromJson(String str) => Complaint.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Complaint.fromMap(Map<String, dynamic> json) => Complaint(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        photos: List<String>.from(json["photos"].map((photo) => photo)),
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "description": description,
        "photos": List<dynamic>.from(photos.map((photo) => photo)),
      };

  Complaint copy() => Complaint(
      title: title,
      description: description,
      photos: List.from(photos),
      id: id);
}
