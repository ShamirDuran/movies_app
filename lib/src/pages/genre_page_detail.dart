import 'package:flutter/material.dart';
import 'package:movies_app/src/models/genres_model.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:movies_app/src/widgets/movie_card.dart';

class GenrePageDetail extends StatefulWidget {
  final Genre genre;
  GenrePageDetail({@required this.genre});

  @override
  _GenrePageDetailState createState() => _GenrePageDetailState();
}

class _GenrePageDetailState extends State<GenrePageDetail> {
  MoviesProvider _moviesProvider;
  ScrollController _scrollController;
  int _crossCount = 3;

  @override
  void initState() {
    super.initState();
    _moviesProvider = MoviesProvider();
    _moviesProvider.getMoviesWithGenre(widget.genre.id.toString());
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _moviesProvider.getMoviesWithGenre(widget.genre.id.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _dimen = MediaQuery.of(context).size;
    if (_dimen.width >= 500 && _dimen.width <= 620)
      _crossCount = 4;
    else if (_dimen.width > 620) _crossCount = 5;

    print("Height: ${_dimen.height} - Widht: ${_dimen.width}");

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: Text(widget.genre.name),
        ),
        body: StreamBuilder(
          stream: _moviesProvider.genreStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return _genrePageDetailSection(snapshot.data);
            else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _genrePageDetailSection(List<Movie> movies) {
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossCount,
        childAspectRatio: 0.6,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);
      },
    );
  }
}
