//this class loads screen according to user logged in or not

import 'package:flutter/material.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/pages/home_page.dart';

class AuthenticatePage extends StatefulWidget {
  final bool loadHome;
  AuthenticatePage({@required this.loadHome});

  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {
  @override
  Widget build(BuildContext context) {
    return widget.loadHome == true
        ? HomePage() //return homepage after authentication here
        : LoginScreen(); // replace this login screen with your welcome screeen
    //from where a user can select mode of authentication
  }
}
