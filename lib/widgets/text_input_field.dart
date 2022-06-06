import 'package:flutter/material.dart';

class Textfieldinput extends StatelessWidget {
  final TextEditingController textcontroller;
  final String hinttext;
  final bool ispassword;
  final TextInputType texttype;

  const Textfieldinput(
      {Key? key,
      required this.hinttext,
      required this.textcontroller,
      required this.ispassword,
      required this.texttype})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return TextField(
      controller: textcontroller,
      decoration: InputDecoration(
        border: inputBorder,
        hintText: hinttext,
      ),
      keyboardType: texttype,
      obscureText: ispassword,
    );
  }
}
