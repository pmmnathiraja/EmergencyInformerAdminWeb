import 'package:Emergency_Web/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:Emergency_Web/utils/colors.dart';
import 'package:line_icons/line_icons.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appBar = Padding(
      padding: EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          )
        ],
      ),
    );

    final pageTitle = Container(
      child: Text(
        "         Reset Password",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 40.0,
        ),
      ),
    );

    final emailField = TextFormField(
      decoration: InputDecoration(
        labelText: 'Email Address',
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(
          LineIcons.envelope,
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
    );

    final resetPasswordForm = Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[emailField],
        ),
      ),
    );

    final resetPasswordBtn = Container(
      margin: EdgeInsets.only(top: 40.0),
      height: 60.0,
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        border: Border.all(color: Colors.white),
        color: Colors.white,
      ),
      child: RaisedButton(
        elevation: 5.0,
        // onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
        //    return MapViewMain();
        // })),

        color: Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(7.0),
        ),
        onPressed: () {},
        child: Text(
          'RESET',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
          ),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40.0),
        decoration: BoxDecoration(gradient: primaryGradient),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                appBar,
                Container(
                  padding: EdgeInsets.only(left: 30.0, right: 1000.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      pageTitle,
                      resetPasswordForm,
                      resetPasswordBtn,
                    ],
                  ),
                )
              ],
            ),
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
