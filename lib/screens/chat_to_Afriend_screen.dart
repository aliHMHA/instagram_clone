import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/mesage_model.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/providers/chat_provider.dart';
import 'package:instagram_flutter/providers/user_provider.dart';

import 'package:provider/provider.dart';

class ChatToAFriendScreen extends StatefulWidget {
  final UserModel currentChater;

  const ChatToAFriendScreen({Key? key, required this.currentChater})
      : super(key: key);

  @override
  State<ChatToAFriendScreen> createState() => _ChatToAFriendScreenState();
}

class _ChatToAFriendScreenState extends State<ChatToAFriendScreen> {
  final _controller = TextEditingController();
  static const chattofriendrout = 'Chatscreen./';

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final userProvfdg = Provider.of<UserProvider>(context);
    final chateprove = Provider.of<ChatProvider>(context);
    final messagelist = Provider.of<ChatProvider>(context).messagelist;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
                margin: EdgeInsets.only(right: 20),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.currentChater.photo),
                  radius: 20,
                )),
            Text(widget.currentChater.username)
          ],
        ),
      ),
      body: // SingleChildScrollView(
          Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: messagelist.length,
                  itemBuilder: (ctx, inde) {
                    if (messagelist[inde].userid ==
                        userProvfdg.getuserinfo.userid) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 30),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 25, 7, 105),
                              borderRadius: BorderRadiusDirectional.only(
                                  bottomStart: Radius.circular(20),
                                  topEnd: Radius.circular(20),
                                  topStart: Radius.circular(20))),
                          child: Text(
                            messagelist[inde].messageText,
                            style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 30),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 103, 6, 17),
                              borderRadius: BorderRadiusDirectional.only(
                                  bottomEnd: Radius.circular(20),
                                  topEnd: Radius.circular(20),
                                  topStart: Radius.circular(20))),
                          child: Text(
                            messagelist[inde].messageText,
                            style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: Colors.grey.shade400)),
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  // width: media.width * .7,
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: _controller,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        label: Text(
                          'Enter a message ...',
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
                MaterialButton(
                  color: Colors.amber,
                  minWidth: 1,
                  child: Container(
                    height: media.width * .16,
                    child: const Icon(Icons.send),
                  ),
                  onPressed: () {
                    chateprove.sendamesageto(MessageModel(
                        userid: userProvfdg.getuserinfo.userid,
                        reseverid: widget.currentChater.userid,
                        messageText: _controller.text,
                        timeDate: DateTime.now().toString()));
                    _controller.clear();
                  },
                )
              ],
            ),
          ),
        ],
      ),
      // ),
    );
  }
}







// Align(
//               alignment: Alignment.centerRight,
//               child: Container(
//                 padding: EdgeInsets.all(20),
//                 margin: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 205, 232, 179),
//                     borderRadius: BorderRadiusDirectional.only(
//                         bottomStart: Radius.circular(20),
//                         topEnd: Radius.circular(20),
//                         topStart: Radius.circular(20))),
//                 child: Text(
//                   'fdgtfdhjjgdsfewvmdsvjmgv',
//                   style: TextStyle(
//                       fontSize: 15,
//                       fontFamily: 'Raleway',
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//             );