import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movies_app/src/models/actors_model.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/actors_provider.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:movies_app/src/widgets/movie_horizontal.dart';

class MovieDetail extends StatelessWidget {
  final moviesProvider = MoviesProvider();

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: FutureBuilder(
        future: moviesProvider.getDetailsMovie(movie),
        builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                // appbar
                _crearAppBar(movie),
                // content
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 10.0),
                    _posterMovie(context, movie),
                    _genres(movie),
                    _description(movie, context),
                    _createCasting(movie),
                    _createSimilar(movie),
                  ]),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Scrollable AppBar
  Widget _crearAppBar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      // controla cuando se va a expandir. En false solo se expande al llegar al top, en true cuando se hace scroll hacia arriba
      floating: false,
      // pinned hace que se quede pegado al top cuando se hace scroll
      pinned: true,
      // controla el posicionamiento de los widgets. En este caso controla el titulo que sale en el appbar
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        collapseMode: CollapseMode.parallax,
        background: FadeInImage(
          image: NetworkImage(movie.getBackgroundImg()),
          placeholder: AssetImage("assets/img/loading.gif"),
          fadeInDuration: Duration(microseconds: 1000),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //Poster - title - calification sections
  Widget _posterMovie(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 7.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.av_timer),
                    SizedBox(width: 7.0),
                    Text(movie.getRuntime()),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 7.0),
                    Text(movie.releaseDate),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber[200]),
                    SizedBox(width: 7.0),
                    Text("${movie.voteAverage.toString()}/10",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    "${movie.voteCount} votos",
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Movie genders
  Widget _genres(Movie movie) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
      child: Wrap(children: movie.genres.map((e) => inputChip(e)).toList()),
    );
  }

  // Movie description section
  Widget _description(Movie movie, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Descripción", style: Theme.of(context).textTheme.headline6),
          SizedBox(height: 8.0),
          Text(movie.overview, textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  // Create actosrcasting section builder
  Widget _createCasting(Movie movie) {
    final actorProvider = ActorsProvider();
    return FutureBuilder(
      future: actorProvider.getCastMovie(movie),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _createActorsPageView(snapshot.data, context);
        } else {
          return Container(
            padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
            child: Container(
                margin: EdgeInsets.all(50.0),
                child: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }

  // Create actor casting section
  Widget _createActorsPageView(List<Actor> actors, BuildContext context) {
    if (actors.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 8.0),
                child: Text("Actores",
                    style: Theme.of(context).textTheme.headline6)),
            SizedBox(
              height: 180.0,
              child: PageView.builder(
                pageSnapping: false,
                controller:
                    PageController(initialPage: 1, viewportFraction: 0.3),
                itemCount: actors.length,
                itemBuilder: (context, index) =>
                    _actorCard(actors[index], context),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  // Create actor card
  Widget _actorCard(Actor actor, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: FadeInImage(
              image: NetworkImage(actor.getPhoto(), scale: 1.0),
              placeholder: AssetImage("assets/img/no-image.jpg"),
              fadeInDuration: Duration(microseconds: 1000),
              height: 150.0,
              width: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _createSimilar(Movie movie) {
    return FutureBuilder(
      future: moviesProvider.getSimilar(movie),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Movie> similar = snapshot.data;
          if (similar.isNotEmpty)
            return Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.black),
                  SizedBox(height: 20.0),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 8.0),
                    child: Text("Películas similares",
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  MovieHorizontal(movies: similar, nextPage: () {}),
                ],
              ),
            );
          else
            return Container();
        } else
          return Container(
              margin: EdgeInsets.all(100.0),
              child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget inputChip(String text) {
    return Container(
      margin: EdgeInsets.only(right: 6.0),
      child: InputChip(
        isEnabled: false,
        onPressed: () {},
        label: Text(text),
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
