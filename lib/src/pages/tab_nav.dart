import 'package:flutter/material.dart';
import 'package:movies_app/src/pages/genre_page.dart';
import 'package:movies_app/src/pages/home_page.dart';
import 'package:movies_app/src/pages/popular_page.dart';
import 'package:movies_app/src/pages/top_rated_page.dart';
import 'package:movies_app/src/search/search_delegate.dart';

class TabNav extends StatelessWidget {
  final tabs = [
    "Inicio",
    "Populares",
    "Mejor valoradas",
    "Genero",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.indigoAccent,
            title: Text("Movie app",
                style: TextStyle(
                    color: Colors.white, fontFamily: "RobotoBold")),
            actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () =>
                      showSearch(context: context, delegate: DataSearch())),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelStyle: Theme.of(context).textTheme.subtitle2,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.5, color: Colors.white),
              ),
              isScrollable: true,
              tabs: [
                for (final tab in tabs) Tab(text: tab),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomePage(),
              PopularPage(),
              TopRatedPage(),
              GenrePage(),
            ],
          ),
        ),
      ),
    );
  }
}
