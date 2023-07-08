import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:project_topics_movil/src/constants/routes.dart';
import 'package:project_topics_movil/src/widgets/index.dart';

import 'package:project_topics_movil/src/controllers/index.dart';
import 'package:project_topics_movil/src/models/index.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              // Login form
              ChangeNotifierProvider(
                create: (BuildContext context) => RegisterFormController(
                    User(email: "", password: ""),
                    Person(
                        ci: "", name: "", address: "", phone: "", photo: "")),
                child: RegisterForm(),
              ),

              const SizedBox(height: 50),

              // Login page
              _loginButton(context),
            ],
          ),
        ),
      )),
    );
  }

  Padding _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(thickness: 0.5, color: Colors.grey[400]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const SizedBox(width: 5),
                Text('Tienes una cuenta?',
                    style: TextStyle(color: Colors.grey[700])),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.login);
                  },
                  child: Text(
                    'Inciar sesión',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Divider(thickness: 0.5, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
