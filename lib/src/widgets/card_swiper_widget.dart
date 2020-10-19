import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_app/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      // usa todo el ancho disponible
      padding: EdgeInsets.only(top: 20.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          // Se genera un tag unico para evitar errores entre los hero
          movies[index].uniqueId = '${movies[index].id}-card';
          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              // Aplica el efecto de on tap a las card
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, "detail",
                    arguments: movies[index]),
                child: FadeInImage(
                  image: NetworkImage(movies[index].getPosterImg()),
                  placeholder: AssetImage("assets/img/no-image.jpg"),
                  fadeInDuration: Duration(milliseconds: 400),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
        itemWidth: _screenSize.width * 0.50,
        itemHeight: _screenSize.height * 0.43,
        layout: SwiperLayout.STACK,
      ),
    );
  }
}