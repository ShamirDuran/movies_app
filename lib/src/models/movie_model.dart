class Movies {
  List<Movie> items = List();

  Movies();

  // Convierte el json en una lista de Movies
  Movies.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    items.addAll(jsonList.map((item) => Movie.fromJsonMap(item)).toList());
  }
}

class Movie {
  String uniqueId = "";
  double popularity;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<String> genres = List();
  String title;
  double voteAverage;
  int voteCount;
  String overview;
  String releaseDate;
  int runtime;

  Movie({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  // Convierte un item del map en una Movie
  Movie.fromJsonMap(Map<String, dynamic> json) {
    popularity = json["popularity"] / 1;
    voteCount = json["vote_count"];
    video = json["video"];
    posterPath = json["poster_path"];
    id = json["id"];
    adult = json["adult"];
    backdropPath = json["backdrop_path"];
    originalLanguage = json["original_language"];
    originalTitle = json["original_title"];
    title = json["title"];
    voteAverage = json["vote_average"] / 1;
    overview = json["overview"];
    releaseDate = json["release_date"];
  }

  getPosterImg() {
    if (posterPath != null) {
      return "https://image.tmdb.org/t/p/w500/$posterPath";
    } else {
      // no hay imagen en la api
      // return "https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png?format=jpg&quality=90&v=1530129081";
      return "https://wiz-crm.com/assets/img/placeholder.png";
    }
  }

  getBackgroundImg() {
    if (backdropPath != null) {
      return "https://image.tmdb.org/t/p/w500/$backdropPath";
    } else {
      // no hay imagen en la api
      return "https://wiz-crm.com/assets/img/placeholder.png";
    }
  }

  getRuntime() {
    if (runtime != null) {
      int h = 0, m = 0;

      while (runtime > 60) {
        runtime -= 60;
        h++;
      }

      m = runtime;

      return "${h}h  ${m}min";
    } else {
      return "No encontrada";
    }
  }
}