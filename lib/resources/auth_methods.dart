import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/utils/global_variable.dart';

import '../constants.dart';

class AuthMethod {


  Future<model.User> getUserDetails() async{
    DocumentSnapshot snap = await firestore.collection('user').doc(firebaseAuth.currentUser!.uid).get();

    return model.User.fromSnap(snap);
  }
  // * Sign up a user with an email address and password using Firebase
  Future<String> signUpUser({
    required String email,
    required String password,
    required String bio,
    required String username,
    required Uint8List file,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register user
        log(1);
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        print("uid:  " + cred.user!.uid);
        String photoUrl = await storageMethods.uploadImageToStorage(
            'profilePics', file, false);
        print("photo:  " + photoUrl);

        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            follwers: [],
            following: [],
            photoUrl: photoUrl
        );
        // add user detail to firestore
        String token = GlobalVariable.fCMToken!;
        firestore.collection('user').doc(cred.user!.uid).set(user.toJson(token));
        res = "success";
      }
    } catch (e) {
      res = e.toString();
      print(res);
    }
    return res;
  }

  // * Sign in a user with a password using Firebase
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // login user
        log(1);
        UserCredential cred = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print("uid:  " + cred.user!.uid);
        res = "success";
        String token = GlobalVariable.fCMToken!;
        firestore.collection('user').doc(cred.user!.uid).update({
          'fCMToken': FieldValue.arrayUnion([token])
        });
      } else {
        res = "please enter all the field";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = "User not found";
        return res;
      }
      if (err.code == 'wrong-password') {
        res = "Enter Correct password";
        return res;
      }
    } catch (e) {
      res = e.toString();
      print(res);
      
    }
    return res;
  }
  // * Sign out a user using Firebase
  Future<void> signOut(model.User user) async{
    await firebaseAuth.signOut();

    String token = GlobalVariable.fCMToken!;
        firestore.collection('user').doc(user.uid).update({
          'fCMToken': FieldValue.arrayRemove([token])
        });
  }
}
