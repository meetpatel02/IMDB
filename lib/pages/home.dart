import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:imdb_task/box/boxes.dart';
import 'package:imdb_task/model/liked_movie.dart';
import 'package:imdb_task/model/movie_model.dart';
import 'package:imdb_task/pages/like_screen.dart';
import 'package:imdb_task/route/routes.dart';
import 'package:imdb_task/utils/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = true;
  bool isFirstLoad = true;
  int page = 1;
  List<Movie> movieList = [];
  List<LikedMovie> _likedMovies = [];
  final searchController = TextEditingController();
  var isLiked = false;
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getPopularMovies();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppString.movie),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LikeScreen()),
                  );
                },
                icon: Icon(Icons.favorite_border,color: Colors.white,)),
            IconButton(
                onPressed: () {
                  LogOut(context, 'Are you sure you want to logout!!', 'No',
                      'Yes');
                },
                icon: Icon(Icons.logout)),
          ],
          backgroundColor: Colors.black.withOpacity(0.75),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.black.withOpacity(0.95),
          child: isLoading && isFirstLoad
              ? Container(
                  child: SpinKitCircle(
                    color: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width - 20,
                                height: 50,
                                child: CupertinoSearchTextField(
                                  controller: searchController,
                                  onSuffixTap: () => _resetMovies(),
                                  prefixIcon: Container(),
                                  itemColor: Colors.white,
                                  onSubmitted: (_) {
                                    setState(() {
                                      movieList.clear();
                                      isFirstLoad = true;
                                      page = 1;
                                    });
                                    getPopularMovies();
                                  },
                                  style: TextStyle(color: Colors.white),
                                  placeholderStyle: TextStyle(
                                      color: Colors.grey, fontSize: 19),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              if (searchController.text.trim().isEmpty) {
                                return;
                              }
                              setState(() {
                                movieList.clear();
                                isFirstLoad = true;
                              });
                              getPopularMovies();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade700,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: movieList.length + (hasMore ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == movieList.length && hasMore) {
                                return Container(
                                  height: 50,
                                  child: Center(
                                    child: SpinKitCircle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              } else {

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 10, top: 10),
                                      color: Colors.transparent,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          movieList[index].imagePath == null
                                              ? Image(
                                                  image: AssetImage(
                                                      'assets/images/noimg.png'),
                                                  height: 160,
                                                  width: 150,
                                                  color: Colors.white,
                                                )
                                              : FadeInImage(
                                                  placeholder: AssetImage(
                                                    'assets/images/loader.gif',
                                                  ),
                                                  image: NetworkImage(
                                                      movieList[index]
                                                          .getPosterUrl()),
                                                  placeholderFilterQuality:
                                                      FilterQuality.high,
                                                  height: 160,
                                                  width: 150,
                                                ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  movieList[index]
                                                      .title
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  movieList[index]
                                                      .release_date
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  movieList[index]
                                                      .original_language
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            '⭐ ️${movieList[index].vote_average.toString()}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16)),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .yellow),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Text(
                                                              movieList[index]
                                                                  .vote_count
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    IconButton(
                                                        onPressed: () async {

                                                          // if(isLike){
                                                          //  await box.delete(index);
                                                          // }else{
                                                          //  await box.put(index, _likedMovies);
                                                          // }

                                                          addLikedMovie(
                                                              movieList[index]);
                                                        },
                                                        icon: Icon(
                                                          // Icons.favorite_border,color: Colors.white,
                                                          isLiked ? Icons.favorite : Icons.favorite_border,
                                                      color: isLiked ? Colors.yellow.shade700 : Colors.white,
                                                        ))
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
                              }
                            },
                            controller: _scrollController,
                          ),
                          if (movieList.isEmpty)
                            Center(
                                child: Text(
                              'No data found !!!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _loadLikedMovies() async {
    final likedMoviesBox = Boxes1.getData();
    final List<LikedMovie> likedMovies = likedMoviesBox.values.toList();
    setState(() {
      _likedMovies = likedMovies;
    });
  }
  Future<void> addLikedMovie(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final  LikedMovie likedMovie = LikedMovie(
      email: prefs.get('email'),
      id: movie.id,
      title: movie.title,
      posterPath: movie.imagePath,
      original_language: movie.original_language,
      release_date: movie.release_date,
      vote_average: movie.vote_average,
      vote_count: movie.vote_count,
    );
    final box = Boxes1.getData();
    if (!box.containsKey(movie.id)) {

      print(likedMovie.email);
      box.put(movie.id, likedMovie);
    } else {
      box.delete(movie.id);
    }
    _loadLikedMovies();
  }



  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!isLoading && hasMore) {
        getPopularMovies();
      }
    }
  }
  Future<void> getPopularMovies() async {
    setState(() {
      isLoading = true;
    });
    String? url;
    if (searchController.text.isEmpty) {
      url =
      'https://api.themoviedb.org/3/movie/popular?api_key=b4a549abb798b19dbb7e63335d135053&page=${movieList.length ~/ 20 + page}';
    } else {
      url =
      'https://api.themoviedb.org/3/search/movie?api_key=b4a549abb798b19dbb7e63335d135053&query=${searchController.text.trim()}&page=${movieList.length ~/ 20 + page}';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> results = jsonData['results'];

      List<Movie> movies = [];

      for (var result in results) {
        final movie = Movie.fromJson(result);
        movies.add(movie);
      }

      setState(() {
        if (isFirstLoad) {
          movieList = movies;
          isFirstLoad = false;
        } else {
          movieList.addAll(movies);
        }
        isLoading = false;
        hasMore = jsonData['page'] < jsonData['total_pages'];
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }
  Future<void> _resetMovies() async {
    if (searchController.text.trim().isEmpty) {
      return;
    }
    setState(() {
      searchController.clear();
      isLoading = true;
      hasMore = true;
      isFirstLoad = true;
      page = 1;
      movieList.clear();
    });

    await getPopularMovies();
  }

  void deleteall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // Hive.box<RegisterModel>('registerUser').clear();
  }

  void LogOut(BuildContext context, String subtitlemessage,
      String buttonoption1, String buttonoption2) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 30,
            height: 230,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border:
                            Border.all(color: Colors.yellow.shade700, width: 5),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 25, right: 10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.yellow.shade700),
                      child: Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 20),
                  child: Text(
                    subtitlemessage,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0XFF6a6a6a),
                        decoration: TextDecoration.none),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 140,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.yellow.shade700,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(buttonoption1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade700,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            deleteall();
                            Get.toNamed(MyRoutes.signInRoute);
                          },
                          child: Text(buttonoption2,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }


}
