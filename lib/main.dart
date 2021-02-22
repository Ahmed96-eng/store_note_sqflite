import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sqflite_app/Providers/boolProvider.dart';
import 'package:sqflite_app/Widgets/shared_widget.dart';
import 'package:sqflite_app/screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BoolProvider>(
          create: (context) => BoolProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dashboard App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: SplashScreen(
          seconds: 4,
          navigateAfterSeconds: HomeScreen(),
          title: new Text(
            ' Welcome to Store Dashboard',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          image: new Image.asset(
            'images/store3.png',
          ),
          photoSize: 100,
          gradientBackground: SharedWidget.splashgradient(),
          loaderColor: Colors.redAccent,
        ),
      ),
    );
  }
}
