import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:project_topics_movil/src/constants/routes.dart';
import 'package:project_topics_movil/src/ui/index.dart';

import 'package:project_topics_movil/src/controllers/index.dart';
import 'package:project_topics_movil/src/services/index.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormController>(context);

    return Form(
      key: loginForm.formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // username field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.emailAddress,
              decoration: inputDecoration(
                hintText: 'Email',
                labelText: 'Email',
              ),
              onChanged: (value) => loginForm.user.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'Email no valido';
              },
            ),
          ),

          const SizedBox(height: 15),

          // password field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: inputDecoration(
                hintText: '********',
                labelText: 'Password',
              ),
              onChanged: (value) => loginForm.user.password = value,
              validator: (value) {
                String pattern =
                    r"^(?=.*\d)(?=.*[\u0021-\u002b\u003c-\u0040])(?=.*[A-Z])(?=.*[a-z])\S{8,16}$";
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : "Minimo 8 caracteres, una letra minuscula, una \n mayuscula, un digito y un caracter alfanumerico";
              },
            ),
          ),
          const SizedBox(height: 10),

          //Forgot Password ?
          _forgotPassword(),
          const SizedBox(height: 25),

          // Sign In Button
          MaterialButton(
            elevation: 0,
            disabledColor: Colors.blue[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.blue[600],
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!loginForm.isValidForm()) return;

                    loginForm.isLoading = true;
                    final auth =
                        await loginService.authenticate(loginForm.user);
                    loginForm.isLoading = false;

                    if (auth.containsKey('message')) {
                      // ignore: use_build_context_synchronously
                      _showDialogError(context);
                      return;
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, Routes.home);

                    // if (!context.mounted) return;
                    // _showDialogError(context);
                  },
            child: Container(
              padding: loginForm.isLoading
                  ? const EdgeInsets.symmetric(horizontal: 144, vertical: 14.5)
                  : const EdgeInsets.symmetric(horizontal: 115, vertical: 15),
              child: loginForm.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _showDialogError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: const Text('Error', style: TextStyle(color: Colors.red)),
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 5),
                Text('Email o passwod incorrectos')
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          );
        });
  }

  Widget _forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
