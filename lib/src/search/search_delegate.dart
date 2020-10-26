import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  String selected = "";
  final moviesProvider = MoviesProvider();
  final movies = [];

  final _listController = ScrollController();
  final Function nextPage = () {};

  @override
  void close(BuildContext context, result) {
    _listController.dispose();
    super.close(context, result);
  }

  @override
  String get searchFieldLabel => "Buscar película";

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          // limpia el texto del search
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        // cierra el search
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultado que se van a mostrar
    return Center(
      child: _listResults(context),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: moviesProvider.getSearch(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          movies.clear();
          movies.addAll(snapshot.data);
          return _listResults(context);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _listResults(BuildContext context) {
    _listController.addListener(() {
      if (_listController.position.pixels >=
          _listController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return ListView(
      controller: _listController,
      children: movies.map((movie) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            clipBehavior: Clip.antiAlias,
            child: FadeInImage(
              image: NetworkImage(movie.getPosterImg()),
              placeholder: AssetImage("assets/img/no-image.jpg"),
              width: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(movie.title),
          subtitle: Text(movie.releaseDate ?? ""),
          onTap: () {
            Navigator.pushNamed(context, "detail", arguments: movie);
          },
        );
      }).toList(),
    );
  }
}
