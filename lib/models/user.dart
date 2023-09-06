import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final List follwers;
  final List following;
  final String photoUrl;

  User({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.follwers,
    required this.following,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson(String token) => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'follwers': follwers,
        'following': following,
        'photoUrl': photoUrl,
        'fCMToken':[token,]
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        username: snapshot['username'],
        uid: snapshot['uid'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        follwers: snapshot['follwers'],
        following: snapshot['following'],
        photoUrl: snapshot['photoUrl']
      );
  }
}
