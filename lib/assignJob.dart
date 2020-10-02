import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//Page for assign job to volunteers
class assignJob extends StatefulWidget {
  var volunteerId;
  assignJob({Key key, @required this.volunteerId}) : super(key: key);

  @override
  _assignJobState createState() => _assignJobState(volunteerId);
}

class _assignJobState extends State<assignJob> {
  var volunteerId;
  _assignJobState(this.volunteerId);
  final _formKey = GlobalKey<FormState>();
  var firebaseConnection = FirebaseFirestore.instance;
  var date;
  var time;
  var event_title;

  var job;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Assign Job'),
        ),
        body: Container(
            margin: EdgeInsets.all(10),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Enter Event Title'),
                      onChanged: (value) {
                        event_title = value;
                      },
                      validator: (event_title) {
                        if (event_title.isEmpty) {
                          return "Please fill this feild ";
                        }
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: 'Enter Job for this Volunteer'),
                      onChanged: (value) {
                        job = value;
                      },
                      validator: (job) {
                        if (job.isEmpty) {
                          return "Please fill this feild ";
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Enter Deadline'),
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
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please Enter Date and Time';
                        }
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10)),
                      child: FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            //Adding job to database
                            firebaseConnection
                                .collection('user')
                                .doc(volunteerId)
                                .collection('volunteerWork')
                                .add({
                              'job': job,
                              'deadline': date,
                              'event_title': event_title,
                            }).then((value) => {
                                      if (value != null)
                                        {
                                          Toast.show('Job Assigned', context,
                                              gravity: Toast.CENTER,
                                              duration: 3),
                                        }
                                    });
                          } else {
                            Toast.show('Plase fill all fields', context);
                          }
                        },
                        child: Text(
                          'Assign',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}
