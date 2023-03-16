import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:imdb_task/box/boxes.dart';
import 'package:imdb_task/model/register_model.dart';
import 'package:imdb_task/route/routes.dart';
import 'package:imdb_task/utils/app_string.dart';
import 'package:imdb_task/utils/custome_alert.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Image(
            image: AssetImage('assets/images/imdb.png'),
            width: 85,
            height: 85,
          ),
          backgroundColor: Colors.white30,
          elevation: 1,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10),
                child: Row(
                  children: [
                    Text(
                      AppString.signIn.replaceAll('-', ' '),
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      AppString.forgot,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.cyan,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.65)),
                          borderRadius: BorderRadius.circular(3)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 5),
                              child: TextFormField(
                                controller: emailController,
                                cursorColor: Colors.black,
                                cursorHeight: 20,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: AppString.email,
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent))),
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black.withOpacity(0.35),
                          ),
                          SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 5),
                              child: TextFormField(
                                controller: passwordController,
                                cursorColor: Colors.black,
                                cursorHeight: 20,
                                obscureText: _passwordVisible,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: AppString.password,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // textfield(
                    //     hintText: AppString.password,
                    //     readOnly: false,
                    //     obscuretext: _passwordVisible,
                    //     maxLines: 1,
                    //     controller: passwordController,
                    //     textInputAction: TextInputAction.done,
                    //     keyboardType: TextInputType.text,
                    // ),

                    const SizedBox(
                      height: 20,
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
                      height: 15,
                    ),

                    ///SignIn button
                    Container(
                      height: 55,
                      width: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: Colors.black.withOpacity(0.75))),
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(3),
                        onPressed: () {
                          moveToHomeScreen(context);
                        },
                        color: Colors.yellow.shade700,
                        child: Text(
                          AppString.signIn.replaceAll('-', ' '),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Expanded(
                            child: Divider(
                          endIndent: 5,
                          indent: 5,
                          color: Colors.black12,
                          thickness: 2,
                        )),
                        Text(AppString.newToImdb),
                        Expanded(
                            child: Divider(
                          endIndent: 5,
                          indent: 5,
                          color: Colors.black12,
                          thickness: 2,
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 55,
                      width: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: Colors.black.withOpacity(0.75))),
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(3),
                        onPressed: () {
                          Get.toNamed(MyRoutes.registerRoute);
                        },
                        color: const Color(0xffE6E7E7),
                        child: const Text(
                          AppString.createNewYourImdbAccount,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    ///Divider
                    const Divider(
                      color: Colors.black12,
                      endIndent: 50,
                      indent: 50,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    ///conditionOfUse & privacyPolicy
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

                    ///bottomHeader
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
            ],
          ),
        ),
      ),
    );
  }

  moveToHomeScreen(BuildContext context) {
    ///email snackBar
    final emailSnackBar = SnackBar(
      duration: Duration(seconds: 2),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      showCloseIcon: false,
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
      showCloseIcon: false,
      content: AwesomeSnackbarContent(
        title: 'Warning!',
        message: 'Please enter your password',
        contentType: ContentType.warning,
      ),
    );

    ///email check
    final emailCheckSnackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      showCloseIcon: false,
      content: AwesomeSnackbarContent(
        title: 'Warning!',
        message: 'Please check your email',
        contentType: ContentType.warning,
      ),
    );

    ///password characters
    final passwordCheckSnackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      showCloseIcon: false,
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
        message: ErrorMessage.errorMessageForLogin,
        contentType: ContentType.warning,
      ),
    );

    ///UserPasswordCheck
    final userPasswordCheckSnackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      showCloseIcon: false,
      content: AwesomeSnackbarContent(
        title: 'Warning!',
        message: ErrorMessage.errorMessageForLogin,
        contentType: ContentType.warning,
      ),
    );

    ///Conditions
    if (emailController.text.trim().isEmpty) {
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
        .hasMatch(passwordController.text)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(passwordCheckSnackBar);
    } else {
      final data = Boxes.getData().values.toList().cast<RegisterModel>();
      var isEmailExist = data
          .where((element) => element.email == emailController.text.toString());
      var isPasswordExist = data.where(
          (element) => element.password == passwordController.text.toString());
      if (isEmailExist.isEmpty) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(userEmailCheckSnackBar);
      } else if (isPasswordExist.isEmpty) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(userPasswordCheckSnackBar);
      } else {
        Get.toNamed(MyRoutes.homeRoute)?.then((value) {
          emailController.clear();
          passwordController.clear();
        });
      }
    }
  }
}
