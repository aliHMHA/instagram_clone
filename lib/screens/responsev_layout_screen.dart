import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/login_creen.dart';
import 'package:instagram_flutter/screens/mobile_screen_layout.dart';
import 'package:instagram_flutter/screens/web_screen_layout.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:provider/provider.dart';

class ResponsevLayoutScreen extends StatefulWidget {
  const ResponsevLayoutScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ResponsevLayoutScreen> createState() => _ResponsevLayoutScreenState();
}

class _ResponsevLayoutScreenState extends State<ResponsevLayoutScreen> {
  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    return FutureBuilder(
        future: userprovider.refreshuserr(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  //web layout
                  return const WebScreenLayout();
                } else {
                  //mobile layout
                  return const MobileScreenLayout();
                }
              });
            } else if (snapshot.hasError) {
              return const Scaffold(
                  body: Center(
                child: Text(
                  'An error occuerd',
                  style: TextStyle(fontSize: 40),
                ),
              ));
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            );
          }
          return const LoginScreen();
        });
  }
}
