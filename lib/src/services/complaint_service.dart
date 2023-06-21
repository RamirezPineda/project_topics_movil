import 'package:flutter/material.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'package:project_topics_movil/src/share_preferens/user_preferences.dart';
import 'package:project_topics_movil/src/constants/http_config.dart';
import 'package:project_topics_movil/src/models/index.dart';

class ComplaintService extends ChangeNotifier {
  final _dio = Dio();

  List<Complaint> complaitsList = [];
  late Complaint selectedComplaint;
  bool isLoading = false;
  List<DropdownMenuItem<String>> dropdownList = [];

  ComplaintService() {
    _configureDio();
    getAllComplaint();
  }

  void _configureDio() {
    _dio.options.baseUrl = HttpConfig.BASE_URL;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

  // void updateData() {
  //   notifyListeners();
  // }

  Future<void> getAllComplaint() async {
    isLoading = true;
    final prefs = UserPreferences();
    print('get complaints person');
    complaitsList = [];
    try {
      final response =
          await _dio.get('/api/complaints/person/${prefs.personId}');
      List<dynamic> allComplaints = response.data;

      for (var element in allComplaints) {
        final Complaint complaint = Complaint.fromMap(element);
        complaitsList.add(complaint);
      }

      loadDropdownList(complaitsList);
    } catch (e) {
      //Todo: hacer algo
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> registerOrUpdate(Complaint complaint) async {
    if (complaint.id == null) {
      // todo : register complaint
      return await _registerComplaint(complaint);
    } else {
      // todo: updated complaint
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
        'categoryId': complaint.categoryId,
      });

      if (complaint.photos.length == 2) {
        formData.files.add(MapEntry(
            'photo2', await MultipartFile.fromFile(complaint.photos[1])));
      }

      final response = await _dio.post('/api/complaints', data: formData);

      final newComplaint = Complaint.fromMap(response.data);
      complaitsList = complaitsList.reversed.toList();
      complaitsList.add(newComplaint);
      complaitsList = complaitsList.reversed.toList();

      notifyListeners();
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      return {'message': "Ocurrio un error en el server"};
    } catch (e) {
      print('ocurrio algo: $e');
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
        'categoryId': complaint.categoryId,
      });

      final response =
          await _dio.put('/api/complaints/${complaint.id}', data: formData);

      final updatedComplaint = Complaint.fromMap(response.data);

      int index =
          complaitsList.indexWhere((element) => element.id == complaint.id);
      complaitsList[index] = updatedComplaint;

      notifyListeners();
      return response.data;
    } on DioError {
      // if (e.response != null) return e.response?.data;

      return {'message': "Ocurrio un error en el server"};
    } catch (e) {
      print('ocurrio algo');
      return {'message': "Ocurrio un error intentelo mas tarde"};
    }
  }

  Future<Map<String, dynamic>> deleteComplaint(String id) async {
    try {
      final response = await _dio.delete('/api/complaints/$id');

      final complaint = Complaint.fromMap(response.data);
      int index = complaitsList.indexWhere((element) => element.id == id);
      complaitsList[index] = complaint;

      notifyListeners();
      return response.data;
    } on DioError catch (e) {
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
    for (var i = 0; i < complaints.length; i++) {
      final existValue = dropdownList
          .indexWhere((element) => element.value == complaints[i].state);
      if (existValue == -1) {
        dropdownList.add(
          DropdownMenuItem(
            value: complaitsList[i].state,
            child: Text(complaints[i].state),
          ),
        );
      }
    }
  }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }
}
