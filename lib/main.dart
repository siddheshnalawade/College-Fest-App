import 'package:collegefest/IcreateEvents.dart';
import 'package:collegefest/assignJob.dart';
import 'package:collegefest/createEvent.dart';
import 'package:collegefest/eventParticipants.dart';
import 'package:collegefest/home.dart';
import 'package:collegefest/login.dart';
import 'package:collegefest/myCollegeEvents.dart';
import 'package:collegefest/myJobs.dart';
import 'package:collegefest/profile.dart';
import 'package:collegefest/register.dart';
import 'package:collegefest/volunteersDetail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Home_page());
}

//Main Screen of app contain two options login and register
class Home_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
      initialRoute: '/login',
      routes: {
        "/login": (context) => login(),
        "/register": (context) => register(),
        "/home": (context) => CollegeFestHomePage(),
        "/createEvent": (context) => createEvent(),
        "/myCollegeEvents": (context) => myCollegeEvent(),
        "/eventParticipants": (context) => eventParicipants(),
        "/iCreateEvents": (context) => iCreateEvents(),
        "/volunteersDetail": (context) => volunteersDetail(),
        "/assignJob": (context) => assignJob(),
        "/profile": (context) => userProfile(),
        "/myJobs": (context) => myJobs(),
      },
    );
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("College Fest App"), backgroundColor: Colors.indigo),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
