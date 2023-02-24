import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_signup/Screens/models/home_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Components/navbar.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';

User loggedinUser;


class HomeController {
  final _auth = FirebaseAuth.instance;
  final String _url = "http://10.0.2.2:5000/upload";
  Dio _dio = Dio();
  HomeModel _homeModel;

  HomeController({HomeModel homeModel}) {
    _homeModel = HomeModel(selectedChoice: "jpg to pdf", choices: ["pdf to jpg", "jpg to pdf", "pdf to doc", "doc to pdf"]);
    _dio.options.responseType = ResponseType.stream;
    _dio.options.receiveTimeout = 15000; //5s
    _getCurrentUser();
  }


  HomeModel get homeModel => _homeModel;


  //using this function you can use the credentials of the user
  void _getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        print("Hello there!");
        if (user.email != null){
          print(user.email + " e' un utente registrato");
          if(user.displayName == null){
            print("This user does not have a display name, modify it");
          }
        }else{
          print("Sei un guest user");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) {
      print("Not picked any file");
    } else {
      PlatformFile file1 = result.files.first;
      _homeModel.file = File(file1.path);
      _homeModel.isFileUploaded = true;
    }
  }

   void uploadFile(File file, selected_choice) async {
    try{
      print(selected_choice + " this is the selected choice");
       var bytes = await file.readAsBytes();
       var formData = FormData.fromMap({
         "file": MultipartFile.fromBytes(bytes, filename: file.path.split("/").last),
         "selected_choice": selected_choice,
       });
      var response = await _dio.post(_url, data: formData, options: Options(responseType: ResponseType.stream,
          receiveTimeout: 100000));

      if (response.statusCode == 200) {
        var fileName = response.headers.map['content-disposition'][0].split('=')[1];
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
        var downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
        var saveFile = File('${downloadsDirectory.path}/$fileName');
        var sink = saveFile.openWrite();
        await sink.addStream(response.data.stream); // Convert ResponseBody to ByteStream
        await sink.flush();
        await sink.close();
        print('File saved successfully');
      } else {
        print('Error while uploading file');
      }
     } catch (e) {
    print(e);
    }
    _homeModel.isFileUploaded = false;
  }


  Future<File> saveFile(Stream<List<int>> stream) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/jpgs.zip');
    await file.writeAsBytes(await stream.toList().then((data) => data.expand((i) => i).toList()));
    return file;
  }
}