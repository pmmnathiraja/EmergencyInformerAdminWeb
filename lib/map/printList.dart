// import 'package:CWCFlutter/screens/feed.dart';
import 'package:Emergency_Web/map/map_load_accepted.dart';
import 'package:Emergency_Web/utils/colors.dart';
import 'package:Emergency_Web/map/map_load_request.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class PrintList extends StatefulWidget {
  @override
  _PrintListState createState() => _PrintListState();
}

class _PrintListState extends State<PrintList> {
  dynamic firebaseData;
  DateTime birthDate;
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
          child: Text("Online Requests & Active Services",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              )),
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('RequestPool')
                    .snapshots(),
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
                            "REQUEST FROM",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "Patient's ID ${documentData.id}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return MapViewMainRequest(documentData.id);
                            })),
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
            flex: 5,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('RequestAccepted')
                    .snapshots(),
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
                            "Driver's ID  : ${documentData.data()['Driver_Name']}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "Patient's ID  : ${documentData.id}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return MapViewMainAccepted(documentData.id);
                            })),
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
