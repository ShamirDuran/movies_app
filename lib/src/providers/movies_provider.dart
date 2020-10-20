import 'dart:async';
import 'dart:convert';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apiKey = "2b38dd408053a7c28a76a3d0cb76700e";
  String _url = "api.themoviedb.org";
  String _language = "es-ES";

  int _popularesPage = 0;
  bool _loading = false;

  List<Movie> _popular = List();

  /// El broadcast permite que tenga varios lugares escuchando.
  /// Esto seria la representación de una tuberia
  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  /// Permite insertar información. <br>
  /// Solo recibe listas de peliculas!!!
  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;

  /// Permite obtener o escuchar información
  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  /// Cierra la tuberia, Stream.
  void disposeStreams() {
    _popularStreamController?.close();
  }

  // hacer la peticion a la api mediante la urñ
  Future<List<Movie>> _processResponse(Uri url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final movies = Movies.fromJsonList(decodedData["results"]);
      return movies.items;
    } else {
      print("Null request to $url");
      return null;
    }
  }

  // obtener peliculas en cine
  Future<Movie> getDetailsMovie(Movie movie) async {
    final url = Uri.https(_url, "3/movie/${movie.id}", {
      'api_key': _apiKey,
      'language': _language,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      movie.runtime = decodedData["runtime"];
      movie.genres.clear();
      List<dynamic> genres = decodedData["genres"];
      genres.forEach((element) {
        movie.genres.add(element["name"]);
      });

      return movie;
    } else {
      print("Null request to $url");
      return null;
    }
  }

  // obtener peliculas en cine
  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, "3/movie/now_playing", {
      'api_key': _apiKey,
      'language': _language,
    });
    return await _processResponse(url);
  }

  // obtener peliculas de acuerdo a la busqueda
  Future<List<Movie>> getSearch(String query) async {
    final url = Uri.https(_url, "3/search/movie", {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    return await _processResponse(url);
  }

  // obtener peliculas populares
  Future<List<Movie>> getPopular() async {
    // Esto hace que no se ejecute varias veces el mismo codigo mientras este la bandera levantada
    if (_loading) return [];
    _loading = true;
    _popularesPage++;

    // print("Cargando siguientes...pag: $_popularesPage");

    final url = Uri.https(_url, "3/movie/popular", {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString(),
    });

    final resp = await _processResponse(url);

    _popular.addAll(resp);
    // Se agrega la lista de peliculas al stream
    popularSink(_popular);

    // Se quita la bandera de loading
    _loading = false;
    return resp;
  }
}
