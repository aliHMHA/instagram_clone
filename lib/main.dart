import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/login_creen.dart';
import 'package:instagram_flutter/screens/responsev_layout_screen.dart';
import 'package:instagram_flutter/units/colors.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyC3UzFTeng4oU1ELOQEgvHqtgfWvYlZLYc',
            appId: '1:891909709523:web:5323ceed17023a1a083e26',
            messagingSenderId: '891909709523',
            projectId: 'instagram-flutter-487ff',
            storageBucket: 'instagram-flutter-487ff.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    internitconiction();
  }

  late StreamSubscription<ConnectivityResult> subscription;
  internitconiction() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          _isconnected = false;
        });
      } else {
        setState(() {
          _isconnected = true;
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  bool _isconnected = true;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Instagram Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(
                backgroundColor: mobileBackgroundColor,
                elevation: 0,
                actionsIconTheme:
                    IconThemeData(color: Color.fromARGB(255, 131, 9, 153))),
            scaffoldBackgroundColor: mobileBackgroundColor,
            primaryColor: Colors.white),
        home: !_isconnected
            ? Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.error_outline_sharp,
                        size: 100,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No internet connection',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        'pleas check it',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              )
            : StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshote) {
                  if (snapshote.connectionState == ConnectionState.active) {
                    if (snapshote.hasData) {
                      return const ResponsevLayoutScreen();
                    } else if (snapshote.hasError) {
                      return const Center(
                        child: Text('some error happend'),
                      );
                    }
                  }
                  if (snapshote.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                  return const LoginScreen();
                },
              ),
      ),
    );
  }
}
