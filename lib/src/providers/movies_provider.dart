import 'dart:async';
import 'dart:convert';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apiKey = "2b38dd408053a7c28a76a3d0cb76700e";
  String _url = "api.themoviedb.org";
  String _language = "es-ES";

  bool _loading = false;
  int _popularPage = 0;
  List<Movie> _popular = List();

  bool _loadingTop = false;
  int _topRatedPage = 0;
  List<Movie> _topRated = List();

  bool _loadingGenre = false;
  int _genrePage = 0;
  List<Movie> _genre = List();

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

  final _topRatedController = StreamController<List<Movie>>.broadcast();
  Function(List<Movie>) get topRatedSink => _topRatedController.sink.add;
  Stream<List<Movie>> get topRatedStream => _topRatedController.stream;
  void disposeTopRatedStrem() {
    _topRatedController?.close();
  }

  final _genreStreamController = StreamController<List<Movie>>.broadcast();
  Function(List<Movie>) get genreSink => _genreStreamController.sink.add;
  Stream<List<Movie>> get genreStream => _genreStreamController.stream;
  void disposeGenreStream() {
    _genreStreamController?.close();
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
    List<Movie> resp = await _processResponse(url);
    resp.forEach((movie) => movie.uniqueId = "${movie.id}-playing");

    return resp;
  }

  // obtener peliculas de acuerdo a la busqueda
  Future<List<Movie>> getSearch(String query) async {
    final url = Uri.https(_url, "3/search/movie", {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    List<Movie> resp = await _processResponse(url);
    resp.forEach((movie) => movie.uniqueId = "${movie.id}-search");

    return resp;
  }

  // obtener peliculas populares
  Future<List<Movie>> getPopular() async {
    // Esto hace que no se ejecute varias veces el mismo codigo mientras este la bandera levantada
    if (_loading) return [];
    _loading = true;
    _popularPage++;

    print("call getPopular");

    final url = Uri.https(_url, "3/movie/popular", {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularPage.toString(),
    });

    List<Movie> resp = await _processResponse(url);
    resp.forEach((movie) => movie.uniqueId = "${movie.id}-popular");

    _popular.addAll(resp);
    // Se agrega la lista de peliculas al stream
    if (!_popularStreamController.isClosed) popularSink(_popular);

    // Se quita la bandera de loading
    _loading = false;
    return resp;
  }

  Future<List<Movie>> getTopRated() async {
    if (_loadingTop) return [];
    _loadingTop = true;
    _topRatedPage++;

    print("call getTopRated");

    final url = Uri.https(_url, "3/movie/top_rated", {
      'api_key': _apiKey,
      'language': _language,
      'page': _topRatedPage.toString(),
    });

    List<Movie> resp = await _processResponse(url);
    resp.forEach((movie) => movie.uniqueId = "${movie.id}-top");
    _topRated.addAll(resp);
    if (!_topRatedController.isClosed) topRatedSink(_topRated);
    _loadingTop = false;
    return resp;
  }

  Future<List<Movie>> getMoviesWithGenre(String genreId) async {
    if (_loadingGenre) return [];
    _loadingGenre = true;
    _genrePage++;

    print("call getMoviesWithGenre");

    final url = Uri.https(_url, "3/discover/movie", {
      'api_key': _apiKey,
      'language': _language,
      'include_adult': "true",
      'include_video': "false",
      'page': _genrePage.toString(),
      'with_genres': genreId,
    });

    List<Movie> resp = await _processResponse(url);
    resp.forEach((movie) => movie.uniqueId = "${movie.id}-genre");
    _genre.addAll(resp);
    if (!_genreStreamController.isClosed) genreSink(_genre);
    _loadingGenre = false;
    return resp;
  }

  // obtener peliculas populares
  Future<List<Movie>> getSimilar(Movie movie) async {
    final url = Uri.https(_url, "3/movie/${movie.id}/similar", {
      'api_key': _apiKey,
      'language': _language,
    });

    List<Movie> resp = await _processResponse(url);
    resp.forEach((movie) => movie.uniqueId = "${movie.id}-similar");

    return resp;
  }
}
