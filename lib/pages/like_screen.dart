import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:imdb_task/box/boxes.dart';
import 'package:imdb_task/model/liked_movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeScreen extends StatefulWidget {
  LikeScreen({Key? key});
  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  var isDataLoaded = false;
  List<LikedMovie> likeMovieList = [];
  @override
  void initState() {
    getLikeMovie();
    super.initState();
  }

  getLikeMovie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final box = Boxes1.getData();
    final data = box.values.toList();
    final likedMovies =
        data.where((element) => element.email == prefs.get('email'));
    setState(() {
      likeMovieList = likedMovies.toList();
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Hive.box<LikedMovie>('liked_movies').clear();
            },
            icon: Icon(Icons.delete),
          ),
        ],
        backgroundColor: Colors.black.withOpacity(0.75),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.95),
        child: isDataLoaded
            ? likeMovieList.isEmpty
                ? Center(
                    child: Text(
                    'No like movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ))
                : ListView.builder(
                    itemCount: likeMovieList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final LikedMovie likedMovie = likeMovieList[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, top: 10),
                            color: Colors.transparent,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  'https://image.tmdb.org/t/p/w500${likedMovie.posterPath}',
                                  height: 160,
                                  width: 150,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        likedMovie.title.toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        likedMovie.release_date.toString(),
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        likedMovie.original_language.toString(),
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  '⭐ ️${likedMovie.vote_average.toString()}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.yellow),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    likedMovie.vote_count
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  )
            : Container(
                child: Center(
                  child: SpinKitCircle(
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
