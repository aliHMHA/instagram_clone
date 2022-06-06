import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/widgets/post_card_model.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:instagram_flutter/units/dimentions.dart';

class BookMark extends StatefulWidget {
  final List<String> postidslist;
  const BookMark({Key? key, required this.postidslist}) : super(key: key);

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  @override
  void initState() {
    super.initState();

    getbookmarked(widget.postidslist);
  }

  bool _isloading = true;
  List<String> _bookmarkedpostsid = [];
  getbookmarked(List<String> postsidlist) async {
    _isloading = true;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final _snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final _user = UserModel.fromesnap(_snap);
    _bookmarkedpostsid = [];

    _bookmarkedpostsid = postsidlist
        .where((element) => _user.bookmarked.contains(element))
        .toList();

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return _isloading
        ? const Center(
            child: CircularProgressIndicator(
            color: primaryColor,
          ))
        : StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (con,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting ||
                  snapshots.connectionState == ConnectionState.none ||
                  snapshots.connectionState == ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else {
                List<Postmodel> postslist = [];

                for (var element in snapshots.data!.docs) {
                  if (_bookmarkedpostsid
                      .contains(Postmodel.fromesnap(element).postid)) {
                    postslist.add(Postmodel.fromesnap(element));
                  }
                }

                return Scaffold(
                  appBar: AppBar(),
                  body: _media.width > wepscreensize
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: _media.width / 4),
                          child: ListView.builder(
                            itemBuilder: ((context, index) => PostCardModel(
                                  isatshare: false,
                                  post: postslist[index],
                                  isformprofile: false,
                                )),
                            itemCount: postslist.length,
                          ))
                      : ListView.builder(
                          itemBuilder: ((context, index) => PostCardModel(
                                isatshare: false,
                                post: postslist[index],
                                isformprofile: false,
                              )),
                          itemCount: postslist.length,
                        ),
                );
              }
            },
          );
  }
}
