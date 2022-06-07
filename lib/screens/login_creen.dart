import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/resources/utlis.dart';
import 'package:instagram_flutter/screens/responsev_layout_screen.dart';
import 'package:instagram_flutter/screens/signup_screen.dart';
import 'package:instagram_flutter/screens/web_screen_layout.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:instagram_flutter/units/dimentions.dart';
import 'package:instagram_flutter/widgets/text_input_field.dart';

import 'mobile_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cofirm = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> loginuser() async {
    if (_emailController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      String loguserin = await AuthMethods().login(
          email: _emailController.text, password: _passwordController.text);

      showsnackbarr(context, loguserin);

      setState(() {
        _isloading = false;
      });

      if (loguserin == 'success') {
        showsnackbarr(context, 'Loged in');
      }
    } else {
      showsnackbarr(context, 'pleas compllet the field ');
    }
  }

  void changelog() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: _media.height,
      padding: _media.width > wepscreensize
          ? EdgeInsets.symmetric(horizontal: _media.width / 3)
          : EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      width: double.infinity,
      child: Column(
        children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 64,
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
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: loginuser,
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
                        'login',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
            ),
          ),
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    // Platform.isIOS
                    //     ? const EdgeInsets.only(bottom: 18, top: 8):

                    const EdgeInsets.only(bottom: 20, top: 8),
                child: const Text('Don\'t have an account'),
              ),
              const SizedBox(width: 3),
              GestureDetector(
                onTap: changelog,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20, top: 8),
                  child: const Text(
                    'Sign up',
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
