import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_flutter/widgets/post_card_model.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/book_mark.dart';
import 'package:instagram_flutter/screens/share_preview.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:instagram_flutter/units/dimentions.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  List<String> listofpostsid(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
    List<String> gg = [];
    for (var element in snap.data!.docs) {
      gg.add(Postmodel.fromesnap(element).postid);
    }
    return gg;
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    final authprov = Provider.of<UserProvider>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder:
          (con, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting ||
            snapshots.connectionState == ConnectionState.none ||
            snapshots.connectionState == ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        } else {
          return Scaffold(
            appBar: _media.width > wepscreensize
                ? AppBar(
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookMark(
                                      postidslist: listofpostsid(snapshots))));
                        },
                        icon: const Icon(
                          Icons.bookmark,
                          size: 20,
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            const SharePreview()));
                              },
                              iconSize: 20),
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 9,
                            child: Text(
                              authprov.getuserinfo.sharerecived.length
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                : AppBar(
                    leadingWidth: 100,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SvgPicture.asset(
                        'assets/ic_instagram.svg',
                        color: primaryColor,
                        height: 35,
                      ),
                    ),
                    elevation: 0,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookMark(
                                        postidslist:
                                            listofpostsid(snapshots))));
                          },
                          icon: const Icon(
                            Icons.bookmark,
                            size: 30,
                            color: primaryColor,
                          )),
                      Stack(
                        children: [
                          IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            const SharePreview()));
                              },
                              iconSize: 30),
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 9,
                            child: Text(
                              authprov.getuserinfo.sharerecived.length
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
            body: _media.width > wepscreensize
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: _media.width / 4),
                    child: ListView.builder(
                      itemBuilder: (context, index) => PostCardModel(
                        isatshare: false,
                        post: Postmodel.fromesnap(snapshots.data!.docs[index]),
                        isformprofile: false,
                      ),
                      itemCount: snapshots.data!.docs.length,
                    ))
                : ListView.builder(
                    itemBuilder: (context, index) => PostCardModel(
                      isatshare: false,
                      post: Postmodel.fromesnap(snapshots.data!.docs[index]),
                      isformprofile: false,
                    ),
                    itemCount: snapshots.data!.docs.length,
                  ),
          );
        }
      },
    );
  }
}
