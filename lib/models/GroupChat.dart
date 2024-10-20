import 'package:instagram_clone/models/Discussion.dart';
import 'package:instagram_clone/models/Message.dart';
import 'package:instagram_clone/models/user.dart';

class GroupChat extends Discussion {
  List<String> admin = [];
  GroupChat(List<String> admins, String chatId, String type,
      List<Message> messages, List<User> userList)
      : super(
            chatId: chatId,
            type: type,
            messages: messages,
            userList: userList) {
    admin = admins;
  }
}
