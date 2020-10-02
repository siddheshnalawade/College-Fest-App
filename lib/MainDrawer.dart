import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Drawer menu in appbar
class MainDrawer extends StatefulWidget {
  MainDrawer({Key key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  var authentication = FirebaseAuth.instance;
  var firebaseConnection = FirebaseFirestore.instance;
  static String fullName;
  var college;
  var branch;
  var year;
  var gender;
  var rollno;

  @override
  Widget build(BuildContext context) {
    //getting current user details to show in drawer
    firebaseConnection
        .collection('user')
        .doc(authentication.currentUser.uid)
        .snapshots()
        .listen((event) {
      fullName = event.get('name');
      college = event.get('collegeName');
      branch = event.get('branch');
      year = event.get('year');
      gender = event.get('gender');
      rollno = event.get('rollno');
    });

    var email = authentication.currentUser.email;
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Colors.indigo,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Container(
              width: 100,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Name-$fullName",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    "Email-$email",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Update Profile'),
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Create New Event'),
            onTap: () {
              Navigator.pushNamed(context, "/createEvent");
            },
          ),
          ListTile(
            leading: Icon(Icons.event_available),
            title: Text('View All Events'),
            onTap: () {
              Navigator.pushNamed(context, '/myCollegeEvents');
            },
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text('Admin'),
            onTap: () {
              Navigator.pushNamed(context, "/iCreateEvents");
            },
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('My Jobs'),
            onTap: () {
              Navigator.pushNamed(context, "/myJobs");
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Logout'),
            onTap: () {
              authentication.signOut();
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
