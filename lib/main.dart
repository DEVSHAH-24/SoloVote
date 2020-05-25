import 'package:docogenproject/screens/election.dart';
import 'package:docogenproject/screens/login_screen.dart';
import 'package:docogenproject/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

     darkTheme: ThemeData(
       brightness: Brightness.light,
     ),
      debugShowCheckedModeBanner: false,
      title: 'SoloVote',
      home: WelcomeScreen(),
    //  theme: ThemeData.dark(),
    );

  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (context , AsyncSnapshot<FirebaseUser> snapshot){
          if(snapshot.hasData){
              FirebaseUser user = snapshot.data;
              if(user!= null){
                return ElectionScreen();
              }
          }else{
            return LoginScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}