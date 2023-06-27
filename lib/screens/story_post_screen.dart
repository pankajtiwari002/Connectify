import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../models/story.dart';
import '../models/user.dart';

class StoryPostScreen extends StatelessWidget {
  Uint8List image;
  String type;
  StoryPostScreen({super.key, required this.image, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Image.memory(
              image,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () async{
                User user = Provider.of<UserProvider>(context,listen: false).getUser;
                await firestoreMethods.postStory(image,type,user);
                Navigator.of(context).pop();
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                alignment: Alignment.center,
                child: Icon(Icons.chevron_right_outlined,color: Colors.black,),
              ),
            )
          ),
        ],
      ),
    );
  }
}
