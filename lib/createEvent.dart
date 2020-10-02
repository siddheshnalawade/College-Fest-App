import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegefest/MainDrawer.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//Page for creating events
class createEvent extends StatefulWidget {
  createEvent({Key key}) : super(key: key);

  @override
  _createEventState createState() => _createEventState();
}

class _createEventState extends State<createEvent> {
  final _formKey = GlobalKey<FormState>();
  var firebaseConnection = FirebaseFirestore.instance;
  var authentication = FirebaseAuth.instance;
  var token = FirebaseMessaging().getToken();
  var title;
  var time;
  var date;
  var organizer;
  var description;
  var wantAttendeesList;
  var docIdForAttendees;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('College Fest App'),
      ),
      drawer: MainDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                //Form for get all details of event like time, date,title,description etc.
                Text(
                  'Create New Event',
                  style: TextStyle(fontSize: 20),
                ),
                TextFormField(
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title of Event',
                  ),
                  validator: (title) {
                    if (title.isEmpty) {
                      return 'Please Enter Title';
                    }
                    return null;
                  },
                ),
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: 'null',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2030),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Time",
                  use24HourFormat: false,
                  onChanged: (val) {
                    print(val);

                    date = val;
                    time = val;
                  },
                  validator: (date) {
                    if (date.isEmpty) {
                      return 'Please Enter Date and Time';
                    }
                    print(date);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
                TextFormField(
                  onChanged: (value) {
                    organizer = value;
                  },
                  validator: (organizer) {
                    if (organizer.isEmpty) {
                      return "please Enter organizer";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Organizer',
                      hintText: 'eg. college name or club name'),
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  width: double.infinity,
                  height: 200,
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      description = value;
                    },
                    validator: (description) {
                      if (description.isEmpty) {
                        return "please Enter description";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'eg. timeline,rules,fees etc.'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(10)),
                  child: FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Toast.show('Creating Event..', context,
                            gravity: Toast.CENTER, duration: 3);

                        //Adding Event details in firebase
                        firebaseConnection.collection('CollegeEvents').add({
                          'admin': authentication.currentUser.uid.toString(),
                          'title': title,
                          'date': date,
                          'time': time,
                          'organizer': organizer,
                          'description': description,
                        }).then((value) {
                          //getting document id for crating attendees collection
                          docIdForAttendees = value.id.toString();
                          firebaseConnection
                              .collection('CollegeEvents')
                              .doc(docIdForAttendees)
                              .update({
                            'document_id': docIdForAttendees,
                          }).then((value) => {
                                    Toast.show(
                                        "Event Created Successfully.", context,
                                        gravity: Toast.CENTER, duration: 3),
                                  });
                          //Adding Details of event in Events collection under admin collection
                          firebaseConnection
                              .collection('admin')
                              .doc(authentication.currentUser.uid)
                              .collection('Events')
                              .doc(docIdForAttendees)
                              .set({
                            'admin': authentication.currentUser.uid.toString(),
                            'title': title,
                            'date': date,
                            'time': time,
                            'organizer': organizer,
                            'description': description,
                            'document_id': docIdForAttendees,
                          });

                          firebaseConnection
                              .collection('admin')
                              .doc(authentication.currentUser.uid)
                              .set({
                            'admin_email': authentication.currentUser.email,
                          });
                        });
                      } else {
                        Toast.show(
                            "Create Valid Event or Enter all fields.", context,
                            gravity: Toast.CENTER, duration: 3);
                      }
                    },
                    child: Text(
                      "Create Event",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
