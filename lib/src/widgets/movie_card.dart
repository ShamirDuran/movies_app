import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({@required this.movie});

  @override
  Widget build(BuildContext context) {
    return _movieCard(movie, context);
  }

  Widget _movieCard(Movie movie, BuildContext context) {
    final _card = Card(
      elevation: 0.0,
      child: Stack(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage("assets/img/no-image.jpg"),
                fadeInDuration: Duration(microseconds: 1000),
                fit: BoxFit.cover,
                height: 200.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 50.0,
              padding: EdgeInsets.all(2.3),
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber[200],
                    size: 17.0,
                  ),
                  Text(
                    movie.voteAverage.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "ProximaNovaBold",
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    final _card2 = Container(
      margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
      height: 220.0,
      child: Stack(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage("assets/img/no-image.jpg"),
                fadeInDuration: Duration(microseconds: 1000),
                fit: BoxFit.cover,
                height: 220.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 45.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.44),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  // bottomRight: Radius.circular(15.0),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber[200],
                    size: 17.0,
                  ),
                  Text(
                    movie.voteAverage.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "ProximaNovaBold",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      child: _card2,
      onTap: () => Navigator.pushNamed(context, "detail", arguments: movie),
    );
  }
}
