import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import '../../Components/navbar.dart';
import '../controllers/home_controller.dart';
import '../models/home_model.dart';
User loggedinUser;


class HomeScreen extends StatefulWidget {
  final HomeModel model;
  HomeScreen({Key key, @required this.model}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController _homeController;

  @override
  void initState() {
    super.initState();
    if(widget.model != null)
      _homeController = HomeController(homeModel: widget.model);
    else
      _homeController = HomeController();
  }

  @override
  Widget build(BuildContext context) {
    double _buttonSize = MediaQuery.of(context).size.width / 4;
    double _logoSize = MediaQuery.of(context).size.width / 2.5;
    double _textSize = MediaQuery.of(context).size.width / 20;


    return Scaffold(
      appBar: AppBar(
        foregroundColor: HexColor('#f85f6a') ,
        leading: null,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      drawer: NavBar(),
          body: Stack(children: <Widget>[
        Positioned(
          top: -20,
          left: MediaQuery.of(context).size.width / 2 - _logoSize / 2,
          child: SizedBox(
            height: _logoSize,
            width: _logoSize ,
            child: Image.asset(
            'assets/images/logo.png', // path of logo
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Positioned(
                top: _logoSize + _textSize,
                left: MediaQuery.of(context).size.width / 2 - _textSize / 2,
                child: Text(
                  'Select the file to modify',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      color: Color.fromRGBO(100,100,100,1.0),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'
                  ),
                ),
              ),
              SizedBox(height: 50),
              Positioned(
                top: _logoSize + _textSize + 100,
                left: MediaQuery.of(context).size.width / 2 - _buttonSize / 2,
                child: SizedBox(
                  height: _buttonSize,
                  width: _buttonSize,
                  child: FloatingActionButton(
                    onPressed: () async {
                      _homeController.pickFile();
                    },
                    child: Transform.scale(
                      scale: 1.8,
                      child: Icon(Icons.file_upload_outlined),
                    ),
                    backgroundColor: Colors.redAccent,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                    heroTag: null,
                    tooltip: 'Bigger button',
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                height: _buttonSize * 2/5,
                width: _buttonSize * 2,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.redAccent,
                        width: 3.0
                    ),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.red, size: 30.0 ),
                    isExpanded: true,
                    isDense: true,
                    value: _homeController.homeModel.selectedChoice,
                    items: _homeController.homeModel.choices.map((String choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        _homeController.homeModel.selectedChoice = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 50),
              Positioned(
                  top: _logoSize + _textSize + _buttonSize + 200,
                  left: MediaQuery.of(context).size.width / 2 - _buttonSize * 2/3,
                  child: Visibility(
                    visible: _homeController.homeModel.isFileUploaded,
                    child: SizedBox(
                      height: _buttonSize * 2/5,
                      width: _buttonSize * 2,

                      child: FloatingActionButton(
                        onPressed: _homeController.homeModel.isFileUploaded ?  () async {
                          if(_homeController.homeModel.file != null) {
                            _homeController.uploadFile(_homeController.homeModel.file, _homeController.homeModel.selectedChoice);
                            setState(() {
                              _homeController.homeModel.isFileUploaded = true;
                            });
                          } else {
                            print("Please select a file");
                          }
                        } : null,

                        child: Text("Upload File", style: TextStyle(fontSize: 13, color: Colors.white)),
                        backgroundColor: Colors.redAccent,
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        heroTag: null,
                        tooltip: 'Send',
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
    ],
    ),
    );
  }
}

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final _auth = FirebaseAuth.instance;
//   final String url = "http://10.0.2.2:5000/upload";
//   Dio dio = Dio();
//
//   String _filePath;
//   File file;
//   bool isFileUploaded = false;
//   final  _choices =["pdf to jpg", "jpg to pdf", "pdf to doc", "doc to pdf"];
//   String _selectedChoice;
//
//   void initState() {
//     super.initState();
//     _selectedChoice = _choices[0];
//     dio.options.responseType = ResponseType.stream;
//     dio.options.receiveTimeout = 15000; //5s
//     getCurrentUser();
//   }
//
//   //using this function you can use the credentials of the user
//   void getCurrentUser() async {
//     try {
//       final user = await _auth.currentUser;
//       if (user != null) {
//         loggedinUser = user;
//         print("Hello there!");
//         if (user.email != null){
//           print(user.email + " e' un utente registrato");
//           if(user.displayName == null){
//             print("This user does not have a display name, modify it");
//
//           }
//         }else{
//           print("Sei un guest user");
//         }
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     double _buttonSize = MediaQuery.of(context).size.width / 4;
//     double _logoSize = MediaQuery.of(context).size.width / 2.5;
//     double _textSize = MediaQuery.of(context).size.width / 20;
//
//
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: HexColor('#f85f6a') ,
//         leading: null,
//         elevation: 0.0,
//         backgroundColor: Colors.white,
//       ),
//       drawer: NavBar(),
//           body: Stack(children: <Widget>[
//         Positioned(
//           top: -20,
//           left: MediaQuery.of(context).size.width / 2 - _logoSize / 2,
//           child: SizedBox(
//             height: _logoSize,
//             width: _logoSize ,
//             child: Image.asset(
//             'assets/images/logo.png', // path of logo
//             ),
//           ),
//         ),
//         Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Positioned(
//                 top: _logoSize + _textSize,
//                 left: MediaQuery.of(context).size.width / 2 - _textSize / 2,
//                 child: Text(
//                   'Select the file to modify',
//                   style: TextStyle(
//                       fontSize: MediaQuery.of(context).size.width * 0.040,
//                       color: Color.fromRGBO(100,100,100,1.0),
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Open Sans'
//                   ),
//                 ),
//               ),
//               SizedBox(height: 50),
//               Positioned(
//                 top: _logoSize + _textSize + 100,
//                 left: MediaQuery.of(context).size.width / 2 - _buttonSize / 2,
//                 child: SizedBox(
//                   height: _buttonSize,
//                   width: _buttonSize,
//                   child: FloatingActionButton(
//                     onPressed: () async {
//                       FilePickerResult result = await FilePicker.platform.pickFiles();
//                       if (result == null || result.files.isEmpty) {
//                         print("Not picked any file");
//                       } else {
//                         PlatformFile file1 = result.files.first;
//                         setState(() {
//                           this.file = File(file1.path);
//                           isFileUploaded = true;
//                         });
//                       }
//                     },
//                     child: Transform.scale(
//                       scale: 1.8,
//                       child: Icon(Icons.file_upload_outlined),
//                     ),
//                     backgroundColor: Colors.redAccent,
//                     elevation: 20,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(45.0),
//                     ),
//                     heroTag: null,
//                     tooltip: 'Bigger button',
//                   ),
//                 ),
//               ),
//               SizedBox(height: 50),
//               Container(
//                 height: _buttonSize * 2/5,
//                 width: _buttonSize * 2,
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: Colors.redAccent,
//                         width: 3.0
//                     ),
//                     borderRadius: BorderRadius.circular(8)
//                 ),
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: DropdownButton<String>(
//                     icon: Icon(Icons.arrow_drop_down, color: Colors.red, size: 30.0 ),
//                     isExpanded: true,
//                     isDense: true,
//                     value: _selectedChoice,
//                     items: _choices.map((String choice) {
//                       return DropdownMenuItem<String>(
//                         value: choice,
//                         child: Text(
//                           choice,
//                           textAlign: TextAlign.center,
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (String newValue) {
//                       setState(() {
//                         _selectedChoice = newValue;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 50),
//               Positioned(
//                   top: _logoSize + _textSize + _buttonSize + 200,
//                   left: MediaQuery.of(context).size.width / 2 - _buttonSize * 2/3,
//                   child: Visibility(
//                     visible: isFileUploaded,
//                     child: SizedBox(
//                       height: _buttonSize * 2/5,
//                       width: _buttonSize * 2,
//
//                       child: FloatingActionButton(
//                         onPressed: isFileUploaded ?  () async {
//                           var bytes = await this.file.readAsBytes();
//                           var formData = FormData.fromMap({
//                             "file": MultipartFile.fromBytes(bytes, filename: this.file.path.split("/").last)
//                           });
//                           var response = await dio.post(url, data: formData);
//                           print(response);
//
//                           // Get the directory where the file should be stored
//                           var dir = await getExternalStorageDirectory();
//                           var filePath = '${dir.path}/Downloads/${this.file.path.split("/").last}';
//
//                           // Download the file from the server in chunks
//                           var download = await dio.download(response.data['file_url'], filePath, onReceiveProgress: (received, total) {
//                             if (total != -1) {
//                               print((received / total * 100).toStringAsFixed(0) + "%");
//                             }
//                           });
//
//                           if(download.statusCode == 200){
//                             var file = File(filePath);
//                             if(await file.exists()){
//                               print("File stored successfully");
//                             }else{
//                               print("Error storing the file");
//                             }
//                           }else{
//                             print("Error downloading the file");
//                           }
//                           isFileUploaded = false;
//                         } : null,
//                         child: Text("Upload File", style: TextStyle(fontSize: 13, color: Colors.white)),
//                         backgroundColor: Colors.redAccent,
//                         elevation: 20,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         heroTag: null,
//                         tooltip: 'Send',
//                       ),
//                     ),
//                   )
//               )
//             ],
//           ),
//         ),
//     ],
//     ),
//     );
//   }
//
//   Future<String> getDownloadDirectory() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final downloadsDirectory = Directory("${directory.path}/downloads");
//     if (!await downloadsDirectory.exists()) {
//       await downloadsDirectory.create();
//     }
//     return downloadsDirectory.path;
//   }
//}