import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../widget/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Future<void> signUp() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethod().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        username: _usernameController.text,
        file: _image!);
    setState(() {
      _isloading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Flexible(flex: 2,fit: FlexFit.loose ,child: Container()),
              SizedBox(
                height: 80,
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
              //profile
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(_image!),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt1ceyneFkZchgkrwN7dZxWNl_C5Dctvc5BzNh_rEzPQ&s"),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              // username
              TextFieldInput(
                hintText: "Enter your username",
                textEditingController: _usernameController,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              // Email address
              TextFieldInput(
                hintText: "Enter your Email",
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20,
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
              TextFieldInput(
                hintText: "Enter your blog",
                textEditingController: _bioController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              // Log in Button
              InkWell(
                onTap: signUp,
                child: Container(
                  child: _isloading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text('SignUp'),
                  height: 50,
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
              //   flex: 1,
              // ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Already have an account! "),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        " Login ",
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
