import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/widgets/movie_card.dart';

class MovieGrid extends StatefulWidget {
  final List<Movie> movies;
  final Function nextPage;

  MovieGrid({@required this.movies, @required this.nextPage});

  @override
  _MovieGridState createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        widget.nextPage();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _dimen = MediaQuery.of(context).size;
    int _crossCount = 3;

    if (_dimen.width >= 425 && _dimen.width <= 600)
      _crossCount = 4;
    else if (_dimen.width > 600) _crossCount = 5;

    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossCount,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.6,
      ),
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: widget.movies[index]);
      },
    );
  }
}
