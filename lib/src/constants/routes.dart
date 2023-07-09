import 'package:flutter/material.dart';

import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

import 'package:project_topics_movil/src/pages/index.dart';

class Routes {
  static const String home = 'home';
  static const String login = 'login';
  static const String register = 'register';
  static const String perfil = 'perfil';
  static const String history = 'history';
  static const String notification = 'notification';

  static const String complaintCard = 'complaint/card';
  static const String complaintShow = 'complaint/show';

  static Map<String, WidgetBuilder> getRoutes() {
    final prefs = UserPreferences();

    return <String, WidgetBuilder>{
      // LOGIN: (BuildContext context) =>
      //     prefs.clientId == 0 || prefs.token == '' ? LoginPage() : HomePage(),
      login: (BuildContext context) =>
          prefs.token != "" ? const HomePage() : const LoginPage(),
      register: (BuildContext context) => const RegisterPage(),
      home: (BuildContext context) => const HomePage(),
      perfil: (BuildContext context) => const PerfilPage(),
      history: (BuildContext context) => const HistoryPage(),
      notification: (BuildContext context) => const NotificationPage(),
      // COMPLAINTCARD: (BuildContext context) => ComplaintCard(),
      // COMPLAINTSHOW: (BuildContext context) => ComplaintShow(),
    };
  }
}
