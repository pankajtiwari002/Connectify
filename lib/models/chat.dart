import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  final String? imageUrl;
  final String text;
  final DateTime date;
  final bool owner;

  Chat({required this.text,required this.date,required this.owner,required this.imageUrl});

  Map<String, dynamic> toJson() => {
    'text': text,
    'date': date,
    'owner': owner,
    'imageUrl':imageUrl
  };

  static Chat fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return Chat(text: snapshot['text'], date: snapshot['date'], owner: snapshot['owner'],imageUrl: snapshot['imageUrl']);
  }
}