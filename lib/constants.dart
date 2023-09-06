import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

import 'resources/firebase_messaging_methods.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

FirebaseFirestore firestore = FirebaseFirestore.instance;

FirebaseStorage firebaseStorage = FirebaseStorage.instance;

StorageMethods storageMethods = StorageMethods();

AuthMethod authMethod = AuthMethod();

FirestoreMethods firestoreMethods = FirestoreMethods();

FirebaseMessagingMethods firebaseMessagingMethods = FirebaseMessagingMethods();