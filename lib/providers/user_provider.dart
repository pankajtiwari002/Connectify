import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier{
  User? _user;
  bool _alreadyLoad = false;

  User get getUser => _user!;

  void changeAlreadyLoad(){
    _alreadyLoad = true;
  }

  bool get isAlreadyLoad => _alreadyLoad;

  Future<void> refreshUser() async{
    User user = await authMethod.getUserDetails();
    _user = user; 
    notifyListeners();
  }

}