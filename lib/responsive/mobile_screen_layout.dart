import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/global_variable.dart';

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
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    setState(() {
      _page = page;
      pageController.jumpToPage(page);
    });
  }

  void onChangePage(int page){
    setState(() {
      _page = page;
    });
  }
  Widget build(BuildContext context) {
    // User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        children:  homeScreenItem,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onChangePage,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        onTap: (page){
          navigationTapped(page);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page==0 ? primaryColor : secondaryColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page==1 ? primaryColor : secondaryColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page==2 ? primaryColor : secondaryColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page==3 ? primaryColor : secondaryColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page==4 ? primaryColor : secondaryColor,
              ),
              label: ''),
        ],
      ),
    );
  }
}
