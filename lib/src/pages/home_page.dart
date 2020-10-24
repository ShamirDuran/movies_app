import 'package:flutter/material.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:movies_app/src/widgets/card_swiper_widget.dart';
import 'package:movies_app/src/widgets/movie_horizontal.dart';
import 'package:movies_app/src/widgets/title_generator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MoviesProvider moviesProvider = MoviesProvider();

  @override
  void initState() {
    super.initState();
    moviesProvider.getPopular();
  }

  @override
  void dispose() {
    moviesProvider.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _swiperCards(),
        SizedBox(height: 10.0),
        _popular(context),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: moviesProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          // snapshot.data es la lista de peliculas
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: TitleGenerator(title: "Cartelera"),
                  ),
                ],
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

  Widget _popular(BuildContext context) {
    // Se puede agregar acá o en el widget padre
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 25.0, bottom: 5.0),
              child: TitleGenerator(title: "Populares")),
          SizedBox(height: 10.0),
          StreamBuilder(
            stream: moviesProvider.popularStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                    movies: snapshot.data, nextPage: moviesProvider.getPopular);
              } else {
                return Container(
                    padding: EdgeInsets.all(30.0),
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ],
      ),
    );
  }
}
