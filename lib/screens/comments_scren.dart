import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/comment_model.dart';
import 'package:instagram_flutter/widgets/commentswindow.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/storage_metods.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CommentsScreen extends StatefulWidget {
  final String postid;
  const CommentsScreen({Key? key, required this.postid}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _ConnebtsScreenState();
}

class _ConnebtsScreenState extends State<CommentsScreen> {
  @override
  void initState() {
    super.initState();
    commentStream();
  }

  @override
  void dispose() {
    super.dispose();
    commentcontoller.dispose();
    _commenttstream.cancel();
  }

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _commenttstream;

  commentStream() {
    _commentList.clear();
    _commenttstream = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postid)
        .collection('comments')
        .orderBy('timedate', descending: true)
        .snapshots()
        .listen((event) {
      _commentList = [];
      for (var element in event.docs) {
        _commentList.add(Comment.fromjson(element.data()));
      }
      setState(() {});
    });
  }

  List<Comment> _commentList = [];
  final TextEditingController commentcontoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final userprov = Provider.of<UserProvider>(context);

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Comments')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: media.size.height * .9,
                width: double.infinity,
                color: mobileBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: _commentList.length,
                          itemBuilder: (ctx, ind) =>
                              CommentsWindow(comment: _commentList[ind])),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                width: double.infinity,
                height: media.size.height * .1,
                decoration: const BoxDecoration(
                    color: mobileBackgroundColor,
                    border:
                        Border(top: BorderSide(width: 1, color: primaryColor))),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Consumer<UserProvider>(
                      builder: (ctx, value, ch) => CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(value.getuserinfo.photo)),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                        width: media.size.width * .55,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'pleas write some thing first ';
                            } else {
                              return null;
                            }
                          },
                          controller: commentcontoller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'write a comment...'),
                        )),
                    TextButton(
                        onPressed: () async {
                          if (commentcontoller.text.isEmpty ||
                              commentcontoller.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text(' pleas enter acomment first')));
                          } else {
                            final commentid = const Uuid().v1();
                            await StorageMethods().commentpost(
                                Comment(
                                    likes: [],
                                    commentid: commentid,
                                    commentText: commentcontoller.text,
                                    timedate:
                                        Timestamp.fromDate(DateTime.now()),
                                    postid: widget.postid,
                                    useridd: userprov.getuserinfo.userid,
                                    commenterimage: userprov.getuserinfo.photo,
                                    commentername:
                                        userprov.getuserinfo.username),
                                context);
                          }
                          commentcontoller.clear();
                        },
                        child: const Text('Comment')),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
