import 'package:flutter/material.dart';
import 'package:project_topics_movil/src/providers/register_form_provider.dart';

import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';
import 'package:project_topics_movil/src/ui/index.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              //User photo
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  prefs.photo,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    prefs.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const Text(" | "),
                  Text(
                    prefs.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              //Bio
              Text(
                "Ci: ${prefs.ci}",
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // edit profile
              ChangeNotifierProvider(
                create: (BuildContext context) => RegisterFormProvider(),
                child: _PerfilForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PerfilForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    final editProfileForm = Provider.of<RegisterFormProvider>(context);

    editProfileForm.address = prefs.address;
    editProfileForm.phone = prefs.phone;

    return Form(
      key: editProfileForm.formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              autocorrect: true,
              style: const TextStyle(fontWeight: FontWeight.w500),
              keyboardType: TextInputType.text,
              decoration: LoginInputDecoration.inputDecoration(
                hintText: 'Dirección',
                labelText: 'Dirección',
              ),
              initialValue: prefs.address,
              onChanged: (value) => editProfileForm.address = value,
              validator: (value) {
                return value != null && value.length > 3
                    ? null
                    : "Dirección no valida";
              },
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              style: const TextStyle(fontWeight: FontWeight.w500),
              keyboardType: TextInputType.phone,
              decoration: LoginInputDecoration.inputDecoration(
                hintText: 'Telefono',
                labelText: 'Telefono',
              ),
              initialValue: prefs.phone,
              onChanged: (value) => editProfileForm.phone = value,
              validator: (value) {
                return value != null && value.length == 8
                    ? null
                    : "Telefono no valido";
              },
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              style: const TextStyle(fontWeight: FontWeight.w500),
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: LoginInputDecoration.inputDecoration(
                hintText: '********',
                labelText: 'Nueva contraseña',
              ),
              onChanged: (value) => editProfileForm.password = value,
              validator: (value) {
                String pattern =
                    r"^(?=.*\d)(?=.*[\u0021-\u002b\u003c-\u0040])(?=.*[A-Z])(?=.*[a-z])\S{8,16}$";
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '') || value == ''
                    ? null
                    : "Minimo 8 caracteres, una letra minuscula, una \n mayuscula, un digito y un caracter alfanumerico";
              },
            ),
          ),
          const SizedBox(height: 30),

          //Save Button
          MaterialButton(
            elevation: 0,
            disabledColor: Colors.blue[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.blue[600],
            onPressed: editProfileForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!editProfileForm.isValidForm()) return;

                    editProfileForm.isLoading = true;
                    var response = await editProfileForm.updateProfile();
                    if (response.containsKey('message')) {
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error: ${response['message']}"),
                        ),
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('Datos actualizados!'),
                        ),
                      );
                    }

                    editProfileForm.isLoading = false;
                  },
            child: Container(
              padding: editProfileForm.isLoading
                  ? const EdgeInsets.symmetric(horizontal: 144, vertical: 14.5)
                  : const EdgeInsets.symmetric(horizontal: 125, vertical: 15),
              child: editProfileForm.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      'Guardar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
