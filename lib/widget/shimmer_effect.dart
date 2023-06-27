import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: (MediaQuery.of(context).size.height / 150).round() - 1,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade200,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: 150,
              width: double.infinity,
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      // backgroundColor: Colors.green,
                    ),
                    title: Container(
                      color: Colors.black,
                      height: 10,
                      width: 100,
                    ),
                    subtitle: Container(
                      color: Colors.black,
                      height: 10,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
