import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//Show Participant list to admin
class eventParicipants extends StatefulWidget {
  var participants;
  eventParicipants({Key key, @required this.participants}) : super(key: key);

  @override
  _eventParicipantsState createState() => _eventParicipantsState(participants);
}

class _eventParicipantsState extends State<eventParicipants> {
  var participants;
  _eventParicipantsState(this.participants);
  var firebaseConnection = FirebaseFirestore.instance;
  var authentication = FirebaseAuth.instance;

  var attendees;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Event Participants'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          builder: (context, snapshot) {
            try {
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              } else {
                attendees = snapshot.data.docs;
              }
            } catch (e) {
              print(e);
            }

            return Container(
              child: ListView.builder(
                itemCount: (attendees.length != null) ? attendees.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ExpansionTile(
                      //Participants details
                      title: Text("Name: ${attendees[index].get('name')}"),
                      subtitle:
                          Text("College: ${attendees[index].get('college')}"),
                      children: [
                        Text("College: ${attendees[index].get('college')}"),
                        Text("Branch: ${attendees[index].get('branch')}"),
                        Text("Year: ${attendees[index].get('year')}"),
                        Text("Roll No: ${attendees[index].get('rollno')}"),
                        Text("Email: ${attendees[index].get('email')}"),
                        Text("Gender: ${attendees[index].get('gender')}"),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          stream: firebaseConnection
              .collection('admin')
              .doc(authentication.currentUser.uid)
              .collection('Events')
              .doc(participants.get('document_id'))
              .collection('attendees')
              .snapshots(),
        ),
      ),
    );
  }
}
