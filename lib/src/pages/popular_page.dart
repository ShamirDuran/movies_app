import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:movies_app/src/widgets/movie_grid.dart';

class PopularPage extends StatefulWidget {
  @override
  _PopularPageState createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  MoviesProvider _moviesProvider;

  @override
  void initState() {
    super.initState();
    _moviesProvider = MoviesProvider();
    _moviesProvider.getPopular();
  }

  @override
  void dispose() {
    _moviesProvider.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _moviesProvider.popularStream,
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData)
            return MovieGrid(
                movies: snapshot.data, nextPage: _moviesProvider.getPopular);
          else
            return Container(child: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
