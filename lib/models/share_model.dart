import 'package:cloud_firestore/cloud_firestore.dart';

class Sharemodel {
  String senderid;
  String shareid;
  String reciverid;
  Timestamp timedate;
  String postid;
  String message;
  String senderimageurl;
  String sendername;

  Sharemodel(
      {required this.timedate,
      required this.reciverid,
      required this.senderid,
      required this.shareid,
      required this.postid,
      required this.message,
      required this.senderimageurl,
      required this.sendername});

  static Sharemodel fromjson(Map<String, dynamic> json) {
    return Sharemodel(
        senderid: json['senderid'],
        shareid: json['shareid'],
        timedate: json['timedate'],
        postid: json['postid'],
        reciverid: json['reciverid'],
        message: json['message'],
        senderimageurl: json['senderimageurl'],
        sendername: json['sendername']);
  }

  static Sharemodel fromsnap(DocumentSnapshot snap) {
    var json = snap.data() as Map<String, dynamic>;
    return Sharemodel(
        senderid: json['senderid'],
        shareid: json['shareid'],
        timedate: json['timedate'],
        postid: json['postid'],
        reciverid: json['reciverid'],
        message: json['message'],
        senderimageurl: json['senderimageurl'],
        sendername: json['sendername']);
  }

  Map<String, dynamic> tomap() {
    return {
      'shareid': shareid,
      'senderid': senderid,
      'timedate': timedate,
      'postid': postid,
      'reciverid': reciverid,
      'message': message,
      'senderimageurl': senderimageurl,
      'sendername': sendername
    };
  }
}
