import 'package:docogenproject/screens/welcome_screen.dart';
import 'package:flutter/material.dart';



class EndScreen extends StatefulWidget {
  @override
  _EndScreenState createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        child: Text('EXIT',style: TextStyle(fontWeight: FontWeight.bold),),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return WelcomeScreen();
          }));
        },
      ),
      backgroundColor: Colors.blueGrey,
      body: Padding(

        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(

            child: Text('Thank you, your vote has been recorded',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}
