import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegefest/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

//Login Page
class login extends StatefulWidget {
  login({Key key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>(); //form key for login form
  var authentication = FirebaseAuth.instance;
  var firebaseConnection = FirebaseFirestore.instance;
  var firebaseMessaging = FirebaseMessaging();
  String email;
  String password;
  var signIn;

  bool loginState = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //checking is currently user is loged in or not
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("College Fest App"),
        ),
        body: ModalProgressHUD(
          inAsyncCall: loginState,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Login Here',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
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
                      height: 20,
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
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Do not have an account?'),
                        FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/register");
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.blue),
                            )),
                      ],
                    ),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FlatButton(
                        onPressed: () async {
                          setState(() {
                            loginState = true;
                          });
                          try {
                            signIn =
                                await authentication.signInWithEmailAndPassword(
                                    email: email, password: password);
                            if (signIn != null) {
                              var token = await firebaseMessaging
                                  .getToken(); //getting device token for sending notifications
                              if (token != null) {
                                //store token in firebase
                                firebaseConnection
                                    .collection('token')
                                    .doc(token)
                                    .set({
                                  'deviceToken': token,
                                });
                              }
                              setState(() {
                                loginState = false;
                              });
                              Toast.show('Login Successfully.', context,
                                  gravity: Toast.CENTER);
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/home", (route) => false);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              Toast.show('No user with this email', context,
                                  gravity: Toast.CENTER);
                              setState(() {
                                loginState = false;
                              });
                            } else if (e.code == 'wrong-password') {
                              Toast.show(
                                'Wrong Password',
                                context,
                                backgroundColor: Colors.indigo,
                                gravity: Toast.CENTER,
                              );

                              setState(() {
                                loginState = false;
                              });
                            }
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
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
