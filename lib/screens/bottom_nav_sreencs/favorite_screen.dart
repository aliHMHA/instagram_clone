import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/widgets/post_card_model.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:instagram_flutter/units/dimentions.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // List<Postmodel> favoritpostlist(
  //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
  //   List<Postmodel> gg = [];
  //   List<Postmodel> postslist = [];
  //   for (var element in snap.data!.docs) {
  //     postslist.add(Postmodel.fromesnap(element));
  //   }

  //   gg = postslist
  //       .where((element) =>
  //           element.likes.contains(FirebaseAuth.instance.currentUser!.uid))
  //       .toList();
  //   return gg;
  // }

  @override
  void initState() {
    super.initState();
    getFavoritPostsid();
  }

  getFavoritPostsid() async {
    _isloading = true;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snap = await FirebaseFirestore.instance.collection('posts').get();

    _favpostsidlist = [];
    for (var element in snap.docs) {
      if (Postmodel.fromesnap(element).likes.contains(uid)) {
        _favpostsidlist.add(Postmodel.fromesnap(element).postid);
      }
    }
    setState(() {
      _isloading = false;
    });
  }

  List<String> _favpostsidlist = [];
  bool _isloading = true;
  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return _isloading
        ? const Center(
            child: CircularProgressIndicator(color: primaryColor),
          )
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
                List<Postmodel> convert() {
                  List<Postmodel> _favpostmodelList = [];

                  for (var element in snapshots.data!.docs) {
                    if (_favpostsidlist
                        .contains(Postmodel.fromesnap(element).postid)) {
                      _favpostmodelList.add(Postmodel.fromesnap(element));
                    }
                  }
                  return _favpostmodelList;
                }

                return Scaffold(
                  body: _media.width > wepscreensize
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: _media.width / 4),
                          child: ListView.builder(
                              itemBuilder: (context, index) => PostCardModel(
                                    isatshare: false,
                                    post: convert()[index],
                                    isformprofile: false,
                                  ),
                              itemCount: convert().length))
                      : ListView.builder(
                          itemBuilder: (context, index) => PostCardModel(
                              isatshare: false,
                              post: convert()[index],
                              isformprofile: false),
                          itemCount: convert().length),
                );
              }
            },
          );
  }
}











// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:instagram_flutter/models/post_model.dart';
// import 'package:instagram_flutter/models/visual_models/post_card_model.dart';
// import 'package:instagram_flutter/units/colors.dart';
// import 'package:instagram_flutter/units/dimentions.dart';

// class FavoriteScreen extends StatefulWidget {
//   const FavoriteScreen({Key? key}) : super(key: key);

//   @override
//   State<FavoriteScreen> createState() => _FavoriteScreenState();
// }

// class _FavoriteScreenState extends State<FavoriteScreen> {
//   @override
//   void initState() {
//     super.initState();
//     getFavoritPosts();
//   }

//   getFavoritPosts() async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     final snap = await FirebaseFirestore.instance.collection('posts').get();
//     List<Postmodel> postslist = [];
//     for (var element in snap.docs) {
//       postslist.add(Postmodel.fromesnap(element));
//     }

//     _favoritepostsId =
//         postslist.where((element) => element.likes.contains(uid)).toList();

//     setState(() {
//       _isloading = false;
//     });
//   }

//   List<Postmodel> _favoritepostsId = [];

//   bool _isloading = true;
//   @override
//   Widget build(BuildContext context) {
//     final _media = MediaQuery.of(context).size;
//     return _isloading
//         ? const Center(
//             child: CircularProgressIndicator(
//               color: primaryColor,
//             ),
//           )
//         : Scaffold(
//             appBar: _media.width > wepscreensize
//                 ? AppBar()
//                 : AppBar(
//                     leadingWidth: 100,
//                     title: SvgPicture.asset(
//                       'assets/ic_instagram.svg',
//                       color: primaryColor,
//                       height: 35,
//                     ),
//                     elevation: 0,
//                   ),
//             body: Container(
//               padding: _media.width > wepscreensize
//                   ? EdgeInsets.symmetric(horizontal: _media.width / 4)
//                   : null,
//               child: ListView.builder(
//                 itemBuilder: ((context, index) =>
//                     PostCardModel(isatshare: false,post: _favoritepostsId[index])),
//                 itemCount: _favoritepostsId.length,
//               ),
//             ));
//   }
// }
