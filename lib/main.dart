import 'package:flutter/material.dart';

import 'package:project_topics_movil/src/constants/routes.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = UserPreferences();
  await prefs.initPrefs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Topics Project',
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoutes(),
      initialRoute: Routes.HOME,
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xffFFFBFE),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
          foregroundColor: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xffFFFBFE),
      ),
    );
  }
}
