import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class ImageSendingScreen extends StatefulWidget {
  final Uint8List file;
  final String uid;
  const ImageSendingScreen({super.key,required this.file,required this.uid});

  @override
  State<ImageSendingScreen> createState() => _ImageSendingScreenState();
}

class _ImageSendingScreenState extends State<ImageSendingScreen> {
  TextEditingController captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Image.memory(widget.file,fit: BoxFit.cover,),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: user.photoUrl,
                  imageBuilder: ((context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 16,
                      )),
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: captionController,
                    decoration: const InputDecoration(
                      hintText: 'Add a caption',
                      border: InputBorder.none,
                    ),
                  ),
                )),
                IconButton(
                  onPressed: () async {
                    String imageUrl = await storageMethods.uploadImageToStorage('chats', widget.file, true);
                    firestoreMethods.sendMessage(imageUrl, captionController.text, widget.uid, user.uid);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}