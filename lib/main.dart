import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_app/src/pages/home_page.dart';
import 'package:movies_app/src/pages/movie_detail.dart';

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
      theme: ThemeData(
        fontFamily: "ProximaNovaRegular",
        textTheme: TextTheme(
          headline5: TextStyle(
            fontFamily: "ProximaNovaBold",
            fontSize: 23.0,
          ),
          headline6: TextStyle(
            fontFamily: "ProximaNovaRegular",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: 'Películas',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        "/": (BuildContext context) => HomePage(),
        "detail": (BuildContext context) => MovieDetail(),
      },
    );
  }
}
