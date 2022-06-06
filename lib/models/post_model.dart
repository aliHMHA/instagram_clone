import 'package:cloud_firestore/cloud_firestore.dart';

class Postmodel {
  final String description;
  final String ownerid;
  final Timestamp puplishdate;
  final String username;
  final String postid;
  final String photoUrl;
  final String profileimageurl;
  final List likes;
  final List comments;

  Postmodel(
      {required this.description,
      required this.puplishdate,
      required this.photoUrl,
      required this.profileimageurl,
      required this.username,
      required this.ownerid,
      required this.postid,
      required this.likes,
      required this.comments});

  static Postmodel fromjson(Map<String, dynamic> json) {
    return Postmodel(
        description: json['description'],
        puplishdate: json['puplishdate'],
        photoUrl: json['photoUrl'],
        username: json['username'],
        profileimageurl: json['profileimageurl'],
        ownerid: json['ownerid'],
        postid: json['postid'],
        likes: json['likes'],
        comments: json['comments']);
  }

  static Postmodel fromesnap(DocumentSnapshot snap) {
    var datta = snap.data() as Map<String, dynamic>;

    return Postmodel(
        description: datta['description'],
        puplishdate: datta['puplishdate'],
        photoUrl: datta['photoUrl'],
        profileimageurl: datta['profileimageurl'],
        username: datta['username'],
        ownerid: datta['ownerid'],
        postid: datta['postid'],
        likes: datta['likes'],
        comments: datta['comments']);
  }

  Map<String, dynamic> tomap() {
    return {
      'description': description,
      'ownerid': ownerid,
      'puplishdate': puplishdate,
      'postid': postid,
      'username': username,
      'photoUrl': photoUrl,
      'profileimageurl': profileimageurl,
      'likes': likes,
      'comments': comments
    };
  }
}
