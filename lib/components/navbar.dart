import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_signup/Screens/Home/feedback_screen.dart';
import 'package:login_signup/Screens/Home/home_screen.dart';
import 'package:login_signup/Screens/Home/profile_screen.dart';
import 'package:login_signup/Screens/Home/task_screen.dart';
import 'package:login_signup/Screens/welcome_screen.dart';

// ignore: must_be_immutable
class NavBar extends StatelessWidget {

  final _auth = FirebaseAuth.instance;
  bool isLoggedIn = false;

  NavBar() {
    final user = _auth.currentUser;
      if (user != null) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
      }
    }


  @override
  Widget build(BuildContext context) {

    if(!isLoggedIn){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  WelcomeScreen()),
      );
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: IconButton(
              alignment: Alignment.topLeft,
              icon: Icon(Icons.close,
                  color: HexColor('#f85f6a')
              ),
              onPressed: () => {Navigator.of(context).pop()},
            ),
          ),
          ListTile(
            leading: Icon(Icons.home,
                color: HexColor('#f85f6a')),
            title: Text('Home'),
            onTap: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context)=> HomeScreen())
            ),},
          ),
          ListTile(
            leading: Icon(Icons.person,
                color: HexColor('#f85f6a')),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context)=> ProfileScreen())
            ),},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_basket,
                color: HexColor('#f85f6a')),
            title: Text('Task'),
            onTap: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context)=> TaskScreen())
            ),},
          ),
          ListTile(
            leading: Icon(Icons.favorite_outlined,
                color: HexColor('#f85f6a')),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context)=> FeedbackScreen())
            ),},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app,
                color: HexColor('#f85f6a')),
            title: Text('Logout'),
            onTap: () => {
              _auth.signOut(),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  WelcomeScreen()),
              ),
            },
          ),
        ],
      ),
    );
  }
}
