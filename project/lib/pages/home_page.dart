import 'package:flutter/material.dart';
import 'package:project/component/action_button.dart';
import 'package:project/helper/firebase.dart';
import 'package:project/pages/login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: Button(
              'Log Out',
              onPressed: () async {
                //add this line to your logout button for easy logging out
                Authentication authentication = Authentication();
                await authentication.logoutUser();
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                  (route) =>
                      false, //if you want to disable back feature set to false
                );
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
