import 'dart:convert';

class Person {
  String name;
  String ci;
  String address;
  String phone;
  String photo;

  Person({
    required this.name,
    required this.ci,
    required this.address,
    required this.phone,
    required this.photo,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "name": name,
        "ci": ci,
        "address": address,
        "phone": phone,
        "photo": photo,
      };
}
