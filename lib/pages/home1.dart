//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../model/movie_model.dart';
//
//
//
// class MyData {
//   final String title;
//   final String subtitle;
//
//   MyData({required this.title, required this.subtitle});
// }
// class DataModel {
//   final int id;
//   final String title;
//   final String subtitle;
//
//   DataModel({required this.id, required this.title, required this.subtitle});
//
//   factory DataModel.fromJson(Map<String, dynamic> json) {
//     return DataModel(
//       id: json['id'],
//       title: json['title'],
//       subtitle: json['subtitle'],
//     );
//   }
// }
//
// class MyHomePage1 extends StatefulWidget {
//   @override
//   _MyHomePage1State createState() => _MyHomePage1State();
// }
//
// class _MyHomePage1State extends State<MyHomePage1> {
//   List<Movie> _dataList = [];
//   bool _hasMoreData = true;
//   bool _isLoading = false;
//   final TextEditingController _searchController = TextEditingController();
//   int _pageNumber = 1;
//   int _currentPage = 1;
//   int _perPage = 20;
//   String? _searchQuery = '';
//
//   final _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//     _loadMoreData();
//     _searchData();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             hintText: 'Search movies...',
//             hintStyle: TextStyle(color: Colors.white),
//             suffixIcon: IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 _searchData();
//               },
//             ),
//           ),
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: _buildListView(),
//     );
//   }
//   Widget _buildListView() {
//     return ListView.builder(
//       itemCount: _dataList.length + 1, // Add 1 for the loading indicator
//       itemBuilder: (context, index) {
//         if (index == _dataList.length && _hasMoreData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (index == _dataList.length && !_hasMoreData) {
//           return SizedBox.shrink(); // Return an empty container when all search results have been displayed
//         } else {
//           final item = _dataList[index];
//           return ListTile(
//             title: Text(item.title.toString()),
//             subtitle: Text(item.overview.toString()),
//           );
//         }
//       },
//       controller: _scrollController,
//       physics: BouncingScrollPhysics(),
//     );
//   }
//
//
//
//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       if (_hasMoreData && !_isLoading) {
//         _loadMoreData();
//       } else if (!_hasMoreData) {
//         _scrollController.removeListener(_scrollListener);
//       }
//     }
//   }
//
//   void _loadMoreData() async {
//     final response = await http.get(Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=b4a549abb798b19dbb7e63335d135053&page=$_pageNumber&per_page=$_perPage'));
//
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//
//       if (jsonResponse['results'].length == 0) {
//         setState(() {
//           _hasMoreData = false; // Set _hasMoreData to false when all search results have been displayed
//         });
//       } else {
//         final newData = jsonResponse['results'].map((item) => DataModel.fromJson(item)).toList();
//         setState(() {
//           _dataList.addAll(newData);
//           _currentPage++;
//         });
//       }
//     } else {
//       throw Exception('Failed to load data from API');
//     }
//   }
//
//
//   void _searchData() async {
//     if (_searchController.text.trim().isNotEmpty) {
//       setState(() {
//         _isLoading = true;
//         _dataList.clear();
//         _currentPage = 1;
//         _searchQuery = _searchController.text.trim();
//         _hasMoreData = true; // reset the flag to true
//       });
//
//       final url =
//           'https://api.themoviedb.org/3/search/movie?api_key=b4a549abb798b19dbb7e63335d135053&query=$_searchQuery&page=$_currentPage';
//
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         final movies = jsonData['results'];
//
//         setState(() {
//           for (var movie in movies) {
//             _dataList.add(Movie(
//                 title: movie['original_title'],
//                 overview: movie['release_date'] ?? 'N/A'));
//           }
//           _isLoading = false;
//
//           // Check if we've displayed all the search results
//           if (movies.length < _perPage) {
//             _hasMoreData = false;
//           }
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     }
//   }
//
// }


/// second method
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const api_key = "b4a549abb798b19dbb7e63335d135053";
const url = "https://api.themoviedb.org/3/movie/popular?api_key=$api_key";




class MyHomePage2 extends StatefulWidget {
  MyHomePage2({Key? key}) : super(key: key);

  @override
  _MyHomePage2State createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  List<DataModel> _movies = [];
  int _currentPage = 1;
  int _perPage = 20;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _scrollController.addListener(_onEndScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchMovies() async {
    final response = await http.get(Uri.parse(url));
    final jsonData = json.decode(response.body);

    setState(() {
      for (var movie in jsonData["results"]) {
        _movies.add(DataModel.fromJson(movie));
      }
    });
  }

  void _loadMoreMovies() async {
    _currentPage++;
    final nextPageUrl =
        "https://api.themoviedb.org/3/movie/popular?api_key=$api_key&page=$_currentPage";
    final response = await http.get(Uri.parse(nextPageUrl));
    final jsonData = json.decode(response.body);

    setState(() {
      for (var movie in jsonData["results"]) {
        _movies.add(DataModel.fromJson(movie));
      }
    });
  }

  void _onEndScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _movies.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == _movies.length) {
          return _buildProgressIndicator();
        } else {
          return _buildListItem(index);
        }
      },
    );
  }

  Widget _buildListItem(int index) {
    final movie = _movies[index];
    return ListTile(
      title: Text(movie.title),
      subtitle: Text(movie.releaseDate),
      trailing: Text(movie.voteAverage.toString()),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class DataModel {
  int id;
  String title;
  String overview;
  String releaseDate;
  String posterPath;
  double voteAverage;

  DataModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
    required this.voteAverage,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      releaseDate: json['release_date'] ?? '',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}


