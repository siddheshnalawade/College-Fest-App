import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Page for update profile of user
class userProfile extends StatefulWidget {
  userProfile({Key key}) : super(key: key);

  @override
  _userProfileState createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  final _formKey = GlobalKey<FormState>();
  String fullName;
  String college;
  String branch;
  String year;
  String gender;
  String rollno;

  var firebaseConnection = FirebaseFirestore.instance;
  var authentication = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Profile'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: fullName,
                    onChanged: (value) {
                      fullName = value;
                    },
                    validator: (fullName) {
                      if (fullName.isEmpty) {
                        return "please Enter Full Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextFormField(
                    initialValue: college,
                    onChanged: (value) {
                      college = value;
                    },
                    validator: (college) {
                      if (college.isEmpty) {
                        return "please Enter College Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'College Name',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextFormField(
                    initialValue: branch,
                    onChanged: (value) {
                      branch = value;
                    },
                    validator: (branch) {
                      if (branch.isEmpty) {
                        return "please Enter Branch";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Branch',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextFormField(
                    initialValue: year,
                    onChanged: (value) {
                      year = value;
                    },
                    validator: (year) {
                      if (year.isEmpty) {
                        return "please Enter Year";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Year',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextFormField(
                    initialValue: rollno,
                    onChanged: (value) {
                      rollno = value;
                    },
                    validator: (rollno) {
                      if (rollno.isEmpty) {
                        return "please Enter rollno";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Roll No.',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextFormField(
                    initialValue: gender,
                    onChanged: (value) {
                      gender = value;
                    },
                    validator: (gender) {
                      if (gender.isEmpty) {
                        return "please Enter gender";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        //update user details in firebase
                        if (_formKey.currentState.validate()) {
                          firebaseConnection
                              .collection('user')
                              .doc(authentication.currentUser.uid)
                              .set({
                            'name': fullName,
                            'collegeName': college,
                            'branch': branch,
                            'year': year,
                            'rollno': rollno,
                            'gender': gender,
                          }, SetOptions(merge: true));
                        } else {
                          return 'Please enter all feild';
                        }
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
