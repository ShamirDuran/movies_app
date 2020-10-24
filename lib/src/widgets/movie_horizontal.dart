import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  MovieHorizontal({@required this.movies, @required this.nextPage});

  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: 180.0,
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
        // pageSnapping hace que se enfoque una tarjeta
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (context, index) => _card(context, movies[index]),
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          Hero(
            // enlaza en ambas vistas el widget
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage("assets/img/no-image.jpg"),
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(movie.title, overflow: TextOverflow.ellipsis)
        ],
      ),
    );

    return GestureDetector(
      child: card,
      onTap: () => Navigator.pushNamed(context, "detail", arguments: movie),
    );
  }
}
