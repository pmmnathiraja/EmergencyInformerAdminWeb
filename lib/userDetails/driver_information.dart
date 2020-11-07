import 'package:Emergency_Web/screens/feed.dart';
import 'package:Emergency_Web/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class DriverInformation extends StatefulWidget {
  @override
  _DriverInformationState createState() => _DriverInformationState();
}

class _DriverInformationState extends State<DriverInformation> {
  dynamic firebaseData;
  DateTime birthDate;
  String _userName;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryColor),
    );
    return Scaffold(
      appBar: AppBar(
        // backgroundColor:Colors.purpleAccent,
        title: Container(
          alignment: Alignment.center,
          child: Text("User's Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              )),
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Driver').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error : ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.data.docs != null) {
                    return ListView(
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentData) {
                        print(documentData.id);
                        return ListTile(
                          title: Text(
                            documentData.id,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          onTap: () {
                            getData(documentData.id);
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
          Expanded(
            flex: 8,
            child: firebaseData != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "                        ${firebaseData['NIC Number']}",
                            textScaleFactor: 2,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Table(
                              //
                              children: [
                                TableRow(children: [
                                  Text("    NAME",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(":   ${firebaseData['Name']}",
                                      textScaleFactor: 1.5,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("", textScaleFactor: 0.5),
                                  Text("", textScaleFactor: 0.5),
                                ]),
                                TableRow(children: [
                                  Text("    EMAIL ADDRESS",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(":   ${firebaseData['Email Address']}",
                                      textScaleFactor: 1.5,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("", textScaleFactor: 0.5),
                                  Text("", textScaleFactor: 0.5),
                                ]),
                                TableRow(children: [
                                  Text("    BIRTH DAY",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(":    $birthDate",
                                      textScaleFactor: 1.5,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("", textScaleFactor: 0.5),
                                  Text("", textScaleFactor: 0.5),
                                ]),
                                TableRow(children: [
                                  Text("    NIC NUMBER",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(":   ${firebaseData['NIC Number']}",
                                      textScaleFactor: 1.5,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("", textScaleFactor: 0.5),
                                  Text("", textScaleFactor: 0.5),
                                ]),
                                TableRow(children: [
                                  Text("    VEHICLE NUMBER",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(":   ${firebaseData['vehicle Number']}",
                                      textScaleFactor: 1.5,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("", textScaleFactor: 0.5),
                                  Text("", textScaleFactor: 0.5),
                                ]),
                                TableRow(children: [
                                  Text("    PHONE NUMBER",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(":   ${firebaseData['Phone Number']}",
                                      textScaleFactor: 1.5,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("", textScaleFactor: 0.5),
                                  Text("", textScaleFactor: 0.5),
                                ]),
                                TableRow(children: [
                                  Text("    GENDER",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(":   ${firebaseData['Gender']}",
                                      textScaleFactor: 1.5,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("", textScaleFactor: 0.5),
                                  Text("", textScaleFactor: 0.5),
                                ]),
                              ],
                            )),
                      ])
                : Container(),
          ),
        ],
      ),
    );
  }

  Future<dynamic> getData(String idNumber) async {
    _userName = idNumber;
    final DocumentReference document =
        FirebaseFirestore.instance.collection("Driver").doc(idNumber);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        firebaseData = snapshot.data();
        print(firebaseData);
        Timestamp birthDayTimeStamp = firebaseData['Birth Day'];
        birthDate = birthDayTimeStamp.toDate();
      });
    });
  }
}
