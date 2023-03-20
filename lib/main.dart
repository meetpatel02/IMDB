import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:imdb_task/model/liked_movie.dart';
import 'package:imdb_task/model/movie_model.dart';
import 'package:imdb_task/pages/home.dart';
import 'package:imdb_task/pages/like_screen.dart';
import 'package:imdb_task/pages/register_screen.dart';
import 'package:imdb_task/pages/signin_screen.dart';
import 'package:imdb_task/pages/splash_screen.dart';
import 'package:imdb_task/route/routes.dart';
import 'package:path_provider/path_provider.dart';

import 'model/register_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(RegisterModelAdapter());
  Hive.registerAdapter(LikedMovieAdapter());
  await Hive.openBox<RegisterModel>('registerUser');
  await Hive.openBox<LikedMovie>('liked_movies');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        '/' : (context)=>  Splash(),
        MyRoutes.signInRoute: (context) =>  SignInScreen(),
        MyRoutes.registerRoute : (context) =>  RegisterScreen(),
        MyRoutes.homeRoute : (context) =>  MovieList(),
        MyRoutes.likeRoute : (context) =>  LikeScreen(),
      },
    );
  }
}
