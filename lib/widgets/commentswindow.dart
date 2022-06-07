import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/comment_model.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/storage_metods.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsWindow extends StatelessWidget {
  final Comment comment;

  const CommentsWindow({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime puplishdate = comment.timedate.toDate();
    final _user = Provider.of<UserProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: mobileBackgroundColor,
          border: Border(top: BorderSide(width: 1))),
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.all(10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            child: SizedBox(
              width: 60,
              height: 60,
              child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder:
                      const AssetImage('assets/images/placeHolder2.jpg'),
                  image: NetworkImage(comment.commenterimage)),
            ),
            radius: 30,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '${comment.commentername} ',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  TextSpan(
                      text: comment.commentText,
                      style: const TextStyle(fontSize: 18, color: Colors.white))
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  DateFormat.yMMMd().format(puplishdate),
                  style: const TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            LikeAnimation(
                duration: const Duration(milliseconds: 200),
                isAnimating: comment.likes.contains(_user.getuserinfo.userid),
                smallLike: true,
                child: IconButton(
                    onPressed: () {
                      StorageMethods().likecomment(
                          commenterid: comment.useridd,
                          context: context,
                          uid: _user.getuserinfo.userid,
                          postid: comment.postid,
                          likes: comment.likes,
                          commentid: comment.commentid);
                    },
                    icon: comment.likes.contains(_user.getuserinfo.userid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          ))),
            Text('${comment.likes.length.toString()}  likes'),
          ],
        ),
      ]),
      // Container(
      //   padding: const EdgeInsets.only(left: 30, top: 10),
      //   alignment: Alignment.centerLeft,
      //   child: Container(
      //     decoration: BoxDecoration(
      //         color: Colors.grey[600],
      //         // border: Border.all(),
      //         borderRadius: BorderRadius.all(Radius.circular(10))),
      //     padding: EdgeInsets.all(8),
      //     child: Text(
      //       comment.commentText,
      //       style: TextStyle(fontSize: 22),
      //     ),
      //   ),
      // ),
    );
  }
}
