import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_app/src/my_behavior.dart';
import 'package:movies_app/src/pages/movie_detail.dart';
import 'package:movies_app/src/pages/tab_nav.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      theme: ThemeData(
        fontFamily: "ProximaNovaRegular",
        textTheme: TextTheme(
          headline5: TextStyle(
            fontFamily: "ProximaNobaBold",
            fontSize: 21.0,
          ),
          headline6: TextStyle(
            fontFamily: "ProximaNovaRegular",
            fontWeight: FontWeight.w600,
          ),
          subtitle2: TextStyle(
            fontFamily: "ProximaNobaRegular",
          ),
        ),
      ),
      title: 'Películas',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        "/": (BuildContext context) => TabNav(),
        "detail": (BuildContext context) => MovieDetail(),
      },
    );
  }
}
