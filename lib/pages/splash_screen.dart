import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:imdb_task/model/register_model.dart';
import 'package:imdb_task/route/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../box/boxes.dart';



class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Splash1 splashscreen = Splash1();

  void initState() {
    // TODO: implement initState
    splashscreen.splash(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFFE5B81E),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Center(
                child: Image(
                  image: AssetImage('assets/images/imdb.png'),
                  width: 200,
                  height: 200,
                ),
            ),
          ],
        ),
      ),
    );
  }

}

class Splash1 {
  void splash(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final box = Boxes.getData();
    String? user = '';
    if(prefs.getString('email') == prefs.getString('email')){
      Timer(const Duration(seconds: 3), () => Get.toNamed(MyRoutes.homeRoute));
    }if(prefs.getString('email') == null){
      Timer(const Duration(seconds: 3), () => Get.toNamed(MyRoutes.signInRoute));
    }
    // if(box.isEmpty){
    //   Timer(const Duration(seconds: 3), () => Get.toNamed(MyRoutes.signInRoute));
    // }
  }
}
