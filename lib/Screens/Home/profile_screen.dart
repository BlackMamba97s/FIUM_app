import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../Components/navbar.dart';
import '../controllers/profile_controller.dart';



class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();


}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = ProfileController();
  final TextEditingController _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;



  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user != null) {
        if (mounted) {
          // we are ok
        }
      }
    });
    super.initState();
    _controller.init();
    _emailController.text = _auth.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
   // String _emailValue;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: HexColor('#f85f6a') ,
        leading: null,
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
      ),
      drawer: NavBar(),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
        Expanded(
        child: Container(
            margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Center(
        child: CircleAvatar(
          radius: 120,
          backgroundImage: NetworkImage('https://th.bing.com/th/id/R.79ec27da8040ac6fb50c1183162b07e5?rik=UubtlXGFaazMbg&riu=http%3a%2f%2fgetdrawings.com%2ffree-icon%2ffacebook-avatar-icon-54.png&ehk=xjoaXdt3%2bfy1CRKk9%2flqBKkNbTqMUvgtIiKxJQVMDTY%3d&risl=&pid=ImgRaw&r=0'),
        ),
      ),
          SizedBox(
            height: 20,
          ),
            TextField(
              controller: _emailController,
              enabled: true,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: TextButton(
              onPressed: () {
                _controller.updateEmail(_emailController.text);
              },
              child: Text(
                'Update Email',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
    SizedBox(
      height: 10,
    ),
          Flexible(
            child: TextField(
              enabled: true,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              onSubmitted: (value) {
                _controller.updatePassword(value);
              },
            ),
          ),
    SizedBox(
      height: 20,
    ),
    TextButton(
    onPressed: (){
    //Do something here
    },
    child: Text(
    'Edit Profile',
    style: TextStyle(
    color: Colors.blue,
    ),
    ),
    ),
        ],
      ),
      ),
      ),
          ],
      ),
    );
  }

  }


// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final _auth = FirebaseAuth.instance;
//   String email = '';
//   void initState() {
//     super.initState();
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
//           email = user.email;
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile',
//           style: TextStyle(color: Colors.white),
//         ),
//         foregroundColor: HexColor('#f85f6a') ,
//         leading: null,
//         elevation: 0.0,
//         backgroundColor: Colors.redAccent,
//       ),
//       drawer: NavBar(),
//       body: Center(
//         child: Text(
//           "Profile: " + this.email.toString(),
//           style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
