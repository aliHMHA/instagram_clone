import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/widgets/piview_image.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/storage_metods.dart';
import 'package:instagram_flutter/resources/utlis.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/profile_screen.dart';
import 'package:instagram_flutter/screens/comments_scren.dart';
import 'package:instagram_flutter/screens/responsev_layout_screen.dart';
import 'package:instagram_flutter/screens/share_screen.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:instagram_flutter/units/dimentions.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCardModel extends StatefulWidget {
  final Postmodel post;
  final bool isformprofile;
  final bool isatshare;
  const PostCardModel(
      {Key? key,
      required this.post,
      required this.isformprofile,
      required this.isatshare})
      : super(key: key);

  @override
  State<PostCardModel> createState() => _PostCardModelState();
}

class _PostCardModelState extends State<PostCardModel> {
  bool isAnimating = false;

  void showcommentbottomsheet(BuildContext ctx, String postid) {
    showBottomSheet(
        context: ctx,
        builder: (_) {
          return CommentsScreen(postid: postid);
        });
  }

  @override
  void initState() {
    super.initState();
    isbookmarked();
  }

  isbookmarked() async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final _user = UserModel.fromesnap(snap);

    if (_user.bookmarked.contains(widget.post.postid)) {
      setState(() {
        _ismarked = true;
        _isloading = false;
      });
    } else {
      setState(() {
        _ismarked = false;
        _isloading = false;
      });
    }
  }

  bool _ismarked = false;
  bool _isloading = true;
  @override
  Widget build(BuildContext context) {
    DateTime puplishdate = widget.post.puplishdate.toDate();
    final _userprovider = Provider.of<UserProvider>(context);

    final _media = MediaQuery.of(context).size;

    return _isloading
        ? SizedBox(
            height: _media.width > wepscreensize
                ? _media.height * .9
                : _media.height * .7,
            child: const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          )
        : Card(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.zero,
                color:
                    _media.width > wepscreensize ? null : mobileBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!widget.isformprofile) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => ProfileScreen(
                              profileOnerid: widget.post.ownerid,
                            ),
                          ));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CircleAvatar(
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: FadeInImage(
                                      fit: BoxFit.cover,
                                      placeholder: const AssetImage(
                                          'assets/images/placeHolder1.jpg'),
                                      image: NetworkImage(
                                          widget.post.profileimageurl)),
                                ),
                                radius: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.post.username,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Expanded(child: SizedBox()),
                            if (!widget.isatshare)
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            content: InkWell(
                                              onTap: () async {
                                                if (widget.post.ownerid ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid) {
                                                  Navigator.pop(ctx);

                                                  // Navigator.of(context)
                                                  //     .pushReplacement(
                                                  //         MaterialPageRoute(
                                                  //             builder: (cg) =>
                                                  //                 const ResponsevLayoutScreen()));

                                                  await StorageMethods()
                                                      .deletepost(
                                                          commentlist: widget
                                                              .post.comments,
                                                          contxt: context,
                                                          postid: widget
                                                              .post.postid,
                                                          postownerid: widget
                                                              .post.ownerid,
                                                          userid: _userprovider
                                                              .getuserinfo
                                                              .userid);
                                                } else {
                                                  showsnackbarr(context,
                                                      'You are not the owner');
                                                }
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height:
                                                    _media.width > wepscreensize
                                                        ? _media.width * .1
                                                        : _media.width * .2,
                                                padding:
                                                    const EdgeInsets.all(20),
                                                width:
                                                    _media.width > wepscreensize
                                                        ? _media.width / 4
                                                        : _media.width * .6,
                                                child: const Text(
                                                  'Delete',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.more_vert_rounded))
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    PreviewImage(image: widget.post.photoUrl)));
                      },
                      onDoubleTap: () async {
                        await StorageMethods().likePost(
                            postownerid: widget.post.ownerid,
                            context: context,
                            likes: widget.post.likes,
                            postid: widget.post.postid,
                            uid: _userprovider.getuserinfo.userid);
                        setState(() {
                          isAnimating = true;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                              width: double.infinity,
                              height: _media.width > wepscreensize
                                  ? _media.height * .5
                                  : _media.height * .4,
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                placeholder: const AssetImage(
                                    'assets/images/placeHolder2.jpg'),
                                image: NetworkImage(
                                  widget.post.photoUrl,
                                ),
                              )),
                          AnimatedOpacity(
                            opacity: isAnimating ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: LikeAnimation(
                              child: widget.post.likes.contains(
                                      _userprovider.getuserinfo.userid)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 120,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: 120,
                                    ),
                              duration: const Duration(milliseconds: 400),
                              isAnimating: isAnimating,
                              onEnd: () {
                                setState(() {
                                  isAnimating = false;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(children: [
                        LikeAnimation(
                          duration: const Duration(milliseconds: 400),
                          isAnimating: widget.post.likes
                              .contains(_userprovider.getuserinfo.userid),
                          smallLike: true,
                          child: IconButton(
                            onPressed: () {
                              StorageMethods().likePost(
                                  postownerid: widget.post.ownerid,
                                  context: context,
                                  likes: widget.post.likes,
                                  postid: widget.post.postid,
                                  uid: _userprovider.getuserinfo.userid);
                            },
                            icon: widget.post.likes
                                    .contains(_userprovider.getuserinfo.userid)
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 22,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.red,
                                    size: 22,
                                  ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentsScreen(
                                          postid: widget.post.postid)));
                            },
                            icon: const Icon(Icons.comment_outlined, size: 22)),
                        if (!widget.isatshare)
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => ShareScreen(
                                            postid: widget.post.postid)));
                              },
                              icon: const Icon(Icons.send, size: 22)),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        IconButton(
                            onPressed: () async {
                              setState(() {
                                _isloading = true;
                              });
                              await StorageMethods().bookMark(
                                context: context,
                                uid: _userprovider.getuserinfo.userid,
                                postid: widget.post.postid,
                              );
                              if (_ismarked) {
                                showsnackbarr(
                                    context, 'Post deleted from book marks');
                              } else {
                                showsnackbarr(
                                    context, 'Post added to book marks');
                              }
                              setState(() {
                                _ismarked = !_ismarked;
                                _isloading = false;
                              });
                            },
                            icon: _ismarked
                                ? const Icon(Icons.bookmark, size: 22)
                                : const Icon(Icons.bookmark_border, size: 22)),
                      ]),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 25, right: 25, bottom: 8),
                      child: Text(
                        '${widget.post.likes.length} Likes',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: RichText(
                        text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                  text: widget.post.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: widget.post.description,
                              )
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                    postid: widget.post.postid)));
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 25, right: 25, top: 5),
                        child: Text(
                          'View all ${widget.post.comments.length.toString()} comment',
                          style: const TextStyle(
                              fontSize: 16, color: secondaryColor),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 25, right: 25, top: 5, bottom: 10),
                      child: Text(
                        DateFormat.yMMMd().format(puplishdate),
                        style: const TextStyle(
                            fontSize: 16, color: secondaryColor),
                      ),
                    )
                  ],
                )),
          );
  }
}
// () async {
//                                 setState(() {
//                                   _isloading = true;
//                                 });
//                                 chatprov.getallmessages(widget.post.ownerid);

//                                 final _snap = await FirebaseFirestore.instance
//                                     .collection('users')
//                                     .doc(widget.post.ownerid)
//                                     .get();
//                                 setState(() {
//                                   _isloading = false;
//                                 });

//                                 final chater = UserModel.fromesnap(_snap);

                               
                              // }