import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project/component/action_button.dart';
import 'package:project/component/text_field.dart';
import 'package:project/helper/firebase.dart';
//TODO remove all print statement
import 'package:project/helper/screen_size.dart';
import 'package:project/helper/validators.dart';
import 'package:project/modal/account.dart';
import 'package:project/pages/home_page.dart';

import 'login_page.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String password;
  String id;
  String name;
  String std = 'Nursery';
  List<String> stdList = [
    'Nursery',
    'LKG',
    'UKG',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  final formKey = GlobalKey<FormState>();
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
                    height: screen.vertical(100),
                  ),
                  Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 36),
                  ),
                  SizedBox(
                    height: screen.vertical(25),
                  ),
                  Text(
                    'Enter your email and password to Create account.',
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                  SizedBox(
                    height: screen.vertical(45),
                  ),
                  CustomTextField(
                    hintText: 'Name',
                    validator: nameValidator,
                    onChanged: (value) {
                      name = value;
                    },
                    textAlignment: TextAlign.start,
                    keyboard: TextInputType.emailAddress,
                    preffixWidget: Icon(
                      Icons.person_outlined,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(25),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Class',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  DropdownButtonFormField(
                    dropdownColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.lightBlueAccent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                            width: 0.0,
                            style: BorderStyle.none,
                            color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                            width: 0.0,
                            style: BorderStyle.none,
                            color: Colors.transparent),
                      ),
                    ),
                    value: std,
                    onChanged: (newValue) {
                      setState(() {
                        std = newValue;
                      });
                    },
                    items: stdList.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(
                          valueItem.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: screen.vertical(25),
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
                  CustomTextField(
                    hintText: 'Confirm Password',
                    validator: (value) =>
                        MatchValidator(errorText: 'Passwords do not match')
                            .validateMatch(value, password),
                    // onChanged: (value) {
                    //   password = value;
                    //   debugPrint(password);
                    // },
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
                    'Sign Up',
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        setState(() {
                          showLoading = true;
                        });
                        Authentication authentication = Authentication();
                        var newUser;
                        try {
                          newUser = await authentication.createUserInFirebase(
                              email, password);
                        } catch (e) {
                          setState(() {
                            showLoading = false;
                          });
                          if (Platform.isAndroid) {
                            switch (e.message) {
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
                                  content:
                                      Text('Email is already registered !!',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                );
                                scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          }
                          setState(() {
                            showLoading = false;
                          });
                        }
                        if (newUser != null) {
                          id = FirebaseAuth.instance.currentUser.uid;
                          Account account = Account(
                            email: email,
                            uid: id,
                            name: name,
                            std: std,
                          );

                          await authentication.saveDataInFirebase(account);
                          debugPrint('data Save');
                          await authentication.saveDataInLocalStorage(
                              account, password);
                          debugPrint("All done");
                          //TODO check here
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                          debugPrint('Sign Up');
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: screen.vertical(70),
                  ),
                  Text(
                    'Already have account?',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(
                    height: screen.vertical(10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'LOG IN',
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
