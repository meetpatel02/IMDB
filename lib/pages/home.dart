import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:imdb_task/model/movie_model.dart';
import 'package:imdb_task/model/register_model.dart';
import 'package:imdb_task/utils/app_string.dart';


class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = true;
  bool isFirstLoad = true;
  List<Movie> movieList = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getPopularMovies();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
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
      'https://api.themoviedb.org/3/movie/popular?api_key=b4a549abb798b19dbb7e63335d135053&page=${movieList.length ~/ 20 + 1}';
    } else {
      url =
      'https://api.themoviedb.org/3/search/movie?api_key=b4a549abb798b19dbb7e63335d135053&query=${searchController.text.trim()}&page=${movieList.length ~/ 20 + 1}';
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
    setState(() {
      isLoading = true;
      hasMore = true;
      isFirstLoad = true;
      movieList.clear();
    });

    await getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.movie),
        actions: [
          IconButton(
              onPressed: () {
                deleteall();
              },
              icon: Icon(Icons.logout)),
        ],
        backgroundColor: Colors.black.withOpacity(0.75),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.black.withOpacity(0.95),
        child:
        isLoading && isFirstLoad
            ? const Center(
          child: SpinKitCircle(
            color: Colors.white,
          ),
        ):
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 50,
                        child: CupertinoSearchTextField(
                          controller: searchController,
                          onSuffixTap: ()=>_resetMovies(),
                          prefixIcon: Container(),
                          itemColor: Colors.white,
                          onSubmitted: (_) {
                            setState(() {
                              movieList.clear();
                              isLoading = true;
                            });
                            getPopularMovies();
                          },
                          style: TextStyle(color: Colors.white),
                          placeholderStyle:
                          TextStyle(color: Colors.grey, fontSize: 19),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                          ),
                        )),
                  ),
                  SizedBox(width: 10,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        movieList.clear();
                        isLoading = true;
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
                      child: Center(child: Icon(Icons.search,color: Colors.white,size: 30,),),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: movieList.length + (hasMore ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == movieList.length && hasMore) {
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: SpinKitCircle(color: Colors.white,),
                      ),
                    );
                  } else {
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
                              movieList[index].imagePath == null?
                              Image(
                                image: AssetImage('assets/images/noimg.png'),
                                height: 160,
                                width: 150,
                                color: Colors.white,
                              ) :
                              Image(
                                image: NetworkImage(movieList[index].getPosterUrl()),
                                height: 160,
                                width: 150,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movieList[index].title.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      movieList[index].release_date.toString(),
                                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      movieList[index].original_language.toString(),
                                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        Text('⭐ ️${movieList[index].vote_average.toString()}',
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 16)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(color: Colors.yellow),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Text(
                                              movieList[index].vote_count.toString(),
                                              style: const TextStyle(
                                                  fontSize: 15, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )
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
            ),

          ],
        ),
      ),
    );
  }
  void deleteall() async {
    Hive.box<RegisterModel>('registerUser').clear();
  }
}
