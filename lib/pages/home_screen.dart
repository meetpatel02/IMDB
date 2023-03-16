import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:imdb_task/model/movie_model.dart';
import 'package:imdb_task/utils/app_string.dart';
import '../model/register_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _movies = [];
  bool _isLoading = true;
  bool _isBottomLoading = false;
  bool hasMore = true;
  int _page = 1;
  int _page1 = 1;
  int totalPage = 37472;
  final _scrollController = ScrollController();
final searchController = TextEditingController();

  Future<void> _fetchMovies() async {
    if(_isBottomLoading)return;
    _isBottomLoading = true;
    const limit = 20;
    String? url;
    if (searchController.text.isEmpty) {
      url =
      'https://api.themoviedb.org/3/movie/popular?page=$_page&api_key=b4a549abb798b19dbb7e63335d135053';
    } else {
      url =
      'https://api.themoviedb.org/3/search/movie?page=$_page&api_key=b4a549abb798b19dbb7e63335d135053&query=${searchController.text.trim()}';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      // final  results1 = data['total_pages'];
      _movies.addAll(results.map((e) => Movie.fromJson(e)));
      setState(() {

        _page++;
        _isLoading = false;
        _isBottomLoading = false;

        if(_movies.length < _page){
          hasMore = false;
          _isLoading = false;
          _isBottomLoading = true;
        }
      });

    }
  }


  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        _fetchMovies();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
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
          _isLoading
              ? Center(
            child: SpinKitCircle(
              color: Colors.blue,
            ),
          )
              :
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
                            prefixIcon: Container(),
                            itemColor: Colors.white,
                            onSubmitted: (_) {
                              setState(() {
                                _movies.clear();
                                _isLoading = true;
                                _page = 1;
                              });
                                _fetchMovies();
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
                          _movies.clear();
                          _isLoading = true;
                          _page = 1;
                        });
                        _fetchMovies();
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
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      itemCount: _movies.length +  1,
                      itemBuilder: (context, index) {
                        if (index < _movies.length) {
                          final movie = _movies[index];
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
                                    movie.imagePath == null?
                                    Image(
                                      image: AssetImage('assets/images/noimg.png'),
                                      height: 160,
                                      width: 150,
                                      color: Colors.white,
                                    ) :
                                    Image(
                                      image: NetworkImage(movie.getPosterUrl()),
                                      height: 160,
                                      width: 150,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title.toString(),
                                            style: const TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            movie.release_date.toString(),
                                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            movie.original_language.toString(),
                                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                                          ),
                                          Row(
                                            children: [
                                              Text('⭐ ️${movie.vote_average.toString()}',
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
                                                    movie.vote_count.toString(),
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
                        } else if(_movies.isEmpty ){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('No records found !!!',style: TextStyle(color: Colors.white),),
                            ],
                          );
                        }
                        else {
                          return
                            hasMore  ?
                            Container(
                            height: 50,
                            child: Center(
                              child: SpinKitCircle(
                                color: Colors.white,
                              ),
                            ),
                          ): Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('No records found !!!',style: TextStyle(color: Colors.white),),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void deleteall() async {
    Hive.box<RegisterModel>('registerUser').clear();
  }
}