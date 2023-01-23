import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../Components/navbar.dart';
import '../views/task_page_view.dart';
// import the package

User loggedinUser;

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: HexColor('#f85f6a') ,
        leading: null,
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
      ),
      drawer: NavBar(),
      body: TaskPage(),
    );
  }
}
