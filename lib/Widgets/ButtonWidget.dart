import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  String title;
  Function onPressed;
  ButtonWidget({this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.amber[300].withOpacity(0.6),
        border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
      ),
      child: FlatButton(
        child: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
        color: Colors.transparent,
        textColor: Colors.black,
      ),
    );
  }
}
