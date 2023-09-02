import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/global_variable.dart';
import '../utils/utils.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    GlobalVariable globalVariable = GlobalVariable();
    GlobalVariable.s = firebaseAuth.currentUser!.uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
      pageController.jumpToPage(page);
    });
  }

  void onChangePage(int page) {
    setState(() {
      _page = page;
    });
  }

  Widget build(BuildContext context) {
    // User user = Provider.of<UserProvider>(context).getUser;
    GlobalVariable globalVariable = GlobalVariable();
    return Scaffold(
      body: PageView(
        children: globalVariable.homeScreenItem,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onChangePage,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        onTap: (page) {
          if (page != 2) {
            navigationTapped(page);
          } else {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 250,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            Uint8List file =
                                await pickImage(ImageSource.camera);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddPostScreen(file: file,)));
    
                          },
                          leading: Icon(Icons.camera_alt),
                          title: Text('Take a photo'),
                        ),
                        ListTile(
                          onTap: () async {
                            // Navigator.of(context).pop();
                            Uint8List file =
                                await pickImage(ImageSource.gallery);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddPostScreen(file: file,)));
                  
                          },
                          leading: Icon(Icons.photo),
                          title: Text('choose from gallery'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          leading: Icon(Icons.cancel),
                          title: Text('cancel'),
                        ),
                      ],
                    ),
                  );
                });
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              ),
              label: ''),
        ],
      ),
    );
  }
}
