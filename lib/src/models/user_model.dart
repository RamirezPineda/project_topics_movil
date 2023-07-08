import 'dart:convert';

class User {
  String email;
  String password;

  User({
    required this.email,
    required this.password,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "email": email,
        "password": password,
      };
}
