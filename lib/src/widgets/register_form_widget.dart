import 'dart:io';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:project_topics_movil/src/constants/routes.dart';
import 'package:project_topics_movil/src/ui/index.dart';

import 'package:project_topics_movil/src/controllers/index.dart';
import 'package:project_topics_movil/src/services/index.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});

  final registerService = RegisterService();

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormController>(context);

    return Form(
      key: registerForm.formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // photo field
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(color: Colors.black),
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: registerForm.person.photo == ''
                      ? Container(
                          height: 150,
                          width: 150,
                          color: Colors.white,
                          child: const Icon(Icons.photo_camera,
                              size: 100, color: Colors.grey),
                        )
                      : registerForm.person.photo.startsWith('http')
                          ? Image.network(
                              registerForm.person.photo,
                              fit: BoxFit.cover,
                              height: 150,
                              width: 150,
                            )
                          : Image.file(
                              File(registerForm.person.photo),
                              fit: BoxFit.cover,
                              height: 150,
                              width: 150,
                            ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black)],
                ),
                child: IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 100,
                    );

                    if (image == null) {
                      return;
                    }
                    // registerForm.uploadPhoto(image.path);
                    registerForm.person.photo = image.path;
                    registerForm.isLoading = false;
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.blue[500],
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Foto de su rostro, sin gafas, gorras, etc.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),

          // ci field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              enabled: registerForm.person.name == '',
              keyboardType: TextInputType.text,
              decoration: inputDecoration(
                hintText: 'Ci',
                labelText: 'Ci',
              ),
              onChanged: (value) => registerForm.person.ci = value,
              validator: (value) {
                return value != null && value.length >= 8
                    ? null
                    : "Ci no valido";
              },
            ),
          ),

          const SizedBox(height: 15),

          // password field
          Container(
            child: registerForm.person.name != ''
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          enabled: false,
                          keyboardType: TextInputType.text,
                          decoration: inputDecoration(
                            hintText: 'Nombre',
                            labelText: 'Nombre',
                          ),
                          initialValue: registerForm.person.name,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: inputDecoration(
                            hintText: 'Dirección',
                            labelText: 'Dirección',
                          ),
                          onChanged: (value) =>
                              registerForm.person.address = value,
                          validator: (value) {
                            return value != null && value.length > 3
                                ? null
                                : "Dirección no valida";
                          },
                          initialValue: registerForm.person.address,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: inputDecoration(
                            hintText: 'Telefono',
                            labelText: 'Telefono',
                          ),
                          onChanged: (value) =>
                              registerForm.person.phone = value,
                          validator: (value) {
                            return value != null && value.length == 8
                                ? null
                                : "Telefono no valido";
                          },
                          initialValue: registerForm.person.phone,
                        ),
                      ),
                      const SizedBox(height: 15),
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
                          onChanged: (value) => registerForm.user.email = value,
                          validator: (value) {
                            String pattern =
                                r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = RegExp(pattern);
                            return regExp.hasMatch(value ?? '')
                                ? null
                                : 'Email no valido';
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
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
                          onChanged: (value) =>
                              registerForm.user.password = value,
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
                      const SizedBox(height: 15),
                    ],
                  )
                : const Center(),
          ),

          Container(
            child: registerService.generateCode != 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration(
                        hintText: 'Código de verificación de email',
                        labelText: 'Código de verificación de email',
                      ),
                      onChanged: (value) =>
                          registerService.verificationCode = int.parse(value),
                      validator: (value) => value != null &&
                              registerService.verificationCode ==
                                  registerService.generateCode
                          ? null
                          : "El código introducido no es valido",
                    ),
                  )
                : const Center(),
          ),

          const SizedBox(height: 20),

          // Register Button
          MaterialButton(
            elevation: 0,
            color: Colors.blue[600],
            disabledColor: Colors.blue[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: registerForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!registerForm.isValidForm()) return;
                    if (registerForm.person.photo == '') {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text("Debe enviar una foto de perfil"),
                        ),
                      );
                      return;
                    }

                    registerForm.isLoading = true;
                    if (registerForm.person.name == '') {
                      var response = await registerService
                          .verifyDataUser(registerForm.person);
                      if (response.containsKey('message')) {
                        // ignore: use_build_context_synchronously
                        _showDialogError(context, response['message']);
                      }
                    } else {
                      var response = await registerService.registerNewUser(
                          registerForm.user, registerForm.person);
                      if (response.containsKey('message')) {
                        // ignore: use_build_context_synchronously
                        _showDialogError(context, response['message']);
                      } else {
                        // ignore: use_build_context_synchronously
                        _showDialogError(context, 'Usuario registrado');
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, Routes.login);
                      }
                    }
                    registerForm.isLoading = false;

                    // if (!context.mounted) return;
                    // _showDialogError(context);
                  },
            child: Container(
              padding: registerForm.isLoading
                  ? const EdgeInsets.symmetric(horizontal: 144, vertical: 14.5)
                  : const EdgeInsets.symmetric(horizontal: 115, vertical: 15),
              child: registerForm.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      'Registrarse',
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

  Future<dynamic> _showDialogError(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text('Error', style: TextStyle(color: Colors.red)),
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(width: 5),
              Expanded(child: Text(message)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
