import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/constants.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final datePublished;
  final String username;
  final String posturl;
  final String profileImage;
  final List likes;

  Post(
      {required this.username,
      required this.uid,
      required this.postId,
      required this.datePublished,
      required this.description,
      required this.profileImage,
      required this.posturl,
      required this.likes});

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'postId': postId,
        'datePublished': datePublished,
        'username': username,
        'posturl': posturl,
        'profileImage': profileImage,
        'likes': likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        username: snapshot['username'],
        uid: snapshot['uid'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        description: snapshot['description'],
        profileImage: snapshot['profileImage'],
        posturl: snapshot['posturl'],
        likes: snapshot['likes']);
  }

}
