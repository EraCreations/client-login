import 'package:flutter/material.dart';

//Screen class is getting data about the screen resolution and this data is used for making responsive screens
class Screen {
  final BuildContext context;
  const Screen(this.context);

  double vertical(double height) =>
      MediaQuery.of(context).size.height * height / 1000;

  double horizontal(double width) =>
      MediaQuery.of(context).size.width * width / 100;
}
