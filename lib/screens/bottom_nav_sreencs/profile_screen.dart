import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/resources/utlis.dart';
import 'package:instagram_flutter/widgets/piview_image.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/post_preview_screen.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:instagram_flutter/units/dimentions.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String profileOnerid;

  const ProfileScreen({
    Key? key,
    required this.profileOnerid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    getdata();
    postStream();
  }

  @override
  void dispose() {
    super.dispose();
    _postsstream.cancel();
  }

  getdata() async {
    _isgetingdata = true;

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileOnerid)
        .get();
    _profilowner = UserModel.fromesnap(snap);
    _isCurrentAfowllower =
        _profilowner.followers.contains(FirebaseAuth.instance.currentUser!.uid);
    _followers = _profilowner.followers.length;
    _following = _profilowner.following.length;

    setState(() {
      _isgetingdata = false;
    });
  }

  List<Postmodel> _postslist = [];
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _postsstream;
  postStream() async {
    try {
      _postslist.clear();
      _postsstream = FirebaseFirestore.instance
          .collection('posts')
          .where('ownerid', isEqualTo: widget.profileOnerid)
          .snapshots()
          .listen((event) {
        _postslist = [];
        for (var element in event.docs) {
          _postslist.add(Postmodel.fromesnap(element));
        }
        setState(() {});
      });
    } catch (err) {
      showsnackbarr(context, err.toString());
    }
  }

  followOrUnfolow(String yourUserid, String theOnetofollowid) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      final snap =
          await _firestore.collection('users').doc(theOnetofollowid).get();
      UserModel theOnetofollow = UserModel.fromesnap(snap);
      if (theOnetofollow.followers.contains(yourUserid)) {
        _firestore.collection('users').doc(theOnetofollow.userid).update({
          'followers': FieldValue.arrayRemove([yourUserid])
        });
        _firestore.collection('users').doc(yourUserid).update({
          'following': FieldValue.arrayRemove([theOnetofollow.userid])
        });
      } else {
        _firestore.collection('users').doc(theOnetofollow.userid).update({
          'followers': FieldValue.arrayUnion([yourUserid])
        });
        _firestore.collection('users').doc(yourUserid).update({
          'following': FieldValue.arrayUnion([theOnetofollow.userid])
        });
      }
    } catch (e) {
      showsnackbarr(context, e.toString());
    }
  }

  bool _isgetingdata = true;

  late UserModel _profilowner;
  late bool _isCurrentAfowllower;
  late int _followers;
  late int _following;
  @override
  Widget build(BuildContext context) {
    final _userprov = Provider.of<UserProvider>(context);
    final _media = MediaQuery.of(context).size;
    final bool _iscurentuser =
        _userprov.getuserinfo.userid == widget.profileOnerid;
    final _isWebScreen = _media.width > wepscreensize;

    return _isgetingdata
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : Scaffold(
            appBar: _isWebScreen ? null : AppBar(),
            body: Container(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (cud) =>
                                      PreviewImage(image: _profilowner.photo)));
                        },
                        child: ClipRRect(
                          borderRadius: _isWebScreen
                              ? BorderRadius.circular(100)
                              : BorderRadius.circular(40),
                          child: CircleAvatar(
                            child: SizedBox(
                              width: _isWebScreen ? 200 : 80,
                              height: _isWebScreen ? 200 : 80,
                              child: FadeInImage(
                                  fit: BoxFit.cover,
                                  placeholder: const AssetImage(
                                      'assets/images/placeHolder1.jpg'),
                                  image: NetworkImage(_profilowner.photo)),
                            ),
                            radius: _isWebScreen ? 100 : 40,
                          ),
                        ),
                      ),
                    ),
                    //  _isWebScreen ? 100 : 40,
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: _media.width * .7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InfoColumn(
                                  num: _profilowner.posts.length,
                                  hhh: 'Posts',
                                ),
                                InfoColumn(
                                  num: _followers,
                                  hhh: 'Followers',
                                ),
                                InfoColumn(
                                  num: _following,
                                  hhh: 'Following',
                                ),
                              ],
                            ),
                          ),
                          _iscurentuser
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      fixedSize: _isWebScreen
                                          ? Size(_media.width * .5,
                                              _media.height * .08)
                                          : Size(_media.width * .65,
                                              _media.width * .1),
                                      onPrimary: Colors.white),
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                  },
                                  child: const Text(
                                    'Log out',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ))
                              : SizedBox(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          fixedSize: _isWebScreen
                                              ? Size(_media.width * .5,
                                                  _media.height * .08)
                                              : Size(_media.width * .65,
                                                  _media.width * .1),
                                          primary: _isCurrentAfowllower
                                              ? Colors.white
                                              : Colors.blue),
                                      onPressed: _isCurrentAfowllower
                                          ? () {
                                              followOrUnfolow(
                                                  _userprov.getuserinfo.userid,
                                                  widget.profileOnerid);
                                              setState(() {
                                                _followers--;
                                                _isCurrentAfowllower = false;
                                              });
                                            }
                                          : () {
                                              followOrUnfolow(
                                                  _userprov.getuserinfo.userid,
                                                  widget.profileOnerid);
                                              setState(() {
                                                _followers++;
                                                _isCurrentAfowllower = true;
                                              });
                                            },
                                      child: _isCurrentAfowllower
                                          ? const Text(
                                              'Unfollow',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black),
                                            )
                                          : const Text(
                                              'Follow',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            )),
                                ),
                        ]),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: _isWebScreen
                            ? const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5)
                            : const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                        child: Text(
                          _profilowner.username,
                          style: _isWebScreen
                              ? const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)
                              : const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: _isWebScreen
                            ? const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5)
                            : const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                        child: Text(
                          _profilowner.bio,
                          style: _isWebScreen
                              ? const TextStyle(
                                  fontSize: 20, color: Colors.grey)
                              : const TextStyle(
                                  fontSize: 15, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            const QuiltedGridTile(2, 2),
                            const QuiltedGridTile(1, 1),
                            const QuiltedGridTile(1, 1),
                            const QuiltedGridTile(1, 2),
                          ],
                        ),
                        itemCount: _postslist.length,
                        itemBuilder: (context, ind) {
                          return InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => PostPreviwScreen(
                                            postid: _postslist[ind].postid,
                                            isfromprofile: true,
                                          )));
                            }),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(
                                  'assets/images/placeHolder2.jpg'),
                              image: NetworkImage(
                                _postslist[ind].photoUrl,
                              ),
                            ),
                          );
                        }))
              ]),
            ));
  }
}

class InfoColumn extends StatelessWidget {
  final String hhh;
  final int num;
  const InfoColumn({Key? key, required this.num, required this.hhh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            num.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            hhh,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
