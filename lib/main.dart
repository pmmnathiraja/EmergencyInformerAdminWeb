import 'package:Emergency_Web/map/map_load_request.dart';
import 'package:Emergency_Web/map/printList.dart';
import 'package:Emergency_Web/notifier/food_notifier.dart';
import 'package:Emergency_Web/screens/login.dart';
import 'package:Emergency_Web/userDetails/user_information.dart';
import 'package:Emergency_Web/utils/colors.dart';
import 'package:Emergency_Web/views/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifier/auth_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryDark));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => FoodNotifier(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency_Informer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? MenuApp() : Login();
        },
      ),
    );
  }
}
