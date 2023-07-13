import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:project_topics_movil/src/services/index.dart';
import 'package:project_topics_movil/src/models/index.dart';
import 'package:project_topics_movil/src/controllers/index.dart';
import 'package:project_topics_movil/src/ui/index.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({super.key, required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final TypeComplaintService typeComplaintService =
        Provider.of<TypeComplaintService>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header
              const SizedBox(height: 10),
              // Text(
              //   'Relleno los datos del:',
              //   style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              // ),
              const Text(
                'Formulario',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Divider(color: Colors.grey, thickness: 1),
              ),
              Text(
                'Rellene los datos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 20),

              // Form
              ChangeNotifierProvider(
                create: (context) => ComplaintFormController(complaint),
                child:
                    _ComplaintForm(typeComplaintService: typeComplaintService),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComplaintForm extends StatelessWidget {
  const _ComplaintForm({required this.typeComplaintService});

  final TypeComplaintService typeComplaintService;

  @override
  Widget build(BuildContext context) {
    final ComplaintService complaintService =
        Provider.of<ComplaintService>(context, listen: false);
    final ComplaintFormController complaintForm =
        Provider.of<ComplaintFormController>(context);

    if (typeComplaintService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (complaintForm.complaint.typeComplaintId == '') {
      complaintForm.complaint.typeComplaintId =
          typeComplaintService.dropdownList[0].value!;
    }

    return Form(
      key: complaintForm.formKey,
      child: Column(
        children: [
          // title field
          TextFormField(
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            keyboardType: TextInputType.text,
            decoration: inputDecoration(
              hintText: 'Título',
              labelText: 'Título',
            ),
            maxLength: 50,
            initialValue: complaintForm.complaint.title,
            onChanged: (value) => complaintForm.complaint.title = value,
            validator: (value) => value != null &&
                    value.trim().length > 7 &&
                    value.trim().length < 51
                ? null
                : "Minimo 8 caracteres, maximo 50",
          ),

          const SizedBox(height: 20),

          TextFormField(
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 7,
            decoration: inputDecoration(
              hintText: 'Descripción',
              labelText: 'Descripción',
            ),
            maxLength: 512,
            initialValue: complaintForm.complaint.description,
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

          // Category complaint Dropdown
          Visibility(
            visible: complaintForm.complaint.id == null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.5, color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButton(
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(10),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  value: complaintForm.complaint.typeComplaintId,
                  items: typeComplaintService.dropdownList,
                  onChanged: (value) {
                    complaintForm.complaint.typeComplaintId = value!;
                    complaintForm.isLoading = false;
                  },
                ),
              ),
            ),
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

                                if (image == null) return;

                                if (complaintForm
                                    .isImageExtensionValid(image.path)) {
                                  // ignore: use_build_context_synchronously
                                  imageExtensionInvalidMessage(context);
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

                                if (image == null) return;

                                if (complaintForm
                                    .isImageExtensionValid(image.path)) {
                                  // ignore: use_build_context_synchronously
                                  imageExtensionInvalidMessage(context);
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
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 100,
                                );

                                if (image == null) return;

                                if (complaintForm
                                    .isImageExtensionValid(image.path)) {
                                  // ignore: use_build_context_synchronously
                                  imageExtensionInvalidMessage(context);
                                  return;
                                }

                                complaintForm.complaint.photos.add(image.path);
                                complaintForm.isLoading = false;
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

                                if (image == null) return;

                                if (complaintForm
                                    .isImageExtensionValid(image.path)) {
                                  // ignore: use_build_context_synchronously
                                  imageExtensionInvalidMessage(context);
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
                    final navigator = Navigator.of(context);
                    if (!complaintForm.isValidForm()) return;

                    if (complaintForm.complaint.photos.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text("Debe enviar una foto"),
                        ),
                      );
                      return;
                    }

                    complaintForm.isLoading = true;
                    final response = await complaintService
                        .registerOrUpdate(complaintForm.complaint);
                    complaintForm.isLoading = false;
                    if (response.containsKey('message')) {
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(response['message']),
                        ),
                      );
                    } else {
                      navigator.pop();
                    }
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

  Future<dynamic> imageExtensionInvalidMessage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("Debe enviar una foto con extención jpg o jpeg"),
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
