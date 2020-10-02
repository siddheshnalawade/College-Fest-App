import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

//User Registration Page
class register extends StatefulWidget {
  register({Key key}) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  final _formKey = GlobalKey<FormState>();
  var firebaseConnection = FirebaseFirestore.instance;
  var authentication = FirebaseAuth.instance;
  var firebaseMessaging = FirebaseMessaging();
  var user;
  String email;
  String password;
  var fullName;
  var college;
  var branch;
  var year;
  var gender;
  var rollno;
  bool registerState = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("College Fest App"),
        ),
        body: ModalProgressHUD(
          inAsyncCall: registerState,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Register Here.',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (email) {
                        if (email.isEmpty) {
                          return "please Enter Email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      obscuringCharacter: '*',
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (password) {
                        if (password.isEmpty) {
                          return "please Enter Password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        college = value;
                      },
                      validator: (college) {
                        if (college.isEmpty) {
                          return "please Enter Full Name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'College Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(20)),
                      child: FlatButton(
                        onPressed: () async {
                          print('hello');
                          print(email);
                          print(password);
                          setState(() {
                            registerState = true;
                          });
                          try {
                            user = await authentication
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            var token = await firebaseMessaging.getToken();

                            if (user != null) {
                              //Adding details of user to firebase
                              firebaseConnection
                                  .collection('user')
                                  .doc(authentication.currentUser.uid)
                                  .set({
                                'email':
                                    authentication.currentUser.email.toString(),
                                'device_token': token,
                                'name': fullName,
                                'collegeName': college,
                                'branch': branch,
                                'year': year,
                                'rollno': rollno,
                                'gender': gender,
                              });
                              Toast.show('Registration Successful', context,
                                  gravity: Toast.CENTER);
                              setState(() {
                                registerState = false;
                              });

                              Navigator.popAndPushNamed(context, "/home");
                              Toast.show('Registered Successfully', context,
                                  gravity: Toast.CENTER);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              Toast.show(
                                  'The password provided is too weak.', context,
                                  gravity: Toast.CENTER);
                              setState(() {
                                registerState = false;
                              });
                            } else if (e.code == 'email-already-in-use') {
                              Toast.show(
                                  'The account already exists for that email.',
                                  context,
                                  gravity: Toast.CENTER);
                              setState(() {
                                registerState = false;
                              });
                            }
                          } catch (e) {
                            Toast.show(e.toString(), context);
                          }
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
