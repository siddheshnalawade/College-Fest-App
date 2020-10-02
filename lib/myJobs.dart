import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegefest/eventDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//Page to show jobs assign by admin
class myJobs extends StatefulWidget {
  myJobs({Key key}) : super(key: key);

  @override
  _myJobsState createState() => _myJobsState();
}

class _myJobsState extends State<myJobs> {
  var jobs;
  var firebaseConnection = FirebaseFirestore.instance;
  var authentication = FirebaseAuth.instance;
  Widget delete;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('My Jobs'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          builder: (context, snapshot) {
            try {
              if (snapshot.data == null)
                return CircularProgressIndicator();
              else {
                jobs = snapshot.data.docs;
              }
            } catch (e) {
              print(e);
            }

            return Container(
              child: ListView.builder(
                itemCount: (jobs.length != null) ? jobs.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  void deleteJob(BuildContext context) {
                    //Alert box for deleting job
                    var alertDialog = AlertDialog(
                      title: Text('Delete Job'),
                      content: Text('Do you want to delete job'),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            //deletting job from database
                            firebaseConnection
                                .collection('user')
                                .doc(authentication.currentUser.uid)
                                .collection('volunteerWork')
                                .doc(jobs[index].id)
                                .delete()
                                .then((value) {
                              Toast.show('Job has deleted', context,
                                  duration: 2, gravity: Toast.CENTER);
                              Navigator.of(context).pop();
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
                    elevation: 5,
                    child: ExpansionTile(
                      //tile to show job details
                      title: Text(
                          "Event Title :${jobs[index].get("event_title")}"),
                      subtitle: Text("Job: ${jobs[index].get("job")}"),
                      children: [
                        Text("Job: ${jobs[index].get("job")}"),
                        Text("Deadline: ${jobs[index].get('deadline')}"),
                        FlatButton(
                            color: Colors.red,
                            onPressed: () {
                              deleteJob(context);
                            },
                            child: Text('Delete'))
                      ],
                    ),
                  );
                },
              ),
            );
          },
          stream: firebaseConnection
              .collection("user")
              .doc(authentication.currentUser.uid)
              .collection('volunteerWork')
              .snapshots(),
        ),
      ),
    );
  }
}
