import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegefest/MainDrawer.dart';
import 'package:collegefest/eventParticipants.dart';
import 'package:collegefest/volunteersDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//Admin page show all events created by current user
class iCreateEvents extends StatefulWidget {
  iCreateEvents({Key key}) : super(key: key);

  @override
  _iCreateEventsState createState() => _iCreateEventsState();
}

class _iCreateEventsState extends State<iCreateEvents> {
  var firebaseConnection = FirebaseFirestore.instance;
  var authentication = FirebaseAuth.instance;
  var iCreateEvents;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('You Created Events'),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          builder: (context, snapshot) {
            try {
              if (snapshot.data == null)
                return CircularProgressIndicator();
              else {
                iCreateEvents = snapshot.data.docs;
              }
            } catch (e) {
              print(e);
            }
            return Container(
              child: ListView.builder(
                itemCount:
                    (iCreateEvents.length != null) ? iCreateEvents.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  //Show alert box if admin want to delete event
                  void deleteEvent(BuildContext context) {
                    var alertDialog = AlertDialog(
                      title: Text('Delete Event'),
                      content: Text('Do you want to delete event?'),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            //delete event details from CollegeEvents collection
                            var docId = iCreateEvents[index].get('document_id');
                            firebaseConnection
                                .collection('CollegeEvents')
                                .doc(docId)
                                .delete()
                                .then((value) => {
                                      Toast.show(
                                          'Event Deleted Successfully', context,
                                          gravity: Toast.BOTTOM, duration: 2),
                                      Navigator.of(context).pop(),
                                    });
                          },
                          child: Text('Yes'),
                        ),
                        FlatButton(
                          child: Text('No'),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    );

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alertDialog;
                        });
                  }

                  //Show alert box when admin want delete event details like list of attendees,list of volunteers
                  void deleteAllDetails(BuildContext context) {
                    var alertDialog = AlertDialog(
                      title: Text('Delete All Details'),
                      content: Text('Do you want to delete all details?'),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            //delete all details from admin collection
                            firebaseConnection
                                .collection('admin')
                                .doc(authentication.currentUser.uid)
                                .collection('Events')
                                .doc(iCreateEvents[index].get('document_id'))
                                .delete()
                                .then((value) => {
                                      Toast.show(
                                          'Deleted All Details,attendees list,volunteers list',
                                          context,
                                          gravity: Toast.CENTER,
                                          duration: 3),
                                    });

                            var docId = iCreateEvents[index].get('document_id');
                            firebaseConnection
                                .collection('CollegeEvents')
                                .doc(docId)
                                .delete()
                                .then((value) => {
                                      Toast.show(
                                          'Event Deleted Successfully', context,
                                          gravity: Toast.BOTTOM, duration: 2),
                                      Navigator.of(context).pop(),
                                    });
                          },
                          child: Text('Yes'),
                        ),
                        FlatButton(
                          child: Text('No'),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    );

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alertDialog;
                        });
                  }

                  return Card(
                    child: ExpansionTile(
                      title: Text(iCreateEvents[index].get("title")),
                      subtitle: Text(iCreateEvents[index].get("date")),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 25,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: FlatButton(
                                onPressed: () {
                                  deleteEvent(context);
                                },
                                child: Text(
                                  'Delete Event',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              height: 25,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: FlatButton(
                                //Button to show volunteers list
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => volunteersDetail(
                                          volunteers: iCreateEvents[index])));
                                },
                                child: Text(
                                  'Veiw Volunteers',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 25,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: FlatButton(
                                //button to show attendees list
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => eventParicipants(
                                          participants: iCreateEvents[index])));
                                },
                                child: Text(
                                  'View Participants',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: FlatButton(
                                onPressed: () {
                                  deleteAllDetails(context);
                                },
                                child: Text(
                                  'Delete all details',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
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
              .snapshots(),
        ),
      ),
    );
  }
}
