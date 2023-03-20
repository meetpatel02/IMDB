import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:imdb_task/box/boxes.dart';
import 'package:imdb_task/model/liked_movie.dart';

class LikeScreen extends StatefulWidget {

  LikeScreen({Key? key});
  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {

  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    final box = Boxes1.getData();
    final List<LikedMovie> likedMovies = box.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Movies'),
        // leading: IconButton(onPressed: (){
        //   Hive.box<LikedMovie>('liked_movies').clear();
        // },icon: Icon(Icons.delete),),
      ),
      body: Container(
        color: Colors.black.withOpacity(0.95),
        child: ListView.builder(
          itemCount: likedMovies.length,
          itemBuilder: (BuildContext context, int index) {
            final LikedMovie likedMovie = likedMovies[index];
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        '⭐ ️${likedMovie.vote_average.toString()}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.yellow),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          likedMovie.vote_count.toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
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
        ),
      ),
    );
  }


  // Widget _buildLikeScreen(BuildContext context) {
  //   final box = Hive.box<LikedMovie>('liked_movies');
  //   final List<LikedMovie> likedMovies = box.values.toList();
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Liked Movies'),
  //     ),
  //     body: GridView.builder(
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         childAspectRatio: 0.7,
  //       ),
  //       itemCount: likedMovies.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         final LikedMovie likedMovie = likedMovies[index];
  //         return Card(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Expanded(
  //                 child: Image.network(
  //                   'https://image.tmdb.org/t/p/w500${likedMovie.posterPath}',
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   likedMovie.title,
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }



}
