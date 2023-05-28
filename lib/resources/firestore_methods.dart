import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../models/post.dart';

class FirestoreMethods {
  Future<String> uploadPost(String description, String uid, Uint8List file,
      String profileImage, String username) async {
    String res = "some error occured";
    try {
      String photoUrl =
          await storageMethods.uploadImageToStorage('posts', file, true);
          String postId = Uuid().v1();
      Post post = Post(
          username: username,
          uid: uid,
          postId: postId,
          datePublished: DateTime.now(),
          description: description,
          profileImage: profileImage,
          posturl: photoUrl,
          likes: []
          );
      firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId,String uid,List likes) async{
    try{
      if(likes.contains(uid)){
        await firestore.collection('posts').doc(postId).update(
          {
            'likes':FieldValue.arrayRemove([uid])
          }
        );
      }
      else{
        await firestore.collection('posts').doc(postId).update(
          {
            'likes':FieldValue.arrayUnion([uid])
          }
        );
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> postComment(String postId,String text,String uid,String name,String profilePic) async{
    try{
      if(text.isNotEmpty){
        String commentId = Uuid().v1();
      await firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
        'profilePic': profilePic,
        'name': name,
        'uid': uid,
        'text': text,
        'commentId': commentId,
        'datePublished': DateTime.now(),
      });
      }
      else{
        print("text is empty");
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async{
    try{
      await firestore.collection('posts').doc(postId).delete();
    }catch(err){
      print(err.toString());
    }
  }

  Future<void> followUser(String uid,String followId) async{
    try{
      DocumentSnapshot snap = await firestore.collection('user').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];
      if(following.contains(followId)){
        await firestore.collection('user').doc(followId).update({
          'follwers': FieldValue.arrayRemove([uid]),
        });
        await firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      }
      else{
        await firestore.collection('user').doc(followId).update({
          'follwers': FieldValue.arrayUnion([uid]),
        });
        await firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    }catch(e){
      print(e.toString());
    }
  }
}
