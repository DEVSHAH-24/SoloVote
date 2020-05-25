import 'package:flutter/material.dart';
import 'login_screen.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:docogenproject/components/roundedbutton.dart';
import 'email_pass_signup.dart';
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.white, end: Colors.blueGrey)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'vote',
                  child: Container(
                    child: Image.asset('online-voting.png'),
                    height: 100,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TypewriterAnimatedTextKit(
                    text: ['Vote Now'],
                    speed: Duration(milliseconds: 500),
                    textStyle: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log in',
              color: Colors.black,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            RoundedButton(
              title: 'Register',
              color: Colors.blueGrey[700],
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmailPassSignupScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
