import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/widgets/post_card_model.dart';
import 'package:instagram_flutter/units/colors.dart';

class PostPreviwScreen extends StatefulWidget {
  final String postid;
  final bool isfromprofile;
  const PostPreviwScreen(
      {Key? key, required this.postid, required this.isfromprofile})
      : super(key: key);

  @override
  State<PostPreviwScreen> createState() => _PostPreviwScreenState();
}

class _PostPreviwScreenState extends State<PostPreviwScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('postid', isEqualTo: widget.postid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
            if (snap.connectionState == ConnectionState.waiting ||
                snap.connectionState == ConnectionState.none ||
                snap.connectionState == ConnectionState.done) {
              return const CircularProgressIndicator(
                color: primaryColor,
              );
            } else {
              return ListView.builder(
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (ctx, ind) => PostCardModel(
                      post: Postmodel.fromesnap(snap.data!.docs[ind]),
                      isformprofile: true,
                      isatshare: false));
            }
          }),
    );
  }
}
