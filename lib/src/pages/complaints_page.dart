import 'package:flutter/material.dart';
import 'package:project_topics_movil/src/constants/routes.dart';

import 'package:project_topics_movil/src/models/category_model.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_topics_movil/src/services/index.dart';
import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';

class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    final categoryService = Provider.of<CategoryService>(context);
    final categoryList = categoryService.categoryList;

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

          // Categories
          Expanded(
            child: GridView.builder(
              itemCount: categoryList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.2,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: _categoryCard(categoryList, index),
                  onTap: () {
                    //Todo ir a vista de registro de denuncia
                    // Navigator.pushNamed(context, Routes.COMPLAINTCARD);
                    print('denuncia seleccionada');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(List<Category> categoryList, int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 75,
              child: FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(categoryList[index].image),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  categoryList[index].name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
