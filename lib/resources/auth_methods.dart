import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/resources/storage_metods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future<String> signupMethod(
      {required String email,
      required String password,
      required String bio,
      required String username,
      required Uint8List file}) async {
    String res = "an error occurd ";

    try {
      if (email.isNotEmpty &
          password.isNotEmpty &
          bio.isNotEmpty &
          username.isNotEmpty) {
// ok

        String photourl = await StorageMethods().uploadMethod(
            childname: 'users', file: file, uid: null, postid: null);

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String userid = cred.user!.uid;
        UserModel user = UserModel(
            sharerecived: [],
            posts: [],
            email: email,
            bio: bio,
            followers: [],
            following: [],
            bookmarked: [],
            userid: userid,
            username: username,
            photo: photourl);
        await _firestore.collection('users').doc(userid).set(user.tomap());

        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> login(
      {required String email, required String password}) async {
    String res = 'some error happend';

    try {
      if (email.isNotEmpty & password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
