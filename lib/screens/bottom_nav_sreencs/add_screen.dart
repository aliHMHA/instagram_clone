import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/storage_metods.dart';
import 'package:instagram_flutter/resources/utlis.dart';
import 'package:instagram_flutter/units/colors.dart';

import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Uint8List? _pickedimage;
  final _controller = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userprovider = Provider.of<UserProvider>(context);
    final UserModel _user = _userprovider.getuserinfo;
    final _media = MediaQuery.of(context).size;

    return _pickedimage != null
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    _controller.clear();
                    _pickedimage = null;
                  });
                },
              ),
              title: const Text('The Post'),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: TextButton(
                      onPressed: () async {
                        if (_controller.text.isEmpty) {
                          showsnackbarr(
                              context, 'pleas enter a description first');
                        } else {
                          setState(() {
                            _isloading = true;
                          });
                          String res = await StorageMethods().postimage(
                              uid: _user.userid,
                              description: _controller.text,
                              image: _pickedimage!,
                              username: _user.username,
                              profileimageurl: _user.photo);

                          showsnackbarr(context, res);
                          setState(() {
                            _isloading = false;
                            _controller.clear();
                            _pickedimage = null;
                          });
                        }
                      },
                      child: _isloading
                          ? const CircularProgressIndicator(
                              color: primaryColor,
                            )
                          : const Text(
                              'Post',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.purple),
                            )),
                )
              ],
            ),
            body: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CircleAvatar(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: const AssetImage(
                                'assets/images/placeHolder1.jpg'),
                            image:
                                NetworkImage(_userprovider.getuserinfo.photo)),
                      ),
                      radius: 30,
                    ),
                  ),
                  SizedBox(
                      width: _media.width * .5,
                      child: TextFormField(
                        style: const TextStyle(fontSize: 19),
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: InputBorder.none),
                        controller: _controller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pleas enter some thing first';
                          }
                          return null;
                        },
                      )),
                  SizedBox(
                    width: _media.width * .2,
                    height: _media.width * .2,
                    child: Image.memory(_pickedimage!),
                  )
                ],
              ),
            ),
          )
        : Center(
            child: IconButton(
                onPressed: () async {
                  _pickedimage = await StorageMethods()
                      .showdialogforimagepick(context: context, media: _media);
                  setState(() {});
                },
                iconSize: 50,
                icon: const Icon(
                  Icons.upload,
                )),
          );
  }
}
