import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

class MapViewMainAccepted extends StatefulWidget {
  MapViewMainAccepted(this._userID) : super();
  final _userID;
  @override
  _MapViewMainAcceptedState createState() => _MapViewMainAcceptedState();
}

class _MapViewMainAcceptedState extends State<MapViewMainAccepted> {
  @override
  void initState() {
    super.initState();
    GoogleMap.init('AIzaSyA8GY4o9vAR6URMqU6c4AE1UGLkfDG8iik');
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(widget._userID),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this._userID) : super();
  final _userID;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();
  bool _darkMapStyle = false;
  String _mapStyle;
  double _destLatitude;
  double _destLongitude;
  double _driverDestLatitude;
  double _driverDestLongitude;
  String _driverID;
  String _userID;

  List<Widget> _buildClearButtons() => [
        const SizedBox(width: 16),
        RaisedButton.icon(
          color: Colors.red,
          textColor: Colors.white,
          icon: Icon(Icons.pin_drop),
          label: Text('CLEAR MARKERS'),
          onPressed: () {
            GoogleMap.of(_key).clearMarkers();
          },
        ),
        const SizedBox(width: 16),
        RaisedButton.icon(
          color: Colors.red,
          textColor: Colors.white,
          icon: Icon(Icons.directions),
          label: Text('CLEAR DIRECTIONS'),
          onPressed: () {
            GoogleMap.of(_key).clearDirections();
          },
        ),
      ];

  List<Widget> _buildAddButtons() => [
        const SizedBox(width: 16),
        FloatingActionButton(
          child: Icon(Icons.directions),
          onPressed: () {
            GoogleMap.of(_key).clearDirections();
            GoogleMap.of(_key).clearMarkers();
            GoogleMap.of(_key).addDirection(
              GeoCoord(_destLatitude, _destLongitude),
              GeoCoord(_driverDestLatitude, _driverDestLongitude),
              startLabel: "👨🏼‍💼   $_userID",
              //startInfo: 'San Francisco, CA',
              endLabel: "🚑  $_driverID",
              //endInfo: 'San Jose, CA',
            );
          },
          heroTag: null,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text("Accept Request",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              )),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('RequestAccepted')
              .doc(widget._userID)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshot.data.data() != null) {
              GeoPoint positionUser = snapshot.data.data()['User_Location'];
              GeoPoint positionDriver = snapshot.data.data()['Driver_Location'];
              _driverID = snapshot.data.data()['Driver_Name'];
              _userID = widget._userID;
              _destLatitude = positionUser.latitude;
              _destLongitude = positionUser.longitude;
              _driverDestLatitude = positionDriver.latitude;
              _driverDestLongitude = positionDriver.longitude;
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: GoogleMap(
                      key: _key,
                      initialZoom: 8,
                      initialPosition: GeoCoord(
                          6.93162477957, 79.8421960567), // Los Angeles, CA
                      mapType: MapType.roadmap,
                      mapStyle: _mapStyle,
                      interactive: true,
                      onTap: (coord) =>
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(coord?.toString()),
                        duration: const Duration(seconds: 2),
                      )),
                      mobilePreferences: const MobileMapPreferences(
                        trafficEnabled: true,
                        zoomControlsEnabled: false,
                      ),
                      webPreferences: WebMapPreferences(
                        fullscreenControl: true,
                        zoomControl: true,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: kIsWeb ? 60 : 16,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (_darkMapStyle) {
                          GoogleMap.of(_key).changeMapStyle(null);
                          _mapStyle = null;
                        } else {
                          GoogleMap.of(_key).changeMapStyle(darkMapStyle);
                          _mapStyle = darkMapStyle;
                        }

                        setState(() => _darkMapStyle = !_darkMapStyle);
                      },
                      backgroundColor:
                          _darkMapStyle ? Colors.black : Colors.white,
                      child: Icon(
                        _darkMapStyle ? Icons.wb_sunny : Icons.brightness_3,
                        color: _darkMapStyle ? Colors.white : Colors.black,
                      ),
                      heroTag: null,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: kIsWeb ? 60 : 16,
                    bottom: 16,
                    child: Row(
                      children: <Widget>[
                        LayoutBuilder(
                          builder: (context, constraints) =>
                              constraints.maxWidth < 1000
                                  ? Row(children: _buildClearButtons())
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _buildClearButtons(),
                                    ),
                        ),
                        Spacer(),
                        ..._buildAddButtons(),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}

const darkMapStyle = r'''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
''';

const contentString = r'''
<div id="content">
  <div id="siteNotice"></div>
  <h1 id="firstHeading" class="firstHeading">Uluru</h1>
  <div id="bodyContent">
    <p>
      <b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large 
      sandstone rock formation in the southern part of the 
      Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) 
      south west of the nearest large town, Alice Springs; 450&#160;km 
      (280&#160;mi) by road. Kata Tjuta and Uluru are the two major 
      features of the Uluru - Kata Tjuta National Park. Uluru is 
      sacred to the Pitjantjatjara and Yankunytjatjara, the 
      Aboriginal people of the area. It has many springs, waterholes, 
      rock caves and ancient paintings. Uluru is listed as a World 
      Heritage Site.
    </p>
    <p>
      Attribution: Uluru, 
      <a href="http://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">
        http://en.wikipedia.org/w/index.php?title=Uluru
      </a>
      (last visited June 22, 2009).
    </p>
  </div>
</div>
''';
