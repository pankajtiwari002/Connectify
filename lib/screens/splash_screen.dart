import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../constants.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isSplash = true;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3)).then((_){
      setState(() {
        isSplash = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isSplash ? Scaffold(
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          child: Image.asset('assets/instagram.jpg')
          ),
      ),
    ) :
    StreamBuilder(
          stream: firebaseAuth.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return const ResponsiveLayout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout());
              }
              else if(snapshot.hasError){
                return Scaffold(body: Center(child: Text('${snapshot.error}'),),);
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: primaryColor,),);
            }
            return const LoginScreen();
          },
        );
  }
}