import 'package:flutter/material.dart';
import 'package:movies_app/src/models/actors.model.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/actors.provider.dart';

class MovieDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // appbar
          _crearAppBar(movie),
          // content
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0),
              _posterMovie(context, movie),
              _description(movie),
              _description(movie),
              _description(movie),
              _description(movie),
              _createCasting(movie),
            ]),
          ),
        ],
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
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
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
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
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
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 5.0),
                Text(movie.releaseDate,
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellowAccent),
                    SizedBox(width: 5.0),
                    Text("${movie.voteAverage.toString()}/10",
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Movie description section
  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
      child: Text(movie.overview, textAlign: TextAlign.justify),
    );
  }

  // Create actosrcasting section builder
  Widget _createCasting(Movie movie) {
    final actorprovider = ActorsProvider();
    return FutureBuilder(
      future: actorprovider.getCastMovie(movie),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _createActorsPageView(snapshot.data, context);
        } else {
          return Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  // Create actor casting section
  Widget _createActorsPageView(List<Actor> actors, BuildContext context) {
    if (actors.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 8.0),
              child: Text("Actores",
                  style: Theme.of(context).textTheme.headline6)),
          SizedBox(
            height: 240.0,
            child: PageView.builder(
              pageSnapping: false,
              controller: PageController(initialPage: 1, viewportFraction: 0.3),
              itemCount: actors.length,
              itemBuilder: (context, index) =>
                  _actorCard(actors[index], context),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  // Create actor card
  Widget _actorCard(Actor actor, BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
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
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 5.0),
          Text(
            actor.character,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
