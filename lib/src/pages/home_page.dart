import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:project_topics_movil/src/constants/routes.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';
import 'package:project_topics_movil/src/pages/index.dart';
import 'package:project_topics_movil/src/db/index.dart';

class HomePage extends StatefulWidget {
  final int? selectedPage;

  const HomePage({super.key, this.selectedPage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final prefs = UserPreferences();

  _checkIfThereIsNotification() async {
    bool renderAgain = false;
    try {
      var dataBaseLocal = DBSQLiteLocal();
      await dataBaseLocal.openDataBaseLocal();
      bool isEmptyTable = await dataBaseLocal.isTheTableEmpty('complaint');

      if (!isEmptyTable) {
        if (prefs.selectedPage != 1) {
          prefs.selectedPage = 1;
          print('la lista no esta vacia de complint - Home');
          setState(() {});
        } else {
          renderAgain = true;
        }
      } else {
        print('la lista esta vacia de complaints - Home');
      }

      await dataBaseLocal.closeDataBase();
    } catch (e) {
      // print(e);
    } finally {
      if (renderAgain) {
        print('IsThereNotification - IR A VISTA HOME DE NUEVO');
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkIfThereIsNotification();
      print('se ejecuto didChangeAppLifecycleState desde HOME');
    }
  }

  final List<Widget> tabBarViews = [
    //Home
    const ComplaintsPage(),

    //My History
    const HistoryPage(),

    //Notification
    const NotificationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              color: Colors.transparent,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Icon(Icons.dehaze, size: 25),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xffFFFBFE),
        child: Column(
          children: [
            DrawerHeader(child: Image.asset("assets/splash.png")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(color: Colors.grey[800]),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                onTap: () {
                  Navigator.popAndPushNamed(context, Routes.perfil);
                },
                leading: const Icon(Icons.person),
                title: const Text("Perfil"),
              ),
            ),

            // Logout
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                onTap: () {
                  // limpiar los datos del usuario
                  prefs.clearUser();
                  Navigator.pushReplacementNamed(context, Routes.login);
                },
                leading: const Icon(Icons.logout),
                title: const Text("Cerrar sesión"),
              ),
            ),
          ],
        ),
      ),
      body: tabBarViews[prefs.selectedPage],

      //Button Navigator Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GNav(
          selectedIndex: prefs.selectedPage,
          onTabChange: (index) {
            //todo: change a _selectIndex
            setState(() => prefs.selectedPage = index);
          },
          gap: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.transparent,
          activeColor: Colors.black,
          color: Colors.grey[600],
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          tabBackgroundColor: Colors.grey.shade200,
          tabs: const [
            GButton(icon: CupertinoIcons.home, text: 'Home'),
            GButton(icon: CupertinoIcons.doc_plaintext, text: 'Mi historial'),
            GButton(icon: CupertinoIcons.bell, text: 'Notificaciones'),
          ],
        ),
      ),
    );
  }
}
