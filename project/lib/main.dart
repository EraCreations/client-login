import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/helper/local_storage.dart';
import 'package:project/pages/authentication_page.dart';
// import 'package:project/pages/login_page.dart';
import 'package:project/pages/splash_screen.dart';
// import 'package:project/pages/welcome_page.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String value;
  bool showSplashScreen = true;
  bool loadHomeScreen = false;
  LocalStorage localStorage = LocalStorage();

  initializeFirebase() async {
    await Firebase.initializeApp();
    if (localStorage.prefs == null) {
      await localStorage.init();
    }
    value = localStorage.prefs.getString('key');
    String value1 = localStorage.prefs.getString('name');
    if (value == null) {
      setState(() {
        loadHomeScreen = false;
      });
    } else if (value != null) {
      loadHomeScreen = true;
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      showSplashScreen = false;
    });
    print(value);
  }

  @override
  void initState() {
    super.initState();
    //this function check users logged in or not and shows splash screen
    initializeFirebase();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: showSplashScreen == true
          ? SplashScreen() //run your splash screen widget here
          : AuthenticatePage(
              loadHome: loadHomeScreen,
            ),
    );
  }
}
