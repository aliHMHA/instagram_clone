import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/profile_screen.dart';
import 'package:instagram_flutter/screens/post_preview_screen.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:provider/provider.dart';

class SearshScreen extends StatefulWidget {
  const SearshScreen({Key? key}) : super(key: key);

  @override
  State<SearshScreen> createState() => _SearshScreenState();
}

class _SearshScreenState extends State<SearshScreen> {
  final _controller = TextEditingController();

  bool _isshowing = false;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextField(
          style: const TextStyle(fontSize: 22),
          controller: _controller,
          decoration: const InputDecoration(
              hintStyle: TextStyle(fontSize: 22, color: Colors.blue),
              hintText: 'Searsh for users here.',
              border: InputBorder.none),
          onChanged: (ff) {
            if (ff.isEmpty) {
              _isshowing = false;
            } else {
              _isshowing = true;
            }
            setState(() {});
          },
        )),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: _controller.text)
              .get(),
          builder:
              (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              return _isshowing
                  ? ListView.builder(
                      itemCount: snap.data!.docs.length,
                      itemBuilder: ((context, index) {
                        UserModel _postowner =
                            UserModel.fromesnap(snap.data!.docs[index]);
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => ProfileScreen(
                                        profileOnerid: _postowner.userid,
                                      )),
                            );
                          },
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, top: 10, bottom: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(_postowner.photo),
                                    radius: 30,
                                  ),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _postowner.username,
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                  ))
                                ],
                              )),
                        );
                      }))
                  : FutureBuilder(
                      future:
                          FirebaseFirestore.instance.collection('posts').get(),
                      builder: (ctx,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snap) {
                        if (!snap.hasData) {
                          return const Center(
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor)),
                          );
                        }

                        return GridView.builder(
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
                            itemCount: snap.data!.docs.length,
                            itemBuilder: (context, ind) {
                              return InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => PostPreviwScreen(
                                              postid: snap.data!.docs[ind]
                                                  ['postid'],
                                              isfromprofile: false,
                                            ))),
                                child: FadeInImage(
                                  placeholder: AssetImage(
                                      'assets/images/placeHolder2.jpg'),
                                  image: NetworkImage(
                                      snap.data!.docs[ind]['photoUrl']),
                                  fit: BoxFit.cover,
                                ),
                              );
                            });
                      });
            }
          },
        ));
  }
}
