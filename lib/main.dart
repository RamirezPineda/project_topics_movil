import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:project_topics_movil/src/constants/routes.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';
import 'package:project_topics_movil/src/services/index.dart';
import 'package:project_topics_movil/src/providers/index.dart';
import 'package:project_topics_movil/src/db/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo.db');

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE IF NOT EXISTS complaint (_id TEXT PRIMARY KEY, state TEXT, observation TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS notification (_id TEXT PRIMARY KEY, title TEXT TEXT, description TEXT)');

    print('tablas creadas');
  });

  print('Databaseee: $database');
  await database.close();

  final prefs = UserPreferences();
  await prefs.initPrefs();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final messaging = FirebaseMessaging.instance;
  // print("Token Movil: ${await messaging.getToken()}");

  runApp(
    ChangeNotifierProvider(
      create: (_) => NotificationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  _init() async {
    final pushProvider = PushNotificationProvider();
    await pushProvider.initNotifications();

    pushProvider.messages.listen((argument) async {
      if (argument.isNotEmpty) {
        try {
          final Map<String, dynamic> complaintMap =
              json.decode(argument['complaint']);
          final Map<String, dynamic> notificationMap =
              json.decode(argument['notification']);

          var dataBaseLocal = DBSQLiteLocal();
          await dataBaseLocal.openDataBaseLocal();

          await dataBaseLocal.insert('complaint', complaintMap);
          await dataBaseLocal.insert('notification', notificationMap);

          await dataBaseLocal.closeDataBase();
        } catch (e) {
          // print(e);
        }

        final prefs = UserPreferences();
        prefs.selectedPage = 1;

        pushProvider.deleteData();
        navigatorKey.currentState?.pushNamed('home');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TypeComplaintService()),
        ChangeNotifierProvider(create: (context) => ComplaintService()),
        ChangeNotifierProvider(create: (context) => NotificationService()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Topics Project',
        debugShowCheckedModeBanner: false,
        routes: Routes.getRoutes(),
        initialRoute: Routes.login,
        theme: ThemeData.light(useMaterial3: true).copyWith(
          textTheme: GoogleFonts.montserratTextTheme(),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            // color: Color(0xffFFFBFE),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            foregroundColor: Colors.black,
          ),
          // scaffoldBackgroundColor: const Color(0xffFFFBFE),
        ),
      ),
    );
  }
}
