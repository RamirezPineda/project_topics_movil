import 'package:flutter/material.dart';

import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

import 'package:project_topics_movil/src/pages/index.dart';

class Routes {
  static const String HOME = 'home';
  static const String LOGIN = 'login';
  static const String REGISTER = 'register';
  static const String PERFIL = 'perfil';
  static const String HISTORY = 'history';
  static const String COMPLAINTCARD = 'complaint/card';
  static const String COMPLAINTSHOW = 'complaint/show';

  static Map<String, WidgetBuilder> getRoutes() {
    final prefs = UserPreferences();

    return <String, WidgetBuilder>{
      // LOGIN: (BuildContext context) =>
      //     prefs.clientId == 0 || prefs.token == '' ? LoginPage() : HomePage(),
      LOGIN: (BuildContext context) => const LoginPage(),
      REGISTER: (BuildContext context) => const RegisterPage(),
      HOME: (BuildContext context) => const HomePage(),
      PERFIL: (BuildContext context) => const PerfilPage(),
      HISTORY: (BuildContext context) => const HistoryPage(),
      // COMPLAINTCARD: (BuildContext context) => ComplaintCard(),
      // COMPLAINTSHOW: (BuildContext context) => ComplaintShow(),
    };
  }
}
