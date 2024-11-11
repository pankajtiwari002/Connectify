import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{

  Future<String> uploadImageToStorage(String childName,Uint8List file,bool isPost) async{
    Reference ref = await firebaseStorage.ref().child(childName).child(firebaseAuth.currentUser!.uid);

    if(isPost){
      String id = Uuid().v1();
      ref =  ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();
    
    return downloadUrl;
  }
}