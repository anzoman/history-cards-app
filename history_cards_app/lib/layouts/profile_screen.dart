import 'package:flutter/material.dart';
import 'package:history_cards_app/globals.dart' as globals;

import '../layouts/profile_theme.dart';
import 'stats_screen.dart';

class AppProfileHomeScreen extends StatefulWidget {
  @override
  _AppProfileHomeScreenState createState() => _AppProfileHomeScreenState();
}

class _AppProfileHomeScreenState extends State<AppProfileHomeScreen> with TickerProviderStateMixin {
  AnimationController animationController;

  Widget tabBody = Container(
    color: ProfileAppTheme.background,
  );

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = StatsScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ProfileAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[tabBody],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    globals.userStats = await globals.dataStorage.getUserStats(globals.currentUser);
    return true;
  }
}
