import 'package:flutter/material.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

export "verify_password_utils.dart";

bool isExpired() {
  final prefs = UserPreferences();
  final lastPasswordChange = DateTime.parse(prefs.lastPasswordChange);

  final expirationDate = lastPasswordChange.add(const Duration(days: 30));
  final currentDate = DateTime.now();

  if (currentDate.isAfter(expirationDate)) {
    return true; // expiro la contrasena
  }

  return false;
}

Future<dynamic> showPasswordExpiredMessage(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const AlertDialog(
      title: Text('Alerta!'),
      content: Text('Su contrasena es muy antigua, debe cambiarlo.'),
    ),
  );
}
