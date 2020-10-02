import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

//Page for show event detail to all user
class eventDetails extends StatefulWidget {
  var event_details;
  eventDetails({Key key, @required this.event_details}) : super(key: key);

  @override
  _eventDetailsState createState() => _eventDetailsState(event_details);
}

class _eventDetailsState extends State<eventDetails> {
  var event_details;
  _eventDetailsState(this.event_details);

  var androidInitilize;
  var iOSinitilize;
  var initilizationsSettings;
  FlutterLocalNotificationsPlugin fltrNotification;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    androidInitilize = new AndroidInitializationSettings('app_logo');
    iOSinitilize = new IOSInitializationSettings();
    initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings);
  }

  Future showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "channelId", "College Fest", "This is College Fest App",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var notificationDetails =
        new NotificationDetails(androidDetails, iSODetails);
    //await fltrNotification.show(0, 'title', 'body', notificationDetails,payload: 'test payload')

    //getting time and details for notifications
    var temptime = event_details.get('date');
    int year = int.parse(temptime.toString().substring(0, 4));
    int month = int.parse(temptime.toString().substring(5, 7));
    int day = int.parse(temptime.toString().substring(8, 10));
    int hr = int.parse(temptime.toString().substring(11, 13));
    int min = int.parse(temptime.toString().substring(14));

    Toast.show(
        'App will give notification before 1 day of event and before 2 hr of event ',
        context,
        gravity: Toast.BOTTOM,
        duration: 3);

    //before 1 day
    var scheduledDate1day = DateTime(year, month, day, hr, min);
    fltrNotification.schedule(0, event_details.get('title'),
        event_details.get('date'), scheduledDate1day, notificationDetails);
    //before 2hr
    var scheduledDate2hr = DateTime(year, month, day, hr, min);
    fltrNotification.schedule(0, event_details.get('title'),
        event_details.get('date'), scheduledDate2hr, notificationDetails);

    //on event time
    var scheduledDate = DateTime(year, month, day, hr, min);
    fltrNotification.schedule(0, event_details.get('title'),
        event_details.get('date'), scheduledDate, notificationDetails);
  }

  var firebaseConnection = FirebaseFirestore.instance;
  var authentication = FirebaseAuth.instance;
  var fullName;
  var college;
  var branch;
  var year;
  var gender;
  var rollno;

  @override
  Widget build(BuildContext context) {
    //getting user details from firebase to send details to admin if user book seat or want become volunteer
    firebaseConnection
        .collection('user')
        .doc(authentication.currentUser.uid)
        .snapshots()
        .listen((event) {
      fullName = event.get('name');
      branch = event.get('branch');
      year = event.get('year');
      gender = event.get('gender');
      rollno = event.get('rollno');
      college = event.get('collegeName');
      print(college);
      print(fullName);
    });

    //Converting 24 hr time format in 12 hr format
    var eventDate = new DateFormat("dd-MM-yyyy")
        .format(DateTime.parse(event_details.get('date').toString()));
    var eventTime = new DateFormat.jm()
        .format(DateTime.parse(event_details.get('time').toString()));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("College Fest App"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(5),
              child: Text(
                "Event Name: ${event_details.get('title')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(5),
              child: Text(
                "Date: ${eventDate}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(5),
              child: Text(
                "Time: ${eventTime}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(5),
              child: Text(
                "Organizer: ${event_details.get('organizer')}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(5),
              child: Text(
                "Discription: ${event_details.get('description')}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Card(
                margin: EdgeInsets.all(5),
                color: Colors.indigo,
                elevation: 10,
                child: FlatButton(
                  //Schedule Notification
                  onPressed: showNotification,
                  child: Text(
                    'Remind me',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(5),
                color: Colors.indigo,
                elevation: 10,
                child: FlatButton(
                  onPressed: () {
                    //Add user details in attendees collection under admin collection
                    firebaseConnection
                        .collection('admin')
                        .doc(event_details.get('admin'))
                        .collection('Events')
                        .doc(event_details.get('document_id'))
                        .collection('attendees')
                        .doc(authentication.currentUser.uid)
                        .set(
                      {
                        'userId': authentication.currentUser.uid,
                        'name': fullName,
                        'email': authentication.currentUser.email,
                        'branch': branch,
                        'year': year,
                        'rollno': rollno,
                        'college': college,
                        'gender': gender,
                      },
                      SetOptions(merge: true),
                    ).then((value) => {
                              Toast.show('Your seat has booked', context,
                                  gravity: Toast.BOTTOM, duration: 3),
                            });
                  },
                  child: Text(
                    'Book Seat',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(5),
                color: Colors.indigo,
                elevation: 10,
                child: FlatButton(
                  onPressed: () {
                    //Send user details to admin if user want to become volunteer
                    firebaseConnection
                        .collection('admin')
                        .doc(event_details.get('admin'))
                        .collection('Events')
                        .doc(event_details.get('document_id'))
                        .collection('volunteers')
                        .doc(authentication.currentUser.uid)
                        .set(
                      {
                        'userId': authentication.currentUser.uid,
                        'name': fullName,
                        'email': authentication.currentUser.email,
                        'branch': branch,
                        'year': year,
                        'rollno': rollno,
                        'college': college,
                        'gender': gender,
                      },
                      SetOptions(merge: true),
                    ).then((value) => {
                              Toast.show(
                                  'Your Information has sent to admin', context,
                                  gravity: Toast.BOTTOM, duration: 3),
                            });
                  },
                  child: Text(
                    'Be Volunter',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Future notificationSelected(String payload) async {
    if (payload != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('We will show remainder'),
        ),
      );
    }
  }
}
