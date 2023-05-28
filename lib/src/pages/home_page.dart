import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:project_topics_movil/src/constants/routes.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

import 'package:project_topics_movil/src/pages/index.dart';
import 'package:project_topics_movil/src/services/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final prefs = UserPreferences();
  int _selectedIndex = 0;

  final List<Widget> tabBarViews = [
    //Home
    ChangeNotifierProvider(
      create: (BuildContext context) => CategoryService(),
      child: ComplaintsPage(),
    ),

    // History
    ChangeNotifierProvider(
      create: (BuildContext context) => ComplaintService(),
      child: HistoryPage(),
    ),

    //My profile
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(CupertinoIcons.square_grid_2x2, size: 40),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xffFFFBFE),
        child: Column(
          children: [
            DrawerHeader(child: Image.asset("assets/light-bulb.png")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(color: Colors.grey[800]),
            ),

            // Pages
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                onTap: () {
                  Navigator.popAndPushNamed(context, Routes.PERFIL);
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
                  Navigator.pushReplacementNamed(context, "login");
                },
                leading: const Icon(Icons.logout),
                title: const Text("Cerrar sesión"),
              ),
            ),
          ],
        ),
      ),
      body: tabBarViews[_selectedIndex],

      //Button Navigator Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: GNav(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() => _selectedIndex = index);
          },
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 8,
          backgroundColor: Colors.transparent,
          activeColor: Colors.black,
          color: Colors.grey[600],
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          tabBackgroundColor: Colors.grey.shade200,
          tabs: const [
            GButton(icon: CupertinoIcons.home, text: 'Home'),
            GButton(icon: CupertinoIcons.doc_on_doc, text: 'Mi historial'),
            GButton(icon: CupertinoIcons.person, text: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
