import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/add_screen.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/favorite_screen.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/home_screen.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/profile_screen.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/searsh_screen.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  int _index = 0;

  final PageController _pageController = PageController();
  void pagechange(int pageind) {
    setState(() {
      _index = pageind;
    });
  }

  void navigationtaped(int pageind) {
    _pageController.jumpToPage(pageind);
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    UserModel user = userprovider.getuserinfo;
    return Scaffold(
        body: PageView(
          children: [
            const HomeScreen(),
            const FavoriteScreen(),
            const AddScreen(),
            const SearshScreen(),
            ProfileScreen(
              profileOnerid: user.userid,
            )
          ],
          controller: _pageController,
          onPageChanged: pagechange,
        ),
        bottomNavigationBar: CupertinoTabBar(
            // currentIndex: _index,
            onTap: navigationtaped,
            // activeColor: primaryColor,
            backgroundColor: mobileBackgroundColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _index == 0 ? primaryColor : secondaryColor,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite,
                    color: _index == 1 ? primaryColor : secondaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,
                    color: _index == 2 ? primaryColor : secondaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search,
                    color: _index == 3 ? primaryColor : secondaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: _index == 4 ? primaryColor : secondaryColor),
                label: '',
              ),
            ]));
  }
}
