import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:history_cards_app/app_theme.dart';
import 'package:history_cards_app/layouts/drawer_user_controller.dart';
import 'package:history_cards_app/layouts/home_screen.dart';
import 'package:history_cards_app/layouts/leaderboard_view.dart';
import 'package:history_cards_app/layouts/menu_drawer.dart';
import 'package:history_cards_app/layouts/quiz_form.dart';
import 'package:history_cards_app/layouts/quiz_home_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            animationController: (AnimationController animationController) {
              sliderAnimationController = animationController;
            },
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = const MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = QuizHomeScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = QuizForm();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = LeaderBoardView();
        });
      } else {
        setState(() {
          showDialog(
              context: context,
              builder: (_) => NetworkGiffyDialog(
                    key: Key("Network"),
                    image: Image.network(
                      "https://c.tenor.com/d30Yp0RlQRoAAAAd/museum-animated.gif",
                      fit: BoxFit.cover,
                    ),
                    entryAnimation: EntryAnimation.RIGHT,
                    buttonOkText: Text("Ok"),
                    buttonCancelText: Text("Nazaj"),
                    title: Text(
                      'APPLIKACIJA ZA UČENJE ZGODOVINE',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                    ),
                    description: Text(
                      'Aplikacija nudi učenje zgodovine preko kartic s fotografijami muzejskih predmetov.',
                      textAlign: TextAlign.center,
                    ),
                    onOkButtonPressed: () {
                      Navigator.pop(context);
                      screenView = const MyHomePage();
                    },
                    onCancelButtonPressed: () {
                      Navigator.pop(context);
                      screenView = const MyHomePage();
                    },
                  ));
        });
      }
      drawerIndex = DrawerIndex.HOME;
    }
  }
}
