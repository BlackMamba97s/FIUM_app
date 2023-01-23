import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/Components/responsive.dart';
import 'package:login_signup/Screens/views/welcome_view.dart';
import 'package:provider/provider.dart';
import '../Components/background.dart';
import 'Home/home_screen.dart';
import 'Login/login_signup_btn.dart';
class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user!= null) {
      return HomeScreen();
    } else {
      return Background(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Responsive(
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Expanded(
                    child: WelcomeImage(),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 450,
                          child: LoginAndSignupBtn(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              mobile: const MobileWelcomeScreen(),
            ),
          ),
        ),
      );
    }
  }
  Future<User> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;

        return user;
    } catch (e) {
      print(e);
    }
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const WelcomeImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginAndSignupBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}