import 'package:flutter/material.dart';
import 'package:movies_app/src/models/genres_model.dart';
import 'package:movies_app/src/pages/genre_page_detail.dart';
import 'package:movies_app/src/providers/genres_provider.dart';

class GenrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GenresProvider _genresProvider = GenresProvider();

    _genresProvider.getGenres();

    return Container(
      child: StreamBuilder(
        stream: _genresProvider.genreStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData)
            return Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: _genresSection(snapshot.data),
            );
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _genresSection(List<Genre> genres) {
    return ListView.builder(
      itemCount: genres.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: ListTile(
            trailing: Icon(Icons.arrow_forward_ios,
                color: Colors.indigoAccent, size: 15.0),
            title: Text(genres[index].name),
            onTap: () {
              final route = MaterialPageRoute(
                  builder: (context) => GenrePageDetail(genre: genres[index]));
              Navigator.push(context, route);
            },
          ),
        );
      },
    );
  }
}
