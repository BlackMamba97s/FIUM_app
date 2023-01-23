import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../constants.dart';

class LoginAndSignupBtn extends StatefulWidget {
  const LoginAndSignupBtn({
    Key key,
  }) : super(key: key);

  @override
  State<LoginAndSignupBtn> createState() => _LoginAndSignupBtnState();
}

class _LoginAndSignupBtnState extends State<LoginAndSignupBtn> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'login_screen');
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'registration_screen');
          },
          style: ElevatedButton.styleFrom(
              primary: kPrimaryLightColor, elevation: 0),
          child: Text(
            "Sign Up".toUpperCase(),
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () async {
            buildShowDialog(context);
            try {
              final newUser = await _auth.signInAnonymously();
              if (newUser != null) {
                Navigator.pushNamed(context, 'home_screen');
              }
            } catch (e) {
              print(e);
            }
          },
          style: ElevatedButton.styleFrom(
              primary: kPrimaryLightColor, elevation: 0),
          child: Text(
            "Enter as Guest".toUpperCase(),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }


  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

}