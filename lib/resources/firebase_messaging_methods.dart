import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone/utils/global_variable.dart';

class FirebaseMessagingMethods{

  Future<void> sendNotificationToUser(String title,String body,String token) async {
    try {
      print(2);
      // String? token = GlobalVariable.fCMToken;
      print(1);
      print(token);
      http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'key=AAAAFgBql6Q:APA91bEEesfgyRMeZJUaF1zMdtb1qHhGf_3ILzd9R_e7fX-8-v3-Ya-iEI-T8JVcJ1V1GoBX69je4PjgSKq_0UbjvN0h7nLDi82czaRO8YXKUV2EUDV9FLzfG-U6TUv5xJaIaEQ0YTdy'
        },
        body: jsonEncode({
                "registration_ids": [
                    token,
                ],
                // "to": token,
                "notification": {
                    "body": body,
                    "title": title,
                    "android_channel_id": "instagramclone",
                    // "image":"https://cdn2.vectorstock.com/i/1000x1000/23/91/small-size-emoticon-vector-9852391.jpg",
                    "sound": true
                }
              },)
      );
      print(21);
    } catch (e) {
      print(90);
      print('Error sending notification: $e');
    }
  }
}