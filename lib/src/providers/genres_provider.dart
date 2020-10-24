import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/src/models/genres_model.dart';

class GenresProvider {
  String _apiKey = "2b38dd408053a7c28a76a3d0cb76700e";
  String _url = "api.themoviedb.org";
  String _language = "es-ES";

  List<Genre> _genre = List();

  final _genreStreamController = StreamController<List<Genre>>.broadcast();
  Function(List<Genre>) get genreSink => _genreStreamController.sink.add;
  Stream<List<Genre>> get genreStream => _genreStreamController.stream;
  void disposeGenreStream() {
    _genreStreamController?.close();
  }

  Future<List<Genre>> _processResponse(Uri url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final genres = Genres.fromJsonList(decodedData["genres"]);
      return genres.items;
    } else {
      print("Null request to $url");
      return null;
    }
  }

  Future<List<Genre>> getGenres() async {
    final url = Uri.https(_url, "3/genre/movie/list", {
      'api_key': _apiKey,
      'language': _language,
    });

    final resp = await _processResponse(url);
    _genre.addAll(resp);
    if (!_genreStreamController.isClosed) genreSink(_genre);
    return resp;
  }
}
