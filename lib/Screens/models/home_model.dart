import 'dart:io';

class HomeModel {
  String _filePath;
  File _file;
  bool _isFileUploaded = false;
  List<String> _choices =["pdf to jpg", "jpg to pdf", "pdf to doc", "doc to pdf"];
  String _selectedChoice;

  HomeModel({String selectedChoice = "pdf to jpg", List<String> choices}) {
    _selectedChoice = selectedChoice;
    _choices = ["pdf to jpg", "jpg to pdf", "pdf to doc", "doc to pdf"];
  }
  String get filePath => _filePath;

  List<String> get choices => _choices;
  String get selectedChoice => _selectedChoice;

  set filePath(String value) {
    _filePath = value;
  }

  File get file => _file;

  set file(File value) {
    _file = value;
  }

  bool get isFileUploaded => _isFileUploaded;

  set isFileUploaded(bool value) {
    _isFileUploaded = value;
  }


  set selectedChoice(String value) {
    _selectedChoice = value;
  }
}