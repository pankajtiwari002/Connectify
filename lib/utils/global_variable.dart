import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import '../constants.dart';
import '../screens/Profile_screen.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';

class GlobalVariable{
    static String? fCMToken = '';
    int webScreenSize = 600;
    static String s = '';
    late List<Widget> homeScreenItem = [
      const FeedScreen(),
      const SearchScreen(), 
      const FeedScreen(),
      const Center(child: Text('notify')),
      ProfileScreen(uid: s),
    ];
}
