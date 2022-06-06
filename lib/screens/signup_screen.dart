import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/resources/storage_metods.dart';
import 'package:instagram_flutter/resources/utlis.dart';
import 'package:instagram_flutter/screens/login_creen.dart';
import 'package:instagram_flutter/screens/mobile_screen_layout.dart';
import 'package:instagram_flutter/screens/responsev_layout_screen.dart';
import 'package:instagram_flutter/screens/web_screen_layout.dart';
import 'package:instagram_flutter/units/dimentions.dart';
import '../units/colors.dart';

import '../widgets/text_input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();

  Uint8List? _imagefile;
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _confirmpassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    // Pick an image

    Future<void> adduser() async {
      if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _bioController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _imagefile == null) {
        showsnackbarr(context, 'pleas enter the fields and a pic');
      } else {
        setState(() {
          _isloading = true;
        });
        String finshmessage = await AuthMethods().signupMethod(
            email: _emailController.text,
            password: _passwordController.text,
            bio: _bioController.text,
            username: _usernameController.text,
            file: _imagefile!);
        showsnackbarr(context, finshmessage);
        setState(() {
          _isloading = false;
        });

        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.of(context).pop();
        }

        if (finshmessage == 'success') {
          showsnackbarr(context, 'signed up');
        }
      }
    }

    void changelod() {
      Navigator.of(context).pop();
    }

    return Scaffold(
        body: Container(
      padding: _media.width > wepscreensize
          ? EdgeInsets.symmetric(horizontal: _media.width / 3)
          : const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 20,
                  ),
                  Stack(
                    children: [
                      _imagefile != null
                          ? CircleAvatar(
                              radius: 70,
                              backgroundImage: MemoryImage(_imagefile!))
                          : const CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  AssetImage('assets/images/placeHolder3.jpg'),
                            ),
                      Positioned(
                        child: IconButton(
                          onPressed: () async {
                            _imagefile = await StorageMethods()
                                .showdialogforimagepick(
                                    context: context, media: _media);
                            setState(() {});
                          },
                          icon: const Icon(Icons.add_a_photo),
                          iconSize: 35,
                        ),
                        right: 1,
                        bottom: 1,
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  Textfieldinput(
                      hinttext: 'Enter your email',
                      textcontroller: _emailController,
                      ispassword: false,
                      texttype: TextInputType.emailAddress),
                  const SizedBox(height: 24),
                  Textfieldinput(
                      hinttext: 'Enter your password',
                      textcontroller: _passwordController,
                      ispassword: true,
                      texttype: TextInputType.emailAddress),
                  const SizedBox(height: 24),
                  Textfieldinput(
                      hinttext: 'Enter your username',
                      textcontroller: _usernameController,
                      ispassword: false,
                      texttype: TextInputType.text),
                  const SizedBox(height: 24),
                  Textfieldinput(
                      hinttext: 'Enter your bio',
                      textcontroller: _bioController,
                      ispassword: false,
                      texttype: TextInputType.text),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: adduser,
              child: Container(
                // decoration: BoxDecoration(
                //     color: Colors.blue,
                //     borderRadius: const BorderRadius.all(Radius.circular(10))),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                child: _isloading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text('Don\'t have an account'),
              ),
              const SizedBox(width: 3),
              GestureDetector(
                onTap: changelod,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
