import 'package:collegefest/MainDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Home Page After Login
class CollegeFestHomePage extends StatefulWidget {
  CollegeFestHomePage({Key key}) : super(key: key);

  @override
  _CollegeFestHomePageState createState() => _CollegeFestHomePageState();
}

class _CollegeFestHomePageState extends State<CollegeFestHomePage> {
  var authentication = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 5,
          title: Text(
            'College Fest App',
          ),
          actions: [
            Card(
              margin: EdgeInsets.all(10),
              color: Colors.white,
              child: FlatButton(
                onPressed: () {
                  authentication.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: Text('Logout'),
              ),
            ),
          ],
        ),
        drawer: MainDrawer(),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset('assets/event.jpg'),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/createEvent');
                      },
                      child: Text(
                        'Create Event',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/myCollegeEvents');
                      },
                      child: Text(
                        'All Events',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/iCreateEvents");
                      },
                      child: Text(
                        'Admin',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/myJobs");
                      },
                      child: Text(
                        'My Jobs',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
