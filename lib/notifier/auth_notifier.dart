import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthNotifier with ChangeNotifier {
  User get user => FirebaseAuth.instance.currentUser;

  void setUser(User user) async {
    notifyListeners();
  }
}
