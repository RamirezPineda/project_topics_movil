import 'package:flutter/material.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:project_topics_movil/src/db/index.dart';

import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';
import 'package:project_topics_movil/src/models/index.dart';
import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:path_provider/path_provider.dart';

class ComplaintService extends ChangeNotifier {
  List<Complaint> complaitsList = [];
  bool isLoading = false;
  List<DropdownMenuItem<String>> dropdownList = [];

  ComplaintService() {
    getAllComplaint();
  }

  Future<void> getAllComplaint() async {
    isLoading = true;
    notifyListeners();
    final prefs = UserPreferences();
    print('get All Complaint');
    try {
      final response =
          await DioConfig.dio.get('/api/complaints/person/${prefs.personId}');

      List<dynamic> allComplaints = response.data;

      complaitsList = [];
      for (var element in allComplaints) {
        final Complaint complaint = Complaint.fromMap(element);
        complaitsList.add(complaint);
      }

      loadDropdownList(complaitsList);
    } catch (e) {
      // print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> registerOrUpdate(Complaint complaint) async {
    if (complaint.id == null) {
      return await _registerComplaint(complaint);
    } else {
      return await updateComplaint(complaint);
    }
  }

  Future<Map<String, dynamic>> _registerComplaint(Complaint complaint) async {
    final prefs = UserPreferences();

    try {
      Position position = await Geolocator.getCurrentPosition(); // GPS
      await imageCompress(complaint.photos); // comprime las imagenes

      var formData = FormData.fromMap({
        'title': complaint.title,
        'description': complaint.description,
        'photo1': await MultipartFile.fromFile(complaint.photos[0]),
        'latitude': position.latitude,
        'longitude': position.longitude,
        'personId': prefs.personId,
        'typeComplaintId': complaint.typeComplaintId,
      });

      if (complaint.photos.length == 2) {
        formData.files.add(MapEntry(
            'photo2', await MultipartFile.fromFile(complaint.photos[1])));
      }

      final response =
          await DioConfig.dio.post('/api/complaints', data: formData);

      final newComplaint = Complaint.fromMap(response.data);
      complaitsList = complaitsList.reversed.toList();
      complaitsList.add(newComplaint);
      complaitsList = complaitsList.reversed.toList();

      notifyListeners();
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      return {'message': "Ocurrio un error en el server"};
    } catch (e) {
      return {'message': "Ocurrio un error intentelo mas tarde"};
    }
  }

  Future<Map<String, dynamic>> updateComplaint(Complaint complaint) async {
    final prefs = UserPreferences();
    try {
      var formData = FormData.fromMap({
        'title': complaint.title,
        'description': complaint.description,
        'photos': complaint.photos,
        'personId': prefs.personId,
        'typeComplaintId': complaint.typeComplaintId,
      });

      final response = await DioConfig.dio
          .put('/api/complaints/${complaint.id}', data: formData);

      final updatedComplaint = Complaint.fromMap(response.data);

      int index =
          complaitsList.indexWhere((element) => element.id == complaint.id);
      complaitsList[index] = updatedComplaint;

      notifyListeners();
      return response.data;
    } on DioException {
      // if (e.response != null) return e.response?.data;

      return {'message': "Ocurrio un error en el server"};
    } catch (e) {
      return {'message': "Ocurrio un error intentelo mas tarde"};
    }
  }

  Future<Map<String, dynamic>> deleteComplaint(String id) async {
    try {
      final response = await DioConfig.dio.delete('/api/complaints/$id');

      final complaint = Complaint.fromMap(response.data);
      int index = complaitsList.indexWhere((element) => element.id == id);
      complaitsList[index] = complaint;

      notifyListeners();
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) return e.response?.data;

      return {'message': "Ocurrio un error en el server"};
    } catch (e) {
      return {'message': "Ocurrio un error intentelo mas tarde"};
    }
  }

  Future<void> imageCompress(List<String> photos) async {
    int idealFileSizeinKB = 65;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    for (var i = 0; i < photos.length; i++) {
      if (!photos[i].startsWith('http')) {
        File photoFile = File(photos[i]);
        int fileSizeInBytes = await photoFile.length();
        double fileSizeInKB = fileSizeInBytes / 1024;

        String imageName = photoFile.path.split('/').last;
        String compressedImagePath = '$tempPath/$i$imageName';
        int quality = 93;

        //Comprime la imagen hasta que sea menor a 65KB
        while (fileSizeInKB > idealFileSizeinKB) {
          var result = await FlutterImageCompress.compressAndGetFile(
            photoFile.absolute.path,
            compressedImagePath,
            minWidth: 1024,
            minHeight: 800,
            quality: quality,
          );

          int imageLength = await result!.length();
          fileSizeInKB = imageLength / 1024;
          quality -= 10;
          photos[i] = result.path;
        }
      }
    }
  }

  void loadDropdownList(List<Complaint> complaints) {
    // for (var i = 0; i < complaints.length; i++) {
    //   final existValue = dropdownList
    //       .indexWhere((element) => element.value == complaints[i].state);
    //   if (existValue == -1) {
    //     dropdownList.add(
    //       DropdownMenuItem(
    //         value: complaitsList[i].state,
    //         child: Text(complaints[i].state),
    //       ),
    //     );
    //   }
    // }
    dropdownList.add(const DropdownMenuItem(
      value: "",
      enabled: false,
      child: Text('Estados'),
    ));
    dropdownList.add(
        const DropdownMenuItem(value: "pendiente", child: Text('pendiente')));
    dropdownList.add(
        const DropdownMenuItem(value: "aceptado", child: Text('aceptado')));
    dropdownList.add(
        const DropdownMenuItem(value: "rechazado", child: Text('rechazado')));
    dropdownList.add(
        const DropdownMenuItem(value: "cancelado", child: Text('cancelado')));
  }

  Future<void> updateData() async {
    try {
      var dataBaseLocal = DBSQLiteLocal();
      await dataBaseLocal.openDataBaseLocal();

      final allComplaintDBLocal = await dataBaseLocal.getAllItems('complaint');

      if (allComplaintDBLocal.isNotEmpty) {
        final complaintData = allComplaintDBLocal.first;
        final id = complaintData['_id'];

        int index = complaitsList.indexWhere((element) => element.id == id);
        final complaintFound = complaitsList[index];

        complaitsList.removeAt(index);

        complaintFound.state = complaintData['state'];
        complaintFound.observation = complaintData['observation'];

        complaitsList.insert(0, complaintFound);

        await dataBaseLocal.clearTable('complaint');
      }

      await dataBaseLocal.closeDataBase();
    } catch (e) {
      // print(e);
    } finally {
      notifyListeners();
    }
  }
}
