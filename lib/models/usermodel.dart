import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String userid;
  String bio;
  String username;
  List followers;
  List following;
  List posts;
  List bookmarked;
  List sharerecived;
  String photo;

  UserModel(
      {required this.email,
      required this.bio,
      required this.followers,
      required this.following,
      required this.posts,
      required this.bookmarked,
      required this.sharerecived,
      required this.userid,
      required this.username,
      required this.photo});

  static UserModel fromjson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'],
        bio: json['bio'],
        followers: json['followers'],
        following: json['following'],
        posts: json['posts'],
        bookmarked: json['bookmarked'],
        sharerecived: json['sharerecived'],
        userid: json['userid'],
        username: json['username'],
        photo: json['photo']);
  }

  static UserModel fromesnap(DocumentSnapshot snap) {
    var datta = snap.data() as Map<String, dynamic>;

    return UserModel(
        email: datta['email'],
        bio: datta['bio'],
        followers: datta['followers'],
        following: datta['following'],
        posts: datta['posts'],
        bookmarked: datta['bookmarked'],
        sharerecived: datta['sharerecived'],
        userid: datta['userid'],
        username: datta['username'],
        photo: datta['photo']);
  }

  Map<String, dynamic> tomap() {
    return {
      'email': email,
      'userid': userid,
      'bio': bio,
      'username': username,
      'followers': followers,
      'following': following,
      'posts': posts,
      'bookmarked': bookmarked,
      'sharerecived': sharerecived,
      'photo': photo
    };
  }
}
