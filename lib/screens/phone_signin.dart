import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docogenproject/screens/election.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:docogenproject/components/roundedbutton.dart';

class SignInWithOTP extends StatefulWidget {
  @override
  _SignInWithOTPState createState() => _SignInWithOTPState();
}

class _SignInWithOTPState extends State<SignInWithOTP> {
  String _message;
  final Firestore _db = Firestore.instance;
  String _verificationId;
  bool _isSMSsent = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _smsController = TextEditingController();
  PhoneNumber _phoneNumber;

//  String phoneIsoCode;
  //  String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      body: AnimatedContainer(
        duration: Duration(milliseconds: 20000),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'vote',
                child: Container(
                  height: 200.0,
                  child: Image.asset('assets/online-voting.png',
                      color: Colors.lightGreen),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.lightGreen[100]),
              child: InternationalPhoneNumberInput(
                onInputChanged: (phoneNumbertxt) {
                  _phoneNumber = phoneNumbertxt;
                },
                //  formatInput: true,
                inputBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
            _isSMSsent== true   //do not forget to equal it to true.
                ? Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: _smsController,
                style: TextStyle(
                  color: Colors.pinkAccent,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "OTP here",
                  labelText: 'OTP',
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
            )
                : Container(),
            _isSMSsent== false
                ? InkWell(
                onTap: () {
                  setState(() {
                    _isSMSsent = true;
                  });

                  _verifyPhoneNumber();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.tealAccent],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  padding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Center(
                    child: Text(
                      'Send OTP',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ))
                : InkWell(
                onTap: () {
                  _signInPhoneNumber();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.tealAccent],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  padding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Center(
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );

  }

//Entire code below from official Firebase docs.
  void _verifyPhoneNumber() async{
    setState(()  {
      _message = '';
    });
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) {
        _auth.signInWithCredential(phoneAuthCredential);
        setState(() {
          _message = 'Received phone auth credential: $phoneAuthCredential';
          Navigator.push(context, MaterialPageRoute(
            builder: (context){
             return ElectionScreen();
            }
          ));
        });
      };
      final PhoneVerificationFailed verificationFailed = (
          AuthException authException) {
        setState(() {
          _message = 'Phone number verification failed. Code : ${authException
              .code}. Message: ${authException.message}';
        });
      };
      final PhoneCodeSent codeSent = (String verificationId,
          [int forceResendingToken ]) async {
        _verificationId = verificationId;
      };
      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (
          String verificationId) {
        _verificationId = verificationId;
      };
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumber.phoneNumber,
          timeout: const Duration(seconds: 120),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      }

    void _signInPhoneNumber() async {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _smsController.text,

      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      setState(() {
        if (user != null) {
          _db.collection("users").document(user.uid).setData({
              "phoneNumber": user.phoneNumber,
              "lastSeen": DateTime.now(),
              "signInMethod": user.providerId, 
          });

          _message = 'Successfully signed in, uid: ' + user.uid;
        } else {
          _message = 'Failed to sign in ';
        }
      });
      Navigator.pop(context);
    }


}
//  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
//    setState(() {
//      phoneNumber = number;
//      phoneIsoCode = isoCode;
//    });
//  }


//Refer firebase docs for reference for the verification function code