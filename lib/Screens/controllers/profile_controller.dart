import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile_model.dart';
User loggedinUser;



class ProfileController {
  final _auth = FirebaseAuth.instance;
  ProfileModel _model;

  ProfileModel get model => _model;

  void init() async {
    var user = await _auth.currentUser;
    if (user != null) {
      _model = ProfileModel(
          email: user.email,
          photoUrl: user.photoURL ??
              'https://th.bing.com/th/id/R.79ec27da8040ac6fb50c1183162b07e5?rik=UubtlXGFaazMbg&riu=http%3a%2f%2fgetdrawings.com%2ffree-icon%2ffacebook-avatar-icon-54.png&ehk=xjoaXdt3%2bfy1CRKk9%2flqBKkNbTqMUvgtIiKxJQVMDTY%3d&risl=&pid=ImgRaw&r=0');
    }
  }

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



  Future<void> updateEmail(String email) async {
    try {
      print('the email to update is ' + email);
      print('pre firebase update '  + FirebaseAuth.instance.currentUser.email);
      await FirebaseAuth.instance.currentUser.updateEmail(email);
      print('post firebase update '  + FirebaseAuth.instance.currentUser.email);
      // update the email in the model
      _model.email = email;
    } catch (e) {
      print(e);
    }
  }



  Future<void> updatePassword(String password) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseAuth.instance.currentUser.updatePassword(password);

    } catch (e) {
      print(e);
    }
  }

}