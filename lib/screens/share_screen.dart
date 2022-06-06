import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/widgets/post_card_model.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/storage_metods.dart';
import 'package:instagram_flutter/resources/utlis.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:provider/provider.dart';

class ShareScreen extends StatefulWidget {
  final String postid;
  const ShareScreen({Key? key, required this.postid}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final TextEditingController _controllersersh = TextEditingController();
  final TextEditingController _controllermessage = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controllersersh.dispose();
    _controllermessage.dispose();
  }

  @override
  void initState() {
    super.initState();
    getuser();
  }

  getuser() async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    _user = UserModel.fromesnap(snap);

    setState(() {});
  }

  late UserModel _user;

  bool _isloading = false;
  UserModel? targetedUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: targetedUser == null
                ? TextField(
                    style: const TextStyle(fontSize: 22),
                    controller: _controllersersh,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 22, color: Colors.blue),
                        hintText: 'Searsh for users here.',
                        border: InputBorder.none),
                    onChanged: (ff) {
                      setState(() {});
                    },
                  )
                : TextField(
                    style: const TextStyle(fontSize: 22),
                    controller: _controllermessage,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 22, color: Colors.blue),
                        hintText: 'Say something about it.',
                        border: InputBorder.none),
                  )),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: _controllersersh.text)
              .get(),
          builder:
              (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              return targetedUser == null
                  ? ListView.builder(
                      itemCount: snap.data!.docs.length,
                      itemBuilder: ((context, index) {
                        UserModel randomuser =
                            UserModel.fromesnap(snap.data!.docs[index]);
                        return Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 10, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(randomuser.photo),
                                  radius: 30,
                                ),
                                Expanded(
                                    child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    randomuser.username,
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                )),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      targetedUser = randomuser;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.check_box_outline_blank_outlined,
                                    size: 25,
                                    color: Colors.blue[400],
                                  ),
                                )
                              ],
                            ));
                      }))
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postid)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snap) {
                        if (snap.connectionState == ConnectionState.waiting ||
                            snap.connectionState == ConnectionState.none ||
                            snap.connectionState == ConnectionState.done) {
                          return const CircularProgressIndicator(
                            color: primaryColor,
                          );
                        } else {
                          Postmodel posttoshar =
                              Postmodel.fromesnap(snap.data!);
                          return Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 10,
                                              top: 10,
                                              bottom: 10),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    targetedUser!.photo),
                                                radius: 30,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  targetedUser!.username,
                                                  style: const TextStyle(
                                                      fontSize: 25),
                                                ),
                                              )),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    targetedUser = null;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.check_box_rounded,
                                                  size: 25,
                                                  color: Colors.blue[400],
                                                ),
                                              )
                                            ],
                                          )),
                                      PostCardModel(
                                          isatshare: true,
                                          post: posttoshar,
                                          isformprofile: true),
                                      ElevatedButton(
                                          onPressed: () async {
                                            if (_controllermessage
                                                .text.isNotEmpty) {
                                              await StorageMethods().share(
                                                  reciverid:
                                                      targetedUser!.userid,
                                                  postid: widget.postid,
                                                  message:
                                                      _controllermessage.text,
                                                  sendername: _user.username,
                                                  senderimageurl: _user.photo,
                                                  context: context);
                                              Navigator.pop(context);
                                            } else {
                                              showsnackbarr(context,
                                                  'pleas write a message first');
                                            }
                                          },
                                          child: const Text(
                                            'Share',
                                            style: TextStyle(
                                              fontSize: 25,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      });
            }
          },
        ));
  }
}
