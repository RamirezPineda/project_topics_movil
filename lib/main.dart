import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:project_topics_movil/src/constants/routes.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';
import 'package:project_topics_movil/src/services/index.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('=========== ON BACKGROUND============');

  print("Handling a background message: ${message.messageId}");
  print(message.data);
  print(message.notification?.title);
  print(message.notification?.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = UserPreferences();
  await prefs.initPrefs();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  // print(await messaging.getToken());
  //eIvMCsYVTXStli4KyW_RYz:APA91bE-qeKMs0wU5iS_mOgy0B9_miTsY2GCg9VBoyTS_qBQsKqrtftP6RygYu-wBaYxWDHtIyX1i1kHWq_S5cAP1EP5hpwk_vxcOzanHifX9aAU0dYSvtycqbousGNWdINu2is_7KOt

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //si la app esta abierta trabajar con (local-notification)
    print('=========== ON MESSAGE============');
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      print(message.notification?.title);
      print(message.notification?.body);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TypeComplaintService()),
        ChangeNotifierProvider(create: (context) => ComplaintService()),
      ],
      child: MaterialApp(
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
