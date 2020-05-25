//import 'dart:math';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'phone_signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:docogenproject/components/roundedbutton.dart';
import 'package:docogenproject/konstants.dart';
import 'election.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Firestore _db = Firestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String email;
  String password;
  bool showSpinner;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner = false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'vote',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/online-voting.png',
                        color: Colors.lightBlue),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  controller: _emailController,
                  keyboardAppearance: Brightness.dark,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      email = value;
                    }
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email', labelText: 'Email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _passwordController,
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.left,
                obscureText: true,
                onChanged: (value) {
                  if (value.isNotEmpty) password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password', labelText: 'Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log in',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  _signIn();
                  setState(() {
                    showSpinner = true;
                  });

                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  try {
                    if (user != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ElectionScreen();
                      }));
                    }
                    showSpinner = false;
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SignInWithOTP();
                        }));
                      },
                      icon: Icon(
                        Icons.phone,
                        color: Colors.green,
                      ),
                      label: Text(
                        'Sign in using Phone',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    FlatButton.icon(
                      onPressed: () {
                        _signInUsingGoogle();

                      },
                      icon: Icon(FontAwesomeIcons.google, color: Colors.red),
                      label: Text(
                        'Sign in using Gmail',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   _signInUsingGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("signed in" + user.displayName);

      if (user != null) {
        _db.collection("users").document(user.uid).setData({
          "displayName": user.displayName,
          "email": user.email,
          "photoUrl": user.photoUrl,
          "lastSeen": DateTime.now(), //imp . not a user 's property
          "signInMethod": user.providerId,

        });

      }
      Navigator.push(context,MaterialPageRoute(builder: (context){
        return ElectionScreen();
      }));
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: Colors.blue[100],
              title: Text('Error'),
              content: Text('${e.message}'),
              actions: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  color: Colors.red,
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  void _signIn() async {
//    email = _emailController.text.trim();
//    password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {

        _db.collection("users").document(user.user.uid).setData({
          "email": email,
          "lastSeen": DateTime.now(),
          "signInMethod": user.user.providerId,
        }

        ).catchError((e) {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  backgroundColor: Colors.blue[100],
                  title: Text('Error'),
                  content: Text('${e.message}'),
                  actions: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      color: Colors.red,
                      child: Text('Cancel'),
                      onPressed: () {

                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                );
              });
        });
      });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: Colors.blue[100],
              title: Text('Error'),
              content: Text('Both fields are mandatory'),
              actions: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  color: Colors.red,
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  color: Colors.blue,
                  child: Text('OK'),
                  onPressed: () {
                    _emailController.text = '';
                    _passwordController.text = '';
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
  }
}
