import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../constants.dart';
import '../Login/login_screen_top_image.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        const LoginScreenTopImage(),
        Row(
          children: [
            Spacer(),
        Expanded(
          flex: 20,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
            width: 380,
            child:  Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
                //Do something with the user input.
              },
              decoration: const InputDecoration(
              hintText: "Enter an Email",
            prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
              ),
              ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
            obscureText: true,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
            hintText: "Enter a Password",
              prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.lock),
              ),
              ),
            onChanged: (value) {
            password = value;
            //Do something with the user input.
            }),
            SizedBox(
              height: 24.0,
              ),
            Hero(
              tag: 'signup_btn',
              child:ElevatedButton(
                child: Text(
                  "Sign Up".toUpperCase(),
                ),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          "Welcome back",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        action: SnackBarAction(
                          label: "Got it",
                          textColor: Colors.white,
                          onPressed: () {
                            // nothing, just for remove the popup
                          },
                        ),
                        duration: Duration(seconds: 3),
                      );
                      Navigator.pushReplacementNamed(context, 'home_screen');
                    }
                  } catch (e) {
                    String message = "No field compiled";
                    if( e.message != null)
                      message = e.message;
                    if(e.message == "Given String is empty or null")
                      message = "either the password or email field is empty!";
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text(
                          message,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        action: SnackBarAction(
                          label: "Got it",
                          textColor: Colors.white,
                          onPressed: () {
                            // nothing, just for remove the popup
                          },
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );

                  }
                  setState(() {
                    showSpinner = false;
                  });
                }),
            ),
              SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already registered? "),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'login_screen');
                    },
                    child: Text("Login",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            ),
            ),
            ),

          ],
          ),
        ),
          ],
        ),
        ]),
        ),
        ),
    );
  }
}