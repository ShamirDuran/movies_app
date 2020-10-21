import 'package:flutter/material.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:movies_app/src/search/search_delegate.dart';
import 'package:movies_app/src/widgets/card_swiper_widget.dart';
import 'package:movies_app/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = MoviesProvider();

  final tabs = [
    "Inicio",
    "Populares",
    "Mejor valoradas",
    "Genero",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.indigoAccent,
          title: Text("Movie app",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () =>
                    showSearch(context: context, delegate: DataSearch())),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        // body: SafeArea(
        //   child: Container(
        //     child: ListView(
        //       children: [
        //         _swiperCards(),
        //         SizedBox(height: 20.0),
        //         _popular(context),
        //         SizedBox(height: 20.0),
        //       ],
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              _homeSection(context),
              Center(
                child: Text("Estamos en popu"),
              ),
              Center(
                child: Text("Estamos en mejor"),
              ),
              Center(
                child: Text("Estamos en cate"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeSection(BuildContext context) {
    return ListView(
      children: [
        _swiperCards(),
        SizedBox(height: 20.0),
        _popular(context),
        SizedBox(height: 20.0),
      ],
    );
  }

  // carousel now playing movies
  Widget _swiperCards() {
    return FutureBuilder(
      future: moviesProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          // snapshot.data es la lista de peliculas
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Text("Cartelera",
                    style: Theme.of(context).textTheme.headline5),
              ),
              CardSwiper(movies: snapshot.data),
            ],
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  // populares section
  Widget _popular(BuildContext context) {
    // Se puede agregar acá o en el widget padre
    moviesProvider.getPopular();

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 20.0, top: 25.0),
              child: Text("Populares",
                  style: Theme.of(context).textTheme.headline5)),
          SizedBox(height: 10.0),
          StreamBuilder(
            stream: moviesProvider.popularStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                    movies: snapshot.data, nextPage: moviesProvider.getPopular);
              } else {
                moviesProvider.getPopular();
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ],
      ),
    );
  }
}
