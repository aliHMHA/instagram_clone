import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/comment_model.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/models/share_model.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/resources/utlis.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadMethod(
      {required String? uid,
      required String childname,
      required Uint8List file,
      required String? postid}) async {
    Reference reff;
    if (uid == null) {
      reff = _storage.ref().child(childname);
    } else {
      reff = _storage.ref().child(childname).child(uid);
    }

    if (postid != null) {
      reff = reff.child(postid);
    }

    UploadTask up = reff.putData(file);
    TaskSnapshot snap = await up;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }

  Future<void> deletallcomments(List cimmentidlist, String postid) async {
    return;
  }

  Future<void> deletepost(
      {required String postid,
      required String userid,
      required String postownerid,
      required BuildContext contxt,
      required List commentlist}) async {
    Reference reff =
        _storage.ref().child('posts').child(postownerid).child(postid);
    if (userid == postownerid) {
      for (String element in commentlist) {
        final refcomment =
            _firestore.collection('posts').doc(postid).collection('comments');

        await refcomment.doc(element).delete();
      }

      await _firestore.collection('posts').doc(postid).delete();
      await _firestore.collection('users').doc(userid).update({
        'posts': FieldValue.arrayRemove([postid])
      });
      await reff.delete();

      showsnackbarr(contxt, 'Post deleted');
    } else {
      showsnackbarr(contxt, 'You are not the owner');
    }
  }

  Future<String> postimage(
      {required String uid,
      required String description,
      required Uint8List image,
      required String username,
      required String profileimageurl}) async {
    String res = 'some thing went wrong';
    String postid = const Uuid().v1();
    try {
      String imageurl = await uploadMethod(
          uid: uid, childname: 'posts', file: image, postid: postid);

      Postmodel postttte = Postmodel(
          username: username,
          description: description,
          puplishdate: Timestamp.fromDate(DateTime.now()),
          photoUrl: imageurl,
          profileimageurl: profileimageurl,
          ownerid: uid,
          postid: postid,
          likes: [],
          comments: []);

      await _firestore.collection('posts').doc(postid).set(postttte.tomap());

      await _firestore.collection('users').doc(uid).update({
        'posts': FieldValue.arrayUnion([postid])
      });
      res = 'Image posted';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> likecomment(
      {required String uid,
      required String postid,
      required List likes,
      required String commentid,
      required String commenterid,
      required BuildContext context}) async {
    try {
      if (likes.contains(uid)) {
        _firestore
            .collection('posts')
            .doc(postid)
            .collection('comments')
            .doc(commentid)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(commenterid).update({
          'likes': FieldValue.arrayRemove([uid + commentid])
        });
      } else {
        _firestore
            .collection('posts')
            .doc(postid)
            .collection('comments')
            .doc(commentid)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(commenterid).update({
          'likes': FieldValue.arrayUnion([uid + commentid])
        });
      }
    } catch (e) {
      showsnackbarr(context, e.toString());
    }
  }

  Future<void> likePost(
      {required postownerid,
      required String uid,
      required String postid,
      required List likes,
      required BuildContext context}) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(postownerid).update({
          'likes': FieldValue.arrayRemove([uid + postid])
        });
      }
    } catch (e) {
      showsnackbarr(context, e.toString());
    }
  }

  Future<void> bookMark(
      {required String uid,
      required String postid,
      required BuildContext context}) async {
    try {
      final snap = await _firestore.collection('users').doc(uid).get();
      final _user = UserModel.fromesnap(snap);

      if (_user.bookmarked.contains(postid)) {
        _firestore.collection('users').doc(uid).update({
          'bookmarked': FieldValue.arrayRemove([postid])
        });
      } else {
        _firestore.collection('users').doc(uid).update({
          'bookmarked': FieldValue.arrayUnion([postid])
        });
      }
    } catch (e) {
      showsnackbarr(context, e.toString());
    }
  }

  Future<void> commentpost(Comment comment, BuildContext context) async {
    final ref = _firestore.collection('posts').doc(comment.postid);
    try {
      await ref
          .collection('comments')
          .doc(comment.commentid)
          .set(comment.tomap());

      await ref.update({
        'comments': FieldValue.arrayUnion([comment.commentid])
      });
    } catch (err) {
      showsnackbarr(context, err.toString());
    }
  }

  Future<void> share(
      {required String reciverid,
      required String postid,
      required String message,
      required String sendername,
      required String senderimageurl,
      required BuildContext context}) async {
    String shareid = const Uuid().v1();
    Timestamp time = Timestamp.fromDate(DateTime.now());
    String senderid = FirebaseAuth.instance.currentUser!.uid;
    Sharemodel share = Sharemodel(
        postid: postid,
        timedate: time,
        reciverid: reciverid,
        senderid: senderid,
        shareid: shareid,
        message: message,
        senderimageurl: senderimageurl,
        sendername: sendername);
    try {
      await _firestore
          .collection('users')
          .doc(reciverid)
          .collection('share')
          .doc(shareid)
          .set(share.tomap());
      await _firestore.collection('users').doc(reciverid).update({
        'sharerecived': FieldValue.arrayUnion([shareid])
      });
      await _firestore
          .collection('users')
          .doc(senderid)
          .collection('share')
          .doc(shareid)
          .set(share.tomap());

      showsnackbarr(context, 'shared successfully');
    } catch (err) {
      showsnackbarr(context, err.toString());
    }
  }

  Future<Uint8List?> showdialogforimagepick(
      {required BuildContext context, required Size media}) async {
    Uint8List? image;

    XFile? ggh;

    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: const Text('Select image'),
              content: Container(
                padding: const EdgeInsets.only(top: 10),
                width: media.width * .5,
                height: media.height * .25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        ggh = await imagepicker(ImageSource.gallery, context);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 50),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: media.height * .1,
                        child: const Text('From gallary',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        ggh = await imagepicker(ImageSource.camera, context);

                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 50),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: media.height * .1,
                        child: const Text('From camera',
                            style: TextStyle(fontSize: 20)),
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 161, 95, 172),
                      ),
                    ))
              ],
            ));
    if (ggh == null) {
      return image;
    } else {
      image = await ggh!.readAsBytes();
      return image;
    }
  }
}
