import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_card.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int count = 0;
  List<String> items = ["pdf to jpg", "jpg to pdf", "pdf to doc", "doc to pdf"
  ];
  List<String> images =[
    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.itechguides.com%2Fwp-content%2Fuploads%2F2020%2F05%2Fconvert-pdf-to-jpg-windows-10.png&f=1&nofb=1&ipt=6c887793a868bb9ceffaf2198a64736d089d43f4727c9e434b6bf8e15bf236da&ipo=images',
    'https://imagekit.androidphoria.com/wp-content/uploads/jpg-a-pdf-android.jpg',
    'https://i.ibb.co/rFWNcjZ/pdf-to-dog.png',
    'https://i.ibb.co/FgydPrQ/doc-to-pdf.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('task').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
            default:
              return new ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final task = snapshot.data.docs[index];
                  final fieldValue = task.data() as Map<String, dynamic>;
                  final feedback_tot = fieldValue['feedback_tot'];
                  final num_feed = fieldValue['num_feed'];
                  final taskname = fieldValue['taskname'];
                  return new TaskCard(
                    title: items[index],
                    feedback_tot: feedback_tot.toStringAsFixed(1).toString(),
                    num_feed: num_feed.toString(),
                    thumbnailUrl: images[index],
                  );
                },
              );
          }
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import '../models/task_card.dart';
//
// class TaskPage extends StatefulWidget {
//   @override
//   _TaskPageState createState() => _TaskPageState();
// }
//
// class _TaskPageState extends State<TaskPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: TaskCard(
//             title: 'Convert PDF',
//             feedback_tot: '4.9',
//             num_feed: '10',
//             thumbnailUrl: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.itechguides.com%2Fwp-content%2Fuploads%2F2020%2F05%2Fconvert-pdf-to-jpg-windows-10.png&f=1&nofb=1&ipt=6c887793a868bb9ceffaf2198a64736d089d43f4727c9e434b6bf8e15bf236da&ipo=images',
//           ),
//         );
//   }
// }