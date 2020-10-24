import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/src/models/actors_model.dart';
import 'package:movies_app/src/models/movie_model.dart';

class ActorsProvider {
  String _apiKey = "2b38dd408053a7c28a76a3d0cb76700e";
  String _url = "api.themoviedb.org";

  Future<List<Actor>> _processResponse(Uri url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final cast = Cast.fromJsonList(decodedData["cast"]);
      return cast.actors;
    } else {
      return null;
    }
  }

  Future<List<Actor>> getCastMovie(Movie movie) async {
    final url =
        Uri.https(_url, "3/movie/${movie.id}/credits", {'api_key': _apiKey});
    return await _processResponse(url);
  }
}
