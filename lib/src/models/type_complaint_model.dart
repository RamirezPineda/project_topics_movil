import 'dart:convert';

class TypeComplaint {
  String id;
  String name;

  TypeComplaint({
    required this.id,
    required this.name,
  });

  factory TypeComplaint.fromJson(String str) =>
      TypeComplaint.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TypeComplaint.fromMap(Map<String, dynamic> json) => TypeComplaint(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
      };
}
