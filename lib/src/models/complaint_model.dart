import 'dart:convert';

class Complaint {
  String? id;
  String title;
  String description;
  List<String> photos;
  String state;
  String? observation;
  String typeComplaintId;
  DateTime? createdAt;

  Complaint({
    this.id,
    required this.title,
    required this.description,
    required this.photos,
    required this.state,
    required this.typeComplaintId,
    this.createdAt,
    this.observation,
  });

  factory Complaint.fromJson(String str) => Complaint.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Complaint.fromMap(Map<String, dynamic> json) => Complaint(
      id: json["_id"],
      title: json["title"],
      description: json["description"],
      photos: List<String>.from(json["photos"].map((photo) => photo)),
      state: json['state'],
      typeComplaintId: json['typeComplaintId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : null,
      observation: json['observation']);

  Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "description": description,
        "photos": List<dynamic>.from(photos.map((photo) => photo)),
        "state": state,
        "typeComplaintId": typeComplaintId,
        "createdAt": createdAt?.toIso8601String(),
        "observation": observation,
      };

  Complaint copy() => Complaint(
        id: id,
        title: title,
        description: description,
        photos: List.from(photos),
        state: state,
        typeComplaintId: typeComplaintId,
        createdAt: createdAt,
        observation: observation,
      );
}
