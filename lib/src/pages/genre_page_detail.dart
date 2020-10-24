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
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);
      },
    );
  }
}
