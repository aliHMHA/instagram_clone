import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/models/share_model.dart';
import 'package:instagram_flutter/widgets/post_card_model.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:intl/intl.dart';

class SharePreview extends StatefulWidget {
  const SharePreview({
    Key? key,
  }) : super(key: key);

  @override
  State<SharePreview> createState() => _SharePreviewState();
}

class _SharePreviewState extends State<SharePreview> {
  @override
  void initState() {
    super.initState();
    getshare();
  }

//get snap

  List<Sharemodel> sharelist = [];
  getshare() async {
    setState(() {
      _isloadinginit = true;
    });

    sharelist = [];
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('share')
        .get();

    for (var element in snap.docs) {
      sharelist.add(Sharemodel.fromsnap(element));
    }

    setState(() {
      _isloadinginit = false;
    });
  }

  bool _isloadinginit = false;

  @override
  Widget build(BuildContext context) {
    if (_isloadinginit == true) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    } else {
      List<String> postidlist = [];
      postidlist = [];

      for (var element in sharelist) {
        postidlist.add(element.postid);
      }

      return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
              if (snap.connectionState == ConnectionState.waiting ||
                  snap.connectionState == ConnectionState.none ||
                  snap.connectionState == ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else {
                List<Postmodel> postslist = [];

                for (var element in snap.data!.docs) {
                  if (postidlist
                      .contains(Postmodel.fromesnap(element).postid)) {
                    postslist.add(Postmodel.fromesnap(element));
                  }
                }

                return ListView.builder(
                    itemCount: postslist.length,
                    itemBuilder: (ctx, ind) {
                      return SizedBox(
                        child: Column(children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(35),
                                      child: CircleAvatar(
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: FadeInImage(
                                              fit: BoxFit.cover,
                                              placeholder: const AssetImage(
                                                  'assets/images/placeHolder1.jpg'),
                                              image: NetworkImage(sharelist[ind]
                                                  .senderimageurl)),
                                        ),
                                        radius: 35,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          sharelist[ind].sendername,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          DateFormat.yMMMMd().format(
                                              sharelist[ind].timedate.toDate()),
                                          style: const TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.only(left: 35, bottom: 10),
                                child: Text(
                                  sharelist[ind].message,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              const Divider(
                                color: Colors.white,
                              )
                            ],
                          ),
                          PostCardModel(
                              post: postslist[ind],
                              isformprofile: false,
                              isatshare: true)
                        ]),
                      );
                    });
              }
            }),
      );
    }
  }
}
