import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/screens/Profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowUser = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
            onPressed: () {
              setState(() {
                isShowUser = false;
              });
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            label: Text('Search for a user'),
          ),
          onFieldSubmitted: (_) {
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: firestore
                  .collection('user')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final snap = snapshot.data!.docs;
                          return ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(uid: snap[index]['uid']),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snap[index]['photoUrl']),
                              radius: 18,
                            ),
                            title: Text(
                              snap[index]['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if(snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Error occurs',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                else{
                  return const Center(
                    child: Text(
                      'Error occurs in firebase',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
              },
            )
          : FutureBuilder(
              future: firestore.collection('posts').get(),
              builder: ((context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    return MasonryGridView.count(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemBuilder: (context, index) {
                    return Image.network(snapshot.data!.docs[index]['posturl']);
                  },
                );
                  }
                  else{
                    return const Center(
                    child: CircularProgressIndicator(),
                  );
                  }
                }
               else if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                    child: CircularProgressIndicator(),
                  );
               }
               else if(snapshot.hasError){
                return const Center(
                    child: Text('Error occurs',style: TextStyle(color: Colors.red),),
                  );
               }
               else{
                return MasonryGridView.count(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemBuilder: (context, index) {
                    return Image.network(snapshot.data!.docs[index]['posturl']);
                  },
                );
               }
              }),
            ),
    );
  }
}
