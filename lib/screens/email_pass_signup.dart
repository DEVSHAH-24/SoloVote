
import 'package:flutter/material.dart';
import 'package:docogenproject/konstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'election.dart';
import 'package:docogenproject/components/roundedbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EmailPassSignupScreen extends StatefulWidget {
  @override
  _EmailPassSignupScreenState createState() => _EmailPassSignupScreenState();
}

class _EmailPassSignupScreenState extends State<EmailPassSignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  String email, password;
  bool showSpinner;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Sign up screen'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner = false,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'vote',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/online-voting.png',
                        color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16.0),
                child: TextField(
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
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16.0),
                child: TextField(

                  controller: _passwordController,
                  keyboardAppearance: Brightness.dark,
                  keyboardType: TextInputType.visiblePassword,
                  textAlign: TextAlign.left,
                  obscureText: true,
                  onChanged: (value) {
                    if (value.length > 6) {
                      password = value;
                    }
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password of min 6 characters',
                      labelText: 'Password'),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'SignUp using email',
                color: Colors.teal[300],
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  _signUp();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    if (email.isNotEmpty && password.length > 5) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
            _db.collection("users").document(user.user.uid).setData({
              "email": email,
              "lastSeen": DateTime.now(),
              "signInMethod": user.user.providerId,//to indicate signIn method of user
            });
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                backgroundColor: Colors.blue[100],
                title: Text('Welcome'),
                content: Text(
                    "You have been registered successfully"),
                actions: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: Colors.red,
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return ElectionScreen();
                      }));
                    },
                  ),
                ],
              );
            });
      }).catchError((e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                backgroundColor: Colors.blue[100],
                title: Text('Error'),
                content: Text("${e.message}"),
                actions: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: Colors.red,
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: Colors.blue[100],
              title: Text('Error'),
              content:
                  Text("Please provide email and password of min 6 characters"),
              actions: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  color: Colors.red,
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }
}
