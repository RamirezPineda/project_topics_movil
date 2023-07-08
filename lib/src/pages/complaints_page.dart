import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    // final categoryService = Provider.of<CategoryService>(context);
    // final categoryList = categoryService.categoryList;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Header
          const SizedBox(height: 30),
          Text(
            'Bienvenido a la app!',
            style: TextStyle(fontSize: 20, color: Colors.grey[700]),
          ),
          Text(prefs.name, style: GoogleFonts.bebasNeue(fontSize: 50)),

          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Divider(color: Colors.grey, thickness: 1),
          ),
          Text(
            'Seleccione la denuncia',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 20),

          // ComplaintItem(),

          Container(
            width: 350,
            height: 170,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                SizedBox(
                  width: 350,
                  height: 170,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/fondos/fondo5.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Falta de iluminacion en la avenida principal, provoca inseguridad y peligros inminentes.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Badge(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    label: Text(
                                      'pendiente',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final currentDate = DateTime.now();
                              final nuevo =
                                  currentDate.add(const Duration(seconds: 1));
                              if (currentDate.compareTo(nuevo) == 1) {
                                print('la fecha 1 es mayor');
                              }
                              print(currentDate.compareTo(nuevo));
                              print(nuevo.toIso8601String());
                              print(DateTime.parse(
                                  DateTime.now().toIso8601String()));
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  title: Text('Debe cambiar su contrasena!'),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        '20/06/2023',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Categories
          // Expanded(
          //   child: GridView.builder(
          //     itemCount: categoryList.length,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       childAspectRatio: 1 / 1.2,
          //     ),
          //     itemBuilder: (context, index) {
          //       return GestureDetector(
          //         child: _categoryCard(categoryList, index),
          //         onTap: () {
          //           //Todo ir a vista de registro de denuncia
          //           // Navigator.pushNamed(context, Routes.COMPLAINTCARD);
          //           print('denuncia seleccionada');
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
