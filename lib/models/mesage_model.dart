import 'package:flutter/material.dart';

class MessageModel {
  String userid;
  String reseverid;
  String messageText;
  String timeDate;

  MessageModel(
      {required this.userid,
      required this.reseverid,
      required this.messageText,
      required this.timeDate});

  static MessageModel fromJeson(Map<String, dynamic> json) {
    return MessageModel(
        userid: json['userid'],
        reseverid: json['reseverid'],
        messageText: json['messageText'],
        timeDate: json['timeDate']);
  }

  Map<String, dynamic> tomap() {
    return {
      'userid': userid,
      'reseverid': reseverid,
      'messageText': messageText,
      'timeDate': timeDate
    };
  }
}
