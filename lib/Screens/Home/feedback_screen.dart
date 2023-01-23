import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Components/navbar.dart';
import '../welcome_screen.dart';


class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<String> items = ["pdf to jpg", "jpg to pdf", "pdf to doc", "doc to pdf"
    ];
    List<String> images =[
      'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.itechguides.com%2Fwp-content%2Fuploads%2F2020%2F05%2Fconvert-pdf-to-jpg-windows-10.png&f=1&nofb=1&ipt=6c887793a868bb9ceffaf2198a64736d089d43f4727c9e434b6bf8e15bf236da&ipo=images',
      'https://imagekit.androidphoria.com/wp-content/uploads/jpg-a-pdf-android.jpg',
      'https://i.ibb.co/rFWNcjZ/pdf-to-dog.png',
      'https://i.ibb.co/FgydPrQ/doc-to-pdf.png',
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Feedback',
            style: TextStyle(color: Colors.white),
          ),
          foregroundColor: HexColor('#f85f6a') ,
          leading: null,
          elevation: 0.0,
          backgroundColor: Colors.redAccent,
        ),
        drawer: NavBar(),
        body: Container(
            alignment: Alignment.center,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () async {
                        try {
                              final _auth = FirebaseAuth.instance;
                              final user = await _auth.currentUser;
                              final email = await _auth.currentUser?.email;
                              if (user != null) {
                                if(user.isAnonymous){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Guest user detected!", style: TextStyle(color: Colors.redAccent),),
                                        content: Text("Login to leave a feedback on a task!"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Login"),
                                            onPressed: () {
                                              _auth.signOut();
                                              Navigator.pushNamedAndRemoveUntil(context, 'login_screen', (route) => route.isFirst);                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context, builder: (context) => RatingWidget(index: '${items[index]}', user: '$email'),
                                  );
                                }
                              }else{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  WelcomeScreen()),
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                        },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('${items[index]}', style: Theme.of(context).textTheme.headline6),
                            Stack(
                              children: <Widget>[
                                Opacity(
                                  opacity: 0.5,
                                  child: Image.network(
                                    '${images[index]}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    // other widgets here
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
          ),
      );

  }

}

// onTap: ()  async {try {
// final _auth = FirebaseAuth.instance;
// final user = await _auth.currentUser;
// final email = await _auth.currentUser?.email;
// if (user != null) {
// if(user.isAnonymous){
// showDialog(
// context: context, builder: (context) =>TextFieldWidget(),
// );
// } else {
// showDialog(
// context: context, builder: (context) => RatingWidget(index: '${items[index]}', user: '$email'),
// );
// }
// }
// } catch (e) {
// print(e);
// }
// }

class TextFieldWidget extends StatefulWidget {

  const TextFieldWidget({Key key}) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: TextField(
            decoration: InputDecoration(
              hintText: "Enter your name",
            )
        )
    );
  }
}





class RatingWidget extends StatefulWidget {
  final String index;
  final String user;

  const RatingWidget({Key key,  this.index,  this.user }) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState(index,user);
}

class _RatingWidgetState extends State<RatingWidget> {
  final String index;
  final String user;
  double rating=0;
  final TextEditingController _controller = TextEditingController();
  //final GlobalKey<FormState> _formKey = GlobalKey();

  _RatingWidgetState(this.index, this.user);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 30,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) async {
          var c;
          var r;
          double previusFeedback= 0;

          //collegamento con datrabase dei task con relativo feedback
          var documentSnapshot = await FirebaseFirestore.instance
              .collection("task")
              .doc(index)
              .get();

          //recupero somma di feedback e numero totale
          final fieldValue = documentSnapshot.data()as Map<String, dynamic>;
          c = fieldValue['num_feed'];
          r = fieldValue['sum'];

          //collegamento a user con relativo feedback dato se presente
          final DocumentReference ratingRef = FirebaseFirestore.instance.collection("ratings").doc(user).collection(index).doc('ratings');
          DocumentSnapshot ratingSnapshot = await ratingRef.get();
          if (ratingSnapshot.exists && ratingSnapshot.data()!=null) {
            final data = ratingSnapshot.data()as Map<String, dynamic>;
            previusFeedback=data['ratings'] ;
            ratingRef.set({'ratings': rating});
          }else{
            previusFeedback=0;
            ratingRef.set({'ratings': rating});
            c= c+1;
          }

          //   var documentSnapshotUser = await FirebaseFirestore.instance
          //       .collection('utente_feedback')
          //       .doc(index)
          //       .get();
          //
          // if (documentSnapshotUser != null){
          //    final fieldValueUser = documentSnapshotUser.data()as Map<String, dynamic>;
          //     previusFeedback = fieldValueUser['feedback'];
          //     await collectionUser.doc(index).set({
          //       'feedback': rating,
          //     });
          //   } else {
          //     await collectionUser.doc(index).set({
          //       'feedback': rating,
          //     });
          //     previusFeedback = 0;
          //   }

          var rating1 = ( r + rating - previusFeedback) / (c);

          final collection =
          FirebaseFirestore.instance.collection('task');
          // Write the server's timestamp and the user's feedback
          await collection.doc(index).set({
            'num_feed': c,
            'feedback_tot': rating1,
            'sum': r + rating - previusFeedback,
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}