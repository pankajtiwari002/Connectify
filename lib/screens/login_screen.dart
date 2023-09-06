import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:http/http.dart' as http;
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../widget/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isloading = false;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Future<void> sendNotificationToUser() async {
  //   try {
  //     print(2);
  //     String? token = await FirebaseMessaging.instance.getToken();
  //     Map<String, String> notificationPayload = {
  //       'title': 'Login Successful',
  //       'body': 'logged in. Successfully',
  //     };
  //     print(1);
  //     print(token);
  //     http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: {
  //         HttpHeaders.contentTypeHeader: 'application/json',
  //         HttpHeaders.authorizationHeader: 'key=AAAAFgBql6Q:APA91bEEesfgyRMeZJUaF1zMdtb1qHhGf_3ILzd9R_e7fX-8-v3-Ya-iEI-T8JVcJ1V1GoBX69je4PjgSKq_0UbjvN0h7nLDi82czaRO8YXKUV2EUDV9FLzfG-U6TUv5xJaIaEQ0YTdy'
  //       },
  //       body: jsonEncode({
  //               "registration_ids": [
  //                   token,
  //               ],
  //               // "to": token,
  //               "notification": {
  //                   "body": "You are successfully login",
  //                   "title": "Successfully Login",
  //                   "android_channel_id": "instagramclone",
  //                   // "image":"https://cdn2.vectorstock.com/i/1000x1000/23/91/small-size-emoticon-vector-9852391.jpg",
  //                   "sound": true
  //               }
  //             },)
  //     );
  //     print(21);
  //   } catch (e) {
  //     print(90);
  //     print('Error sending notification: $e');
  //   }
  // }

  void navigateToSignUp() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  Future<void> loginUser() async {
    setState(() {
      _isloading = true;
    });
    // await sendNotificationToUser();
    String res = await AuthMethod().loginUser(
        email: _emailController.text, password: _passwordController.text);
    setState(() {
      _isloading = false;
    });
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      print(1000);
      String token = GlobalVariable.fCMToken!;
      await firebaseMessagingMethods.sendNotificationToUser('Login Successfully', 'Logged in Successfully',token);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
      print(1001);
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariable globalVariable = GlobalVariable();
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding:
            MediaQuery.of(context).size.width > globalVariable.webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible(flex: 2, child: Container()),
              const SizedBox(
                height: 200,
              ),
              //svg image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              // Email address
              TextFieldInput(
                hintText: "Enter your Email",
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              // password
              TextFieldInput(
                hintText: "Enter your Password",
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              // Log in Button
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Log in'),
                  height: 40,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  // color: blueColor,
                ),
              ),
              // transition to sign up page
              // Flexible(
              //   child: Container(),
              //   flex: 2,
              // ),
              const SizedBox(
                height: 220,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("Don't have an account?  "),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        " Signup ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
