import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project/component/action_button.dart';
import 'package:project/component/text_field.dart';
import 'package:project/helper/firebase.dart';
import 'package:project/helper/local_storage.dart';
import 'package:project/helper/screen_size.dart';
import 'package:project/helper/validators.dart';
import 'package:project/modal/account.dart';
import 'package:project/pages/registration_Page.dart';
import 'package:project/pages/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLoading = false;
  String password;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String email;
  @override
  Widget build(BuildContext context) {
    Screen screen = Screen(context);
    return ModalProgressHUD(
      inAsyncCall: showLoading,
      child: Form(
        key: formKey,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(0xff063C8D),
          // resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: EdgeInsets.all(screen.horizontal(4)),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: screen.vertical(150),
                  ),
                  Text(
                    'Welcome!',
                    style: TextStyle(color: Colors.white, fontSize: 36),
                  ),
                  SizedBox(
                    height: screen.vertical(25),
                  ),
                  Text(
                    'Enter your email and password to login in.',
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                  SizedBox(
                    height: screen.vertical(45),
                  ),
                  CustomTextField(
                    hintText: 'Email',
                    validator: emailValidator,
                    onChanged: (value) {
                      email = value;
                    },
                    textAlignment: TextAlign.start,
                    keyboard: TextInputType.emailAddress,
                    preffixWidget: Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(25),
                  ),
                  CustomTextField(
                    hintText: 'Password',
                    validator: passwordValidator,
                    onChanged: (value) {
                      password = value;
                      print(password);
                    },
                    textAlignment: TextAlign.start,
                    hideText: true,
                    preffixWidget: Icon(
                      Icons.vpn_key_outlined,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(25),
                  ),
                  Button(
                    'Login',
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        setState(() {
                          showLoading = true;
                        });
                        Authentication authentication = Authentication();
                        var user;
                        try {
                          user =
                              await authentication.loginUser(email, password);
                        } catch (e) {
                          setState(() {
                            showLoading = false;
                          });
                          if (Platform.isAndroid) {
                            switch (e.message) {
                              case 'There is no user record corresponding to this identifier. The user may have been deleted.':
                                SnackBar snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.redAccent,
                                  content: Text(
                                      'No user is register with this email',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                );
                                scaffoldKey.currentState.showSnackBar(snackBar);
                                break;
                              case 'The password is invalid or the user does not have a password.':
                                SnackBar snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.redAccent,
                                  content: Text('Invalid Password !!',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                );
                                scaffoldKey.currentState.showSnackBar(snackBar);
                                break;
                              case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
                                SnackBar snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.redAccent,
                                  content: Text(
                                    'No connection !',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                                scaffoldKey.currentState.showSnackBar(snackBar);
                                break;
                              // ...
                              default:
                                SnackBar snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.redAccent,
                                  content: Text('Invalid User credential !!',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                );
                                scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          }
                        }
                        if (user != null) {
                          final userid = FirebaseAuth.instance.currentUser.uid;
                          final data = await FirebaseFirestore.instance
                              .collection('accounts')
                              .doc(userid)
                              .get();
                          // print(data.data());
                          Account account = Account.fromJson(data.data());
                          LocalStorage localStorage = LocalStorage();
                          if (localStorage.prefs == null) {
                            localStorage.init();
                          }
                          await localStorage.setAccount(account);
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => HomePage(),
                            ),
                            (route) =>
                                false, //if you want to disable back feature set to false
                          );
                          setState(() {
                            showLoading = false;
                          });

                          debugPrint('Login');
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: screen.vertical(70),
                  ),
                  Text(
                    'Don\'t have account ?',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()));
                    },
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(color: Colors.green[200], fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
