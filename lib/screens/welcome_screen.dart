import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'package:docogenproject/components/roundedbutton.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
       
        onPressed: () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AuthScreen();
                },
              ),
            );
          });
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
      // backgroundColor: Colors.blue[200],
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue[100], Colors.black])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  'THE ONLINE VOTING BALLOT',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              flex: 3,
            ),
            Expanded(
              child: Hero(
                  tag: 'vote', child: Image.asset('assets/online-voting.png'),),
            ),
            Expanded(
              child: Center(
                  child: Text(
                "Built on Flutter",
                style: TextStyle(fontSize: 18, color: Colors.white),
              )),
            )
          ],
        ),
      ),
    );
  }
}
