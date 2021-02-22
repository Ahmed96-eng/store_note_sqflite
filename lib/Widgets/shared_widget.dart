import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';

class SharedWidget {
  static showToastMsg(message, {int time, fontSize = 16.0}) =>
      FlutterFlexibleToast.showToast(
        message: message,
        toastLength: Toast.LENGTH_SHORT,
        toastGravity: ToastGravity.BOTTOM,
        elevation: 10,
        textColor: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.5),
        timeInSeconds: time,
        fontSize: fontSize,
      );

  static showAlertDailog(
          {BuildContext context,
          String titlle,
          String message,
          String labelNo,
          String labelYes,
          Function onPressNo,
          Function onPressYes}) =>
      showDialog(
        context: context,
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.blue.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            ),
          ),
          child: AlertDialog(
            backgroundColor: Colors.amber.withOpacity(0.4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: new Text(
              titlle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
            content: new Text(
              message,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
            actions: <Widget>[
              FlatButton(
                shape: StadiumBorder(),
                color: Colors.white,
                child: new Text(
                  labelYes,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                onPressed: onPressYes,
              ),
              FlatButton(
                shape: StadiumBorder(),
                color: Colors.white,
                child: new Text(
                  labelNo,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                onPressed: onPressNo,
              ),
            ],
          ),
        ),
      );

  static BoxDecoration dialogDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.blueAccent[400],
          Colors.amber[300],
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
        stops: [0, 1],
      ),
    );
  }

  static LinearGradient splashgradient() {
    return LinearGradient(
      colors: [
        Colors.blueAccent[400],
        Colors.amber[300],
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
      stops: [0, 1],
    );
  }

  static BoxDecoration widgetDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.red.withOpacity(0.3),
          Colors.blueAccent.withOpacity(0.5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, 1],
      ),
      borderRadius: BorderRadius.circular(30),
    );
  }
}
