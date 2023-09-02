import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  Uint8List file;
  AddPostScreen({required this.file});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isloading = false;

  postImage(String uid,String username, String profileImage) async{
    setState(() {
      _isloading = true;
    });
    try{
      String res = await FirestoreMethods().uploadPost(_descriptionController.text, uid, widget.file, profileImage, username);
      if(res=="success"){
        showSnackBar("posted!", context);
        clearImage();
      }
      else{
        showSnackBar(res, context);
      }
    }catch(e){
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isloading = false;
    });
  }

  void clearImage(){
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    log(user.photoUrl);
    return Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                    radius: 20,
                  ),
                  SizedBox(width: 10,),
                  Text(user.username),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: (){
                      postImage(user.uid, user.username, user.photoUrl);
                    },
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _isloading ? const LinearProgressIndicator() : Container(),
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Write a caption ...',
                      contentPadding: EdgeInsets.only(left: 15,right: 15),
                      border: InputBorder.none,
                    ),
                    maxLines: 20,
                    minLines: 1,
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    height: 170,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: MemoryImage(widget.file)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
