import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:Emergency_Web/api/food_api.dart';
import 'package:Emergency_Web/model/user.dart';
import 'package:Emergency_Web/notifier/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:Emergency_Web/utils/colors.dart';
import 'package:Emergency_Web/utils/utils.dart';
import 'package:Emergency_Web/views/reset_password.dart';
import 'package:provider/provider.dart';

enum AuthMode { Login }

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  int wrongPassword = 0;
  UserData _user = UserData();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
    }
  }

  login(UserData user, AuthNotifier authNotifier) async {
    UserCredential authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .catchError((error) => wrongPassword = 1);

    if (authResult != null) {
      User firebaseUser = authResult.user;

      if (firebaseUser != null) {
        print("Log In: $firebaseUser");
        authNotifier.setUser(authResult.user);
      }
    }
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: Colors.white54, fontSize: 22),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 20, color: Colors.white),
      cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (String value) {
        _user.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.white54, fontSize: 22),
      ),
      style: TextStyle(fontSize: 20, color: Colors.white),
      cursorColor: Colors.white,
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        if (value.isEmpty) {
          wrongPassword = 0;
          return 'Password is required';
        }

        if (value.length < 5 || value.length > 20) {
          wrongPassword = 0;
          return 'Password must be betweem 5 and 20 characters';
        }
        if (wrongPassword == 1) {
          return 'Invalide Password';
        }
        return null;
      },
      onSaved: (String value) {
        _user.password = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building login screen");
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryColor),
    );

    final pageTitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Log In",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 60.0,
          ),
        ),
        Text(
          "    We missed you!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );

    final forgotPassword = Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ResetPasswordPage();
        })),
        child: Center(
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
        decoration: BoxDecoration(gradient: primaryGradient),
        child: Stack(
          children: <Widget>[
            Form(
              autovalidate: true,
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(32, 0, 1000, 0),
                  child: Column(
                    children: <Widget>[
                      pageTitle,
                      SizedBox(height: 32),
                      //_authMode == AuthMode.Signup ? _buildDisplayNameField() : Container(),
                      _buildEmailField(),
                      _buildPasswordField(),
                      SizedBox(height: 16),
                      ButtonTheme(
                        minWidth: 200,
                        child: RaisedButton(
                          padding: EdgeInsets.all(10.0),
                          color: Colors.indigo,
                          onPressed: () => _submitForm(),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      forgotPassword,
                      // Text('This Web site only for Administration of Emergency Alarm App')
                    ],
                  ),
                ),
              ),
            ),
            //Padding(padding: EdgeInsets.fromLTRB(32, 0, 32, 0),),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(600.0, 0, 0, 0),
                  child: Container(
                    width: 800,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AvailableImages.homePage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
