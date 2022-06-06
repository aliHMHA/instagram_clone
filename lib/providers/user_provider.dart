import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/models/usermodel.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  final _firestore = FirebaseFirestore.instance;

  UserModel get getuserinfo => _user!;

  Future<String> refreshuserr() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    var userinfo = await _firestore.collection('users').doc(uid).get();
    UserModel gg = UserModel.fromesnap(userinfo);
    _user = gg;
    return gg.username;
  }

  Future<List<Postmodel>> getUserPosts(List postsuidList) async {
    List<Postmodel> _postModelList = [];
    final ref = FirebaseFirestore.instance.collection('posts');
    for (var element in postsuidList) {
      final snap = await ref.doc(element).get();
      _postModelList.add(Postmodel.fromesnap(snap));
      notifyListeners();
    }
    return _postModelList;
  }
}
