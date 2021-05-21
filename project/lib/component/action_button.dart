import 'package:flutter/material.dart';
import 'package:project/helper/screen_size.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String buttonName;

  Button(this.buttonName, {@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scale = Screen(context);
    return FlatButton(
      onPressed: onPressed,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: scale.horizontal(4), vertical: scale.horizontal(4)),
          child: Text(
            buttonName,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(scale.horizontal(2.4)),
        side: BorderSide.none,
      ),
    );
  }
}
