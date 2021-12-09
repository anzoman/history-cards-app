import 'package:history_cards_app/layouts/leaderboard_view.dart';
import 'package:history_cards_app/layouts/quiz_form.dart';
import 'package:history_cards_app/layouts/quiz_home_screen.dart';
import 'package:history_cards_app/layouts/profile_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
    HomeList({
        this.navigateScreen,
        this.imagePath = '',
    });

    Widget navigateScreen;
    String imagePath;

    static List<HomeList> homeList = [
        HomeList(
            imagePath: 'assets/images/q_a_icon.png',
            navigateScreen: QuizHomeScreen(),
        ),
        HomeList(
            imagePath: 'assets/images/add_icon.png',
            navigateScreen: QuizForm(),
        ),
        HomeList(
            imagePath: 'assets/images/leaderboard_icon.png',
            navigateScreen: LeaderBoardView(),
        ),
        HomeList(
            imagePath: 'assets/images/user_icon.png',
            navigateScreen: AppProfileHomeScreen(),
        ),
        HomeList(
            imagePath: 'assets/images/teacher_icon.png',
            navigateScreen: null,
        ),
        HomeList(
            imagePath: 'assets/images/opinions_icon.png',
            navigateScreen: null,
        )
    ];
}
