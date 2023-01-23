import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile_model.dart';

class ProfileController {
  final _auth = FirebaseAuth.instance;
  ProfileModel _model;

  ProfileModel get model => _model;

  void init() async {
    final user = await _auth.currentUser;
    if (user != null) {
      _model = ProfileModel(
          email: user.email,
          photoUrl: user.photoURL ??
              'https://th.bing.com/th/id/R.79ec27da8040ac6fb50c1183162b07e5?rik=UubtlXGFaazMbg&riu=http%3a%2f%2fgetdrawings.com%2ffree-icon%2ffacebook-avatar-icon-54.png&ehk=xjoaXdt3%2bfy1CRKk9%2flqBKkNbTqMUvgtIiKxJQVMDTY%3d&risl=&pid=ImgRaw&r=0');
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await FirebaseAuth.instance.currentUser.updateEmail(email);
      // update the email in the model
      model.email = email;
    } catch (e) {
      print(e);
    }
  }



  Future<void> updatePassword(String password) async {
    try {
      await FirebaseAuth.instance.currentUser.updatePassword(password);

    } catch (e) {
      print(e);
    }
  }

}