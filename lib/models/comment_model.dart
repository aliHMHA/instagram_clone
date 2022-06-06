import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String useridd;
  String postid;
  Timestamp timedate;
  String commentText;
  String commenterimage;
  String commentername;
  List likes;
  String commentid;

  Comment(
      {required this.commentText,
      required this.timedate,
      required this.postid,
      required this.useridd,
      required this.commenterimage,
      required this.commentername,
      required this.likes,
      required this.commentid});

  static Comment fromjson(Map<String, dynamic> json) {
    return Comment(
        useridd: json['userid'],
        timedate: json['timedate'],
        commentText: json['commenttext'],
        postid: json['postid'],
        commenterimage: json['commenterimage'],
        commentername: json['commentername'],
        likes: json['likes'],
        commentid: json['commentid']);
  }

  static Comment fromsnap(DocumentSnapshot snap) {
    final json = snap.data() as Map<String, dynamic>;
    return Comment(
        useridd: json['userid'],
        timedate: json['timedate'],
        commentText: json['commenttext'],
        postid: json['postid'],
        commenterimage: json['commenterimage'],
        commentername: json['commentername'],
        likes: json['likes'],
        commentid: json['commentid']);
  }

  Map<String, dynamic> tomap() {
    return {
      'userid': useridd,
      'timedate': timedate,
      'commenttext': commentText,
      'postid': postid,
      'commenterimage': commenterimage,
      'commentername': commentername,
      'likes': likes,
      'commentid': commentid
    };
  }
}
