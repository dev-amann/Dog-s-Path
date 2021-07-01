import 'package:auth_buttons/auth_buttons.dart';
import 'package:dogs_path/Screens/home_screen.dart';
import 'package:dogs_path/Utils/custom_style.dart';
import 'package:dogs_path/Utils/dimensions.dart';
import 'package:dogs_path/Utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> _login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Strings.login, style: CustomStyle.headerStyle),
          SizedBox(height: Dimensions.marginSize),
          Text(Strings.signInWithYourFbAccount, style: CustomStyle.textStyle),
          SizedBox(height: Dimensions.marginSize),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FacebookAuthButton(
              onPressed: _login,
              darkMode: true,
              isLoading: false,
              style: const AuthButtonStyle(
                buttonType: AuthButtonType.secondary,
                elevation: 0,
                iconType: AuthIconType.outlined,
              ),
            ),
          )
        ],
      ),
    )));
  }
}
