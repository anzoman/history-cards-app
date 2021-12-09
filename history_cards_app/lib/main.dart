import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:history_cards_app/app_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:splashscreen/splashscreen.dart';

import 'layouts/login_register.dart';
import 'layouts/question.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) => runApp(App()));
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
        title: 'Aplikacija za učenje zgodovine',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.android,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: new SplashScreen(
            seconds: 5,
            navigateAfterSeconds: new LoginScreen(),
            title: new Text(
              'APLIKACIJA\nZA UČENJE ZGODOVINE',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 45.0,
                fontFamily: "BalooBhai",
              ),
              textAlign: TextAlign.center,
            ),
            image: new Image.asset('assets/images/icon_history.png'),
            backgroundColor: Colors.black,
            loadingText: new Text(
              "Kartice s fotografijami predmetov",
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.yellow,
                fontFamily: "Pacifico",
              ),
            ),
            photoSize: 100.0,
            loaderColor: Colors.white));
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
