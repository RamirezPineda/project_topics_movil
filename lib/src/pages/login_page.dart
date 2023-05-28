import 'package:flutter/material.dart';
import 'package:project_topics_movil/src/constants/routes.dart';

import 'package:provider/provider.dart';

import 'package:project_topics_movil/src/providers/index.dart';
import 'package:project_topics_movil/src/widgets/index.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                //Logo
                const SizedBox(height: 50),
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 50),

                //Text of Welcome
                // const Text(
                //   'Bienvenido a la aplicación!',
                //   style: TextStyle(color: Colors.black, fontSize: 16),
                // ),
                // const SizedBox(height: 10),

                // Login form
                ChangeNotifierProvider(
                  create: (BuildContext context) => LoginFormProvider(),
                  child: LoginForm(),
                ),

                const SizedBox(height: 50),

                // Create new account
                _newAccountButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _newAccountButton(BuildContext context) {
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
                Text('O create una', style: TextStyle(color: Colors.grey[700])),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.REGISTER);
                  },
                  child: Text(
                    'nueva cuenta',
                    style: TextStyle(color: Colors.blue.shade700),
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
