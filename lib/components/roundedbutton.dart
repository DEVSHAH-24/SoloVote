import 'package:flutter/material.dart';



class RoundedButton extends StatelessWidget {
  RoundedButton({this.title,this.color,@required this.onPressed}) ;
  final String title;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        shadowColor: Colors.black,
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(40.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
