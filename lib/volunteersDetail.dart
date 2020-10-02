import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegefest/assignJob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Page to show volunteer list to admin
class volunteersDetail extends StatefulWidget {
  var volunteers;
  volunteersDetail({Key key, @required this.volunteers}) : super(key: key);

  @override
  _volunteersDetailState createState() => _volunteersDetailState(volunteers);
}

class _volunteersDetailState extends State<volunteersDetail> {
  var volunteers;
  _volunteersDetailState(this.volunteers);
  var firebaseConnection = FirebaseFirestore.instance;
  var authentication = FirebaseAuth.instance;
  var voltr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Volunteers List'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          builder: (context, snapshot) {
            try {
              if (snapshot.data == null) {
                print('hello');
                return CircularProgressIndicator();
              } else {
                voltr = snapshot.data.docs;
              }
            } catch (e) {
              print(e);
            }

            return Container(
              child: ListView.builder(
                itemCount: (voltr.length != null) ? voltr.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ExpansionTile(
                      title: Text("Name: ${voltr[index].get('name')}"),
                      subtitle: Text("College: ${voltr[index].get('college')}"),
                      children: [
                        Text("College: ${voltr[index].get('college')}"),
                        Text("Branch: ${voltr[index].get('branch')}"),
                        Text("Year: ${voltr[index].get('year')}"),
                        Text("Roll No: ${voltr[index].get('rollno')}"),
                        Text("Email: ${voltr[index].get('email')}"),
                        Text("Gender: ${voltr[index].get('gender')}"),
                        Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(10)),
                          child: FlatButton(
                            onPressed: () {
                              //button to assgin job to volunteer
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => assignJob(
                                      volunteerId:
                                          voltr[index].get('userId'))));
                            },
                            child: Text(
                              'Assign Job',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
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
              .doc(volunteers.get('document_id'))
              .collection('volunteers')
              .snapshots(),
        ),
      ),
    );
  }
}
