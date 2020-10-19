import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  String selected = "";
  final moviesProvider = MoviesProvider();
  final movies = [];

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
    // Son las sugerencias que aparecen cuando la persona escribe

    // ************* CODIGO DE EJEMPLO LOCAL ********************

    // final listaSugerida = (query.isEmpty)
    //     ? moviesRecents
    //     : movies.where((p) => p.toLowerCase().startsWith(query)).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[index]),
    //       onTap: () {
    //         selected = listaSugerida[index];
    //         showResults(context);
    //       },
    //     );
    //   },
    // );

    // ************* CODIGO USANDO API **************

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
    return ListView(
      children: movies.map((movie) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
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
            close(context, null);
            Navigator.pushNamed(context, "detail", arguments: movie);
          },
        );
      }).toList(),
    );
  }
}
