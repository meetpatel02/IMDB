import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:imdb_task/box/boxes.dart';
import 'package:imdb_task/model/liked_movie.dart';
import 'package:imdb_task/model/register_model.dart';
import 'package:imdb_task/route/routes.dart';
import 'package:imdb_task/utils/app_string.dart';
import 'package:imdb_task/utils/custome_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Image(
          image: AssetImage('assets/images/imdb.png'),
          width: 85,
          height: 85,
        ),
        backgroundColor: Colors.white30,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Create account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              ///Name TextField
              textfield(
                  hintText: AppString.nameHint,
                  readOnly: false,
                  obscuretext: false,
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name),
              const SizedBox(
                height: 10,
              ),

              ///email textField
              textfield(
                  hintText: AppString.emailHint,
                  controller: emailController,
                  readOnly: false,
                  obscuretext: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(
                height: 10,
              ),

              ///password textField
              textfield(
                  hintText: AppString.passwordHint,
                  controller: passwordController,
                  readOnly: false,
                  obscuretext: _passwordVisible,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  keyboardType: null),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.info,
                    color: Colors.cyan,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Password must be at least 8 characters')
                ],
              ),
              SizedBox(
                height: 10,
              ),

              ///show password
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Icon(
                      _passwordVisible
                          ? Icons.check_box_outline_blank
                          : Icons.check_box,
                      color: Colors.black,
                    ),
                    onTap: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(AppString.showPassword)
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              ///create account button

              Container(
                height: 55,
                width: 400,
                decoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.black.withOpacity(0.75))),
                child: TextButton(
                  onPressed: () {
                    moveToHomeScreen(context);
                  },
                  child: const Text(
                    AppString.createYourImdbAccount,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              ///Divider
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: const [
                    Expanded(
                        child: Divider(
                      endIndent: 5,
                      indent: 5,
                      color: Colors.black12,
                      thickness: 2,
                    )),
                    Text(AppString.alreadyHaveAnAccount),
                    Expanded(
                        child: Divider(
                      endIndent: 5,
                      indent: 5,
                      color: Colors.black12,
                      thickness: 2,
                    )),
                  ],
                ),
              ),

              ///sign in button
              const SizedBox(
                height: 15,
              ),

              Container(
                height: 55,
                width: 400,
                decoration: BoxDecoration(
                    color: const Color(0xffE6E7E7),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.black.withOpacity(0.75))),
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(MyRoutes.signInRoute);
                  },
                  child: const Text(
                    AppString.signInNow,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                color: Colors.black12,
                endIndent: 50,
                indent: 50,
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    AppString.conditionOfUse,
                    style: TextStyle(
                        color: Colors.cyan, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    AppString.privacyPolicy,
                    style: TextStyle(
                        color: Colors.cyan, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    AppString.bottomHeader,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  moveToHomeScreen(BuildContext context) async {
    ///name snackBar
    final nameSnackBar = SnackBar(
      duration: Duration(milliseconds: 600),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Warning!',
        message: 'Please enter your name',
        contentType: ContentType.warning,
      ),
    );

    ///email snackBar
    final emailSnackBar = SnackBar(
      duration: Duration(milliseconds: 600),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Warning!',
        message: 'Please enter your email',
        contentType: ContentType.warning,
      ),
    );

    ///password snackBar
    final passwordSnackBar = SnackBar(
      duration: Duration(milliseconds: 600),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Warning!',
        message: 'Please enter your password',
        contentType: ContentType.warning,
      ),
    );

    ///email check
    final emailCheckSnackBar = SnackBar(
      duration: Duration(milliseconds: 600),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Warning!',
        message: 'Please check your email',
        contentType: ContentType.warning,
      ),
    );

    ///password characters
    final passwordCheckSnackBar = SnackBar(
      duration: Duration(milliseconds: 600),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Warning!',
        message: 'Password must be at least 8 characters',
        contentType: ContentType.warning,
      ),
    );

    ///UserCheck
    final userEmailCheckSnackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      showCloseIcon: false,
      content: AwesomeSnackbarContent(
        title: 'Warning!',
        message: 'User already register!!',
        contentType: ContentType.warning,
      ),
    );
    ///Register Successfully
    final registerSuccessfully = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      showCloseIcon: false,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: 'Register Successfully',
        contentType: ContentType.success,
      ),
    );

    ///Conditions
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(nameSnackBar);
    } else if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(emailSnackBar);
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(emailController.text.trim())) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(emailCheckSnackBar);
    } else if (passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(passwordSnackBar);
    } else if (!RegExp(r'^(?=.*?[0-9]).{8,}$')
        .hasMatch(passwordController.text.trim())) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(passwordCheckSnackBar);
    }
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setBool('isUserLogin', true);
      final data1 = RegisterModel(
          name: nameController.text.trim().toString(),
          email: emailController.text.trim().toString(),
          password: passwordController.text.trim().toString());

      final box = Boxes.getData();
      final data = Boxes.getData().values.toList().cast<RegisterModel>();
      var isEmailExist = data
          .where((element) => element.email == emailController.text.trim().toString());
      if(isEmailExist.isNotEmpty){
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(userEmailCheckSnackBar);
      }else{
        box.add(data1);
        data1.save();
        prefs.setString('email', emailController.text.trim().toString());
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(registerSuccessfully);
        Get.offAndToNamed(MyRoutes.signInRoute)?.then((value) {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
        });
      }
    }
  }
}
