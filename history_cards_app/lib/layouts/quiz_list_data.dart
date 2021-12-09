
import 'package:history_cards_app/globals.dart' as globals;
import 'package:history_cards_app/models/Question.dart';

import '../models/Quiz.dart';

class QuizListData {
  QuizListData(
      {this.imagePath,
      this.titleTxt = '',
      this.subTxt = "",
      this.dist = "",
      this.reviews = 80,
      this.rating = 4.5,
      this.perNight = 180,
      this.quiz});

  String imagePath;
  String titleTxt;
  String subTxt;
  String dist;
  double rating;
  int reviews;
  int perNight;
  Quiz quiz;

  static Future<List<QuizListData>> getQuizList() async {
    List<QuizListData> quizList = [];
    List<Quiz> quizzes = await globals.dataStorage.getQuizzesForUser(globals.currentUser);

    if (quizzes.isNotEmpty) {
      for (Quiz quiz in quizzes) {
        List<Question> questionList = await globals.dataStorage.getQuestionsForQuiz(quiz);

        quizList.add(QuizListData(
            imagePath: await globals.dataStorage.getDownloadURL(questionList[0].image),
            titleTxt: quiz.name,
            subTxt: "Zgodovinski kviz",
            dist: "Ves svet",
            reviews: 0,
            rating: 0,
            perNight: questionList.length,
            quiz: quiz));
      }
    }
    return quizList;
  }
}
