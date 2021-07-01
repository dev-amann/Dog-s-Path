import 'dart:async';

import 'package:dogs_path/Utils/custom_style.dart';
import 'package:dogs_path/Utils/dimensions.dart';
import 'package:dogs_path/Utils/strings.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                "assets/dog.gif",
                height: 125.0,
                width: 125.0,
              ),
            ),
            SizedBox(height: Dimensions.marginSize),
            Text(Strings.appName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.extraLargeTextSize)),
            SizedBox(height: Dimensions.marginSize),
            Text('by', style: CustomStyle.textStyle),
            SizedBox(height: Dimensions.marginSize),
            Text(Strings.virtouStack, style: CustomStyle.headerStyle)
          ],
        ),
      ),
    );
  }
}
