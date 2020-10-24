import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_app/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    return _swiperStack(context);
  }

  Widget _swiperStack(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Swiper(
        itemCount: movies.length,
        itemWidth: _screenSize.width * 0.55,
        itemHeight: _screenSize.height * 0.45,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {
          // Se genera un tag unico para evitar errores entre los hero
          return _gridSwiper(movies[index], context);
        },
      ),
    );
  }

  Widget _gridSwiper(Movie movie, BuildContext context) {
    return Hero(
      tag: movie.uniqueId,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, "detail", arguments: movie),
          child: FadeInImage(
            image: NetworkImage(movie.getPosterImg()),
            placeholder: AssetImage("assets/img/no-image.jpg"),
            fadeInDuration: Duration(milliseconds: 400),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
