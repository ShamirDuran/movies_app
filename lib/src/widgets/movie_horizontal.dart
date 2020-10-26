import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  MovieHorizontal({@required this.movies, @required this.nextPage});

  @override
  Widget build(BuildContext context) {
    final _dimen = MediaQuery.of(context).size;
    double _viewPort = 0.3;
    int _initialPage = 1;

    if (_dimen.width >= 425 && _dimen.width <= 600) {
      _viewPort = 0.25;
      _initialPage = 2;
    } else if (_dimen.width > 600) {
      _viewPort = 0.2;
      _initialPage = 2;
    }

    // final _pageController = PageController(
    //   initialPage: 1,
    //   // viewportFraction: 0.3,
    //   viewportFraction: _viewPort,
    // );

    // return Container(
    //   height: 180.0,
    //   child: PageView.builder(
    //     physics: BouncingScrollPhysics(),
    //     // pageSnapping hace que se enfoque una tarjeta
    //     pageSnapping: false,
    //     controller: _pageController,
    //     itemCount: movies.length,
    //     itemBuilder: (context, index) => _card(context, movies[index]),
    //   ),
    // );

    final _pageController = ScrollController();

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
      print("scroll off");
    });

    return Container(
      height: 190.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) =>
            _card(context, movies[index]),
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
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage("assets/img/no-image.jpg"),
                fadeInDuration: Duration(milliseconds: 200),
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          SizedBox(
            width: 100.0,
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );

    return GestureDetector(
      child: card,
      onTap: () => Navigator.pushNamed(context, "detail", arguments: movie),
    );
  }
}
