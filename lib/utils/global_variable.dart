import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import '../constants.dart';
import '../screens/Profile_screen.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';

const int webScreenSize = 600;
 final String s = firebaseAuth.currentUser!.uid;
 List<Widget> homeScreenItem = [
  const FeedScreen(),
  const SearchScreen(), 
  const AddPostScreen(),
  const Center(child: Text('notify')),
  ProfileScreen(uid: s),
];
