import 'package:Emergency_Web/main.dart';
import 'package:Emergency_Web/map/printList.dart';
import 'package:Emergency_Web/userDetails/driver_information.dart';
import 'package:Emergency_Web/userDetails/user_information.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Emergency_Web/api/food_api.dart';

class MenuApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency_Informer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Menu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    User _firebaseUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            // action button
            FlatButton(
              onPressed: () => setupSignOut(_firebaseUser),
              child: Text(
                "Logout",
                style: TextStyle(fontSize: 23, color: Colors.white),
              ),
            ),
          ],
        ),
        body: Container(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return TrainTimeTable();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Patients\'s Information',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 24),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return DriverInformation();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Drivers\'s Information',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 24),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PrintList();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Active Activities',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ]),
          ),
          // loatingActionButton: FloatingActionButton(
          //   onPressed: _incrementCounter,
          //   tooltip: 'Increment',
          //   child: Icon(Icons.add),
          // ),
        ));
  }

  void setupSignOut(User _firebaseUser) {
    signOut(_firebaseUser);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return MyApp();
    }));
  }
}
