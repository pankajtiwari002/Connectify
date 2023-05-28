import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../widget/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    if(!Provider.of<UserProvider>(context,listen: false).isAlreadyLoad){
      Provider.of<UserProvider>(context,listen: false).refreshUser().then((_){
      setState(() {
        load = false;
        Provider.of<UserProvider>(context,listen: false).changeAlreadyLoad();
      });
    });
    }
    else{
      setState(() {
        load=false;
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.message_outlined)),
        ],
      ),
      body: StreamBuilder(
          // initialData: ,
          stream: firestore.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return load ? const Center(child: CircularProgressIndicator(),) :ListView.builder(
                  itemCount: (snapshot.data as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return (snapshot.data as dynamic).docs[index].data() == null ?
                      Container(
                        child: Center(child: Text('loading...'),),
                     )
                     :PostCard(
                        snap: (snapshot.data as dynamic).docs[index].data());
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'error Occur',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(
                child: Text('Error in Firebase',style: TextStyle(color: Colors.red),),
              );
            }
          }),
    );
  }
}
