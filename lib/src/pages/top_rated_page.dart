import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:movies_app/src/widgets/movie_grid.dart';

class TopRatedPage extends StatefulWidget {
  @override
  _TopRatedPageState createState() => _TopRatedPageState();
}

class _TopRatedPageState extends State<TopRatedPage> {
  MoviesProvider _moviesProvider;

  @override
  void initState() {
    super.initState();
    _moviesProvider = MoviesProvider();
    _moviesProvider.getTopRated();
  }

  @override
  void dispose() {
    _moviesProvider.disposeTopRatedStrem();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _moviesProvider.topRatedStream,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData)
          return MovieGrid(
              movies: snapshot.data, nextPage: _moviesProvider.getTopRated);
        else
          return Center(child: CircularProgressIndicator());
      },
    );
  }
}
