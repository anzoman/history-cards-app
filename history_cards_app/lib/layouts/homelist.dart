import 'package:flutter/widgets.dart';
import 'package:history_cards_app/layouts/leaderboard_view.dart';
import 'package:history_cards_app/layouts/profile_screen.dart';
import 'package:history_cards_app/layouts/quiz_form.dart';
import 'package:history_cards_app/layouts/quiz_home_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
    this.title = '',
  });

  Widget navigateScreen;
  String imagePath;
  String title;

  static List<HomeList> homeList = [
    HomeList(imagePath: 'assets/images/q_a_icon.png', navigateScreen: QuizHomeScreen(), title: 'Reši kviz'),
    HomeList(imagePath: 'assets/images/add_icon.png', navigateScreen: QuizForm(), title: 'Dodaj kviz'),
    HomeList(imagePath: 'assets/images/leaderboard_icon.png', navigateScreen: LeaderBoardView(), title: 'Lestvica'),
    HomeList(imagePath: 'assets/images/user_icon.png', navigateScreen: AppProfileHomeScreen(), title: 'Profil'),
    HomeList(imagePath: 'assets/images/teacher_icon.png', navigateScreen: null, title: 'Učitelji'),
    HomeList(imagePath: 'assets/images/opinions_icon.png', navigateScreen: null, title: 'Nastavitve')
  ];
}
