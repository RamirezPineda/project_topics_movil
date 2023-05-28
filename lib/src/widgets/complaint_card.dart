import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_topics_movil/src/services/complaint_service.dart';
import 'package:project_topics_movil/src/models/index.dart';
import 'package:project_topics_movil/src/controllers/index.dart';
import 'package:project_topics_movil/src/ui/index.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({super.key, required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    // final Complaint complaint =
    //     Complaint(title: '', description: '', photos: []);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header
              const SizedBox(height: 30),
              Text(
                'Denuncia de:',
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
              Text('Alcantarillado',
                  style: GoogleFonts.bebasNeue(fontSize: 50)),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Divider(color: Colors.grey, thickness: 1),
              ),
              Text(
                'Rellene los datos del formulario',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 20),

              // Form
              ChangeNotifierProvider(
                create: (BuildContext context) =>
                    ComplaintFormController(complaint),
                child: _ComplaintForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComplaintForm extends StatelessWidget {
  const _ComplaintForm({super.key});

  @override
  Widget build(BuildContext context) {
    final ComplaintService complaintService = ComplaintService();
    final ComplaintFormController complaintForm =
        Provider.of<ComplaintFormController>(context);
    return Form(
      key: complaintForm.formKey,
      child: Column(
        children: [
          // username field
          TextFormField(
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            keyboardType: TextInputType.text,
            decoration: LoginInputDecoration.inputDecoration(
              hintText: 'Título',
              labelText: 'Título',
            ),
            onChanged: (value) => complaintForm.complaint.title = value,
            validator: (value) => value != null && value.trim().length > 8
                ? null
                : "Título demasiado corto",
          ),

          const SizedBox(height: 20),

          TextFormField(
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 7,
            decoration: LoginInputDecoration.inputDecoration(
              hintText: 'Descripción',
              labelText: 'Descripción',
            ),
            onChanged: (value) => complaintForm.complaint.description = value,
            validator: (value) {
              return value != null &&
                      value.trim().length >= 64 &&
                      value.trim().length <= 512
                  ? null
                  : 'Debe tener minimo 64 caracteres y maximo 512 \ncaracteres';
            },
          ),
          const SizedBox(height: 10),

          // Fotos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //PHOTO 1
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 180,
                  width: 150,
                  decoration: _cardBorder(),
                  child: complaintForm.complaint.photos.isNotEmpty
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: complaintForm.complaint.photos[0]
                                      .startsWith('http')
                                  ? Image.network(
                                      complaintForm.complaint.photos[0],
                                      fit: BoxFit.cover,
                                      height: 180,
                                      width: 150,
                                    )
                                  : Image.file(
                                      File(complaintForm.complaint.photos[0]),
                                      fit: BoxFit.cover,
                                      height: 180,
                                      width: 150,
                                    ),
                            ),
                            IconButton(
                              onPressed: () {
                                complaintForm.complaint.photos.removeAt(0);
                                complaintForm.isLoading = false;
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red.shade200,
                                size: 35,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 100,
                                );

                                if (image == null) {
                                  print('No saco ninguna foto 1');
                                  return;
                                }
                                complaintForm.complaint.photos.add(image.path);
                                complaintForm.isLoading = false;
                              },
                              icon: const Icon(
                                Icons.camera_alt_rounded,
                                size: 45,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 100,
                                );

                                if (image == null) {
                                  print('No saco ninguna foto 1');
                                  return;
                                }
                                complaintForm.complaint.photos.add(image.path);
                                complaintForm.isLoading = false;
                              },
                              icon: Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 45,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              //PHOTO 2
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 180,
                  width: 150,
                  decoration: _cardBorder(),
                  child: complaintForm.complaint.photos.length > 1
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: complaintForm.complaint.photos[1]
                                      .startsWith('http')
                                  ? Image.network(
                                      complaintForm.complaint.photos[1],
                                      fit: BoxFit.cover,
                                      height: 180,
                                      width: 150,
                                    )
                                  : Image.file(
                                      File(complaintForm.complaint.photos[1]),
                                      fit: BoxFit.cover,
                                      height: 180,
                                      width: 150,
                                    ),
                            ),
                            IconButton(
                              onPressed: () {
                                complaintForm.complaint.photos.removeAt(1);
                                complaintForm.isLoading = false;
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red.shade200,
                                size: 35,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            IconButton(
                              onPressed: () {
                                print('camera pressed2');
                              },
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                size: 45,
                                color: Colors.grey[500],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 100,
                                );

                                if (image == null) {
                                  print('No saco ninguna foto 2');
                                  return;
                                }
                                complaintForm.complaint.photos.add(image.path);
                                complaintForm.isLoading = false;
                              },
                              icon: const Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 45,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          MaterialButton(
            elevation: 0,
            disabledColor: Colors.blue[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.blue[600],
            onPressed: complaintForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!complaintForm.isValidForm()) return;

                    complaintForm.isLoading = true;
                    await complaintService
                        .registerOrUpdate(complaintForm.complaint);
                    complaintForm.isLoading = false;
                  },
            child: Container(
              padding: complaintForm.isLoading
                  ? const EdgeInsets.symmetric(horizontal: 144, vertical: 14.5)
                  : const EdgeInsets.symmetric(horizontal: 115, vertical: 15),
              child: complaintForm.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 15,
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

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  BoxDecoration _cardBorder() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0),
      border: Border.all(width: 0.8, color: Colors.grey.shade400),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 0.5),
          blurRadius: 1,
        ),
      ],
    );
  }
}
