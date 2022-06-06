import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/models/usermodel.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/add_screen.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/favorite_screen.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/home_screen.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/profile_screen.dart';
import 'package:instagram_flutter/screens/bottom_nav_sreencs/searsh_screen.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:provider/provider.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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
      appBar: AppBar(
          leadingWidth: 100,
          leading: SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 25,
          ),
          actions: [
            IconButton(
              onPressed: () => navigationtaped(0),
              icon: Icon(
                Icons.home,
                color: _index == 0 ? primaryColor : secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => navigationtaped(1),
              icon: Icon(Icons.favorite,
                  color: _index == 1 ? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: () => navigationtaped(2),
              icon: Icon(Icons.add_circle,
                  color: _index == 2 ? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: () => navigationtaped(3),
              icon: Icon(Icons.search,
                  color: _index == 3 ? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: () => navigationtaped(4),
              icon: Icon(Icons.person,
                  color: _index == 4 ? primaryColor : secondaryColor),
            ),
          ]),
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
    );
  }
}
//  bottomNavigationBar: CupertinoTabBar(
//             // currentIndex: _index,
//             onTap: navigationtaped,
//             // activeColor: primaryColor,
//             backgroundColor: mobileBackgroundColor,
//             items: [
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.home,
//                   color: _index == 0 ? primaryColor : secondaryColor,
//                 ),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.favorite,
//                     color: _index == 1 ? primaryColor : secondaryColor),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.add_circle,
//                     color: _index == 2 ? primaryColor : secondaryColor),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.search,
//                     color: _index == 3 ? primaryColor : secondaryColor),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person,
//                     color: _index == 4 ? primaryColor : secondaryColor),
//                 label: '',
//               ),
//             ])