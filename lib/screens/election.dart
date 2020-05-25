import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docogenproject/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'end_screen.dart';

class ElectionScreen extends StatefulWidget {
  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _ds = Firestore.instance;
  bool isVoted = false;
  int votesSachin = 0;
  int votesKohli = 0;
  int votesDhoni = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black12,

      appBar: AppBar(
        title: Text('THE POLL'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 25,
        actions: <Widget>[
          FlatButton(
            color: Colors.white,
            child: Text(
              'Log out',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context, MaterialPageRoute(builder: (context) {
                return AuthScreen();
              }));
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/cricket.jpeg',
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              title: Text(
                'WHOM DO YOU CHOOSE FOR THE MOST VALUABLE PLAYER AWARD?',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              //leading: Image.asset('assets/cricket.jpeg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: Image.asset('assets/vk.jpeg'),
              trailing: IconButton(
                splashColor: Colors.amber,
                onPressed: () async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  isVoted = true;
                  await _ds
                      .collection("users")
                      .document(user.uid)
                      .collection("votes")
                      .add({
                    "Kohli": ++votesKohli,
                    "id": user.providerId,
                    "time": DateTime.now(),
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EndScreen()),
                  );
                },
                icon: Icon(Icons.check_circle_outline),
              ),
              title: Text(
                'Virat Kohli',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "Virat Kohli is an Indian cricketer who currently captains the India national team. A right-handed top-order batsman, Kohli is regarded as one of the best batsmen in the world. He plays for Royal Challengers Bangalore in the Indian Premier League (IPL), and has been the team's captain since 2013. Since October 2017, he has been the top-ranked ODI batsman in the world and is currently 2nd in Test rankings with 886 points. Among Indian batsmen, Kohli has the best ever Test rating (937 points), ODI rating (911 points) and T20I rating (897 points).",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: Image.asset('assets/sachin.jpeg'),
              trailing: IconButton(
                splashColor: Colors.amber,
                onPressed: () async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  isVoted = true;
                  await _ds
                      .collection("users")
                      .document(user.uid)
                      .collection("votes")
                      .add({
                    "Sachin": ++votesSachin,
                    "id": user.providerId,
                    "time": DateTime.now(),
                  });
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check_circle_outline),
              ),
              subtitle: Text(
                  "Sachin Ramesh Tendulkar  is an Indian former international cricketer and a former captain of the Indian national team. He is widely regarded as one of the greatest batsmen in the history of cricket. He is the highest run scorer of all time in International cricket. Considered as the world's most prolific batsman of all time, he is the only player to have scored one hundred international centuries, the first batsman to score a double century in a One Day International (ODI), the holder of the record for the most runs in both Test and ODI, and the only player to complete more than 30,000 runs in international cricket."),
              title: Text(
                'Sachin Tendulkar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ListTile(
              leading: Image.asset('assets/msd.jpg'),
              trailing: IconButton(
                splashColor: Colors.amber,
                onPressed: () async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  isVoted = true;
                  await _ds
                      .collection("users")
                      .document(user.uid)
                      .collection("votes")
                      .add({
                    "Dhoni": ++votesDhoni,
                    "id": user.providerId,
                    "time": DateTime.now(),
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EndScreen()),

                  );
                },
                icon: Icon(Icons.check_circle_outline),
              ),
              subtitle: Text(
                  "Mahendra Singh Dhoni , is an Indian international cricketer who captained the Indian national team in limited-overs formats from 2007 to 2016 and in Test cricket from 2008 to 2014. He is the only captain in the history of Cricket to win all ICC trophies. Under his captaincy, India won the 2007 ICC World Twenty20, the 2010 and 2016 Asia Cups, the 2011 ICC Cricket World Cup and the 2013 ICC Champions Trophy. A right-handed middle-order batsman and wicket-keeper, Dhoni is one of the highest run scorers in One Day Internationals (ODIs) with more than 10,000 runs scored and is considered an effective finisher in limited-overs formats. He is also regarded by some as one of the best wicket-keepers and captains in modern limited-overs international cricket."),
              title: Text(
                'MS Dhoni',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
