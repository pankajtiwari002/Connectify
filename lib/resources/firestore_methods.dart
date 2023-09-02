import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../models/chat.dart';
import '../models/post.dart';
import '../models/story.dart';

class FirestoreMethods {
  // * Check if document exists in a collection
  Future<bool> checkIfDocExists(String collectionName, String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = firestore.collection(collectionName);

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  //* upload post to Firestore and store image in storage
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
          likes: []);
      firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //* store a list of uid that like a post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //* post a comment on a post and use subcollection to store
  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print("text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //* delete a post
  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  //* store the uid of a the followes and following in a list
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await firestore.collection('user').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];
      if (following.contains(followId)) {
        await firestore.collection('user').doc(followId).update({
          'follwers': FieldValue.arrayRemove([uid]),
        });
        await firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await firestore.collection('user').doc(followId).update({
          'follwers': FieldValue.arrayUnion([uid]),
        });
        await firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createChat(
      User user, QueryDocumentSnapshot<Map<String, dynamic>> sender) async {
    try {
      log(1);
      await firestore
          .collection('user')
          .doc(sender['uid'])
          .collection('chats')
          .doc(user.uid)
          .set({
        'messages': [],
        'photoUrl': user.photoUrl,
        'username': user.username,
        'uid': user.uid
      });
      log(2);
      await firestore
          .collection('user')
          .doc(user.uid)
          .collection('chats')
          .doc(sender['uid'])
          .set({
        'messages': [],
        'photoUrl': sender['photoUrl'],
        'username': sender['username'],
        'uid': sender['uid']
      });
      log(3);
    } catch (e) {
      log(4);
      print(e.toString());
    }
  }

  Future<void> sendMessage(
      String imageUrl, String text, String uid, String senderId) async {
    try {
      log(1);
      Chat chatOwner = Chat(
          text: text, date: DateTime.now(), owner: true, imageUrl: imageUrl);
      await firestore
          .collection('user')
          .doc(senderId)
          .collection('chats')
          .doc(uid)
          .update({
        'messages': FieldValue.arrayUnion([chatOwner.toJson()]),
      });
      log(2);
      if (uid != senderId) {
        Chat chatReceiver = Chat(
            text: text, date: DateTime.now(), owner: false, imageUrl: imageUrl);
        await firestore
            .collection('user')
            .doc(uid)
            .collection('chats')
            .doc(senderId)
            .update({
          'messages': FieldValue.arrayUnion([chatReceiver.toJson()]),
        });
      }
      log(3);
    } catch (e) {
      log(4);
      print(e.toString());
    }
  }

  //* function to post a story to firestore
  Future<void> postStory(Uint8List image, String type, User user) async {
    try {
      String imageurl =
          await storageMethods.uploadImageToStorage('story', image, true);
      String storyId = Uuid().v1();
      Story story = Story(
          type: type,
          storyUrl: imageurl,
          storyId: storyId);
      if(await checkIfDocExists('story', user.uid)){
          await firestore.collection('story').doc(user.uid).update({
            'stories': FieldValue.arrayUnion([story.toJson()]),
          });
      }
      else{
        await firestore.collection('story').doc(user.uid).set({
          'username': user.username,
          'uid': user.uid,
          'profileUrl': user.photoUrl,
          'stories': [story.toJson()],
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
