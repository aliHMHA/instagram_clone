import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/mesage_model.dart';

import 'package:instagram_flutter/models/usermodel.dart';

class ChatProvider with ChangeNotifier {
  late UserModel _userdata;

  List<MessageModel> _messagelist = [];

  List<MessageModel> get messagelist {
    List<MessageModel> ggtt = _messagelist;
    return ggtt;
  }

  set currentuser(UserModel gggg) {
    _userdata = gggg;
  }

  // Future<void> getAllUsers() {
  //   return FirebaseFirestore.instance.collection('users').get().then((value) {
  //     _allUsers.clear();
  //     value.docs.forEach((element) {
  //       UserModel ff = UserModel.fromjson(element.data());
  //       if (ff.userid != _userdata.uid) {
  //         _allUsers.add(ff);
  //       }
  //     });
  //   });
  // }

  void getallmessages(String chatterid) {
    _messagelist.clear();
    FirebaseFirestore.instance
        .collection('users')
        .doc(_userdata.userid)
        .collection('chats')
        .doc(chatterid)
        .collection('messages')
        .orderBy('timeDate')
        .snapshots()
        .listen((event) {
      _messagelist = [];
      event.docs.forEach((element) {
        _messagelist.add(MessageModel.fromJeson(element.data()));
      });
      notifyListeners();
    });
  }

  void sendamesageto(MessageModel message) {
    CollectionReference fff = FirebaseFirestore.instance.collection('users');

    fff
        .doc(message.userid)
        .collection('chats')
        .doc(message.reseverid)
        .collection('messages')
        .add(message.tomap())
        .then((value) {
      fff
          .doc(message.reseverid)
          .collection('chats')
          .doc(message.userid)
          .collection('messages')
          .add(message.tomap());
    }).then((value) {
      fff
          .doc(message.userid)
          .collection('chats')
          .doc(message.reseverid)
          .collection('messages')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          _messagelist.add(MessageModel.fromJeson(element.data()));
        });
      });
    }).then((value) {
      notifyListeners();
    });
  }

  // final _firestore = FirebaseFirestore.instance;
  // Future<void> likecomment(
  //     {@required String uid,
  //     @required String postid,
  //     @required List likes,
  //     @required String commentid}) async {
  //   try {
  //     if (likes.contains(uid)) {
  //       _firestore
  //           .collection('posts')
  //           .doc(postid)
  //           .collection('comments')
  //           .doc(commentid)
  //           .update({
  //         'likes': FieldValue.arrayRemove([uid])
  //       });
  //     } else {
  //       _firestore
  //           .collection('posts')
  //           .doc(postid)
  //           .collection('comments')
  //           .doc(commentid)
  //           .update({
  //         'likes': FieldValue.arrayUnion([uid])
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
