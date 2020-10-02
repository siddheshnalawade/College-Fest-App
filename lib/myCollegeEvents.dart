import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegefest/MainDrawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'eventDetails.dart';

//Show Events list created by all users
class myCollegeEvent extends StatefulWidget {
  myCollegeEvent({Key key}) : super(key: key);

  @override
  _myCollegeEventState createState() => _myCollegeEventState();
}

class _myCollegeEventState extends State<myCollegeEvent> {
  var firebaseConnection = FirebaseFirestore.instance;
  var firebaseMessaging = FirebaseMessaging();
  var events;

  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseMessaging.getToken();
    configureFirebaseMessaging();
  }

  configureFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('All Events'),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          builder: (context, snapshot) {
            try {
              if (snapshot.data == null)
                return CircularProgressIndicator();
              else {
                events = snapshot.data.docs;
              }
            } catch (e) {
              print(e);
            }

            return Container(
              child: ListView.builder(
                itemCount: (events.length != null) ? events.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(events[index].get("title")),
                      subtitle: Text(events[index].get("date")),
                      trailing: IconButton(
                        icon: Icon(Icons.info),
                        color: Colors.indigo,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  eventDetails(event_details: events[index])));
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
          stream: firebaseConnection.collection("CollegeEvents").snapshots(),
        ),
      ),
    );
  }
}
