import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:history_cards_app/globals.dart' as globals;
import 'package:history_cards_app/models/Question.dart';
import 'package:history_cards_app/models/Quiz.dart';
import 'package:history_cards_app/models/UserQuestion.dart';
import 'package:history_cards_app/models/UserQuiz.dart';
import 'package:survey_kit/survey_kit.dart';

import 'navigation_home_screen.dart';

class QuizView extends StatefulWidget {
  final Future<Task> task;
  final Quiz quiz;
  final List<Question> questions;

  QuizView(this.task, this.quiz, this.questions) : assert(task != null);

  @override
  _QuizViewState createState() => _QuizViewState(this.task, this.quiz, this.questions);
}

class _QuizViewState extends State<QuizView> {
  Future<Task> task;
  Quiz quiz;
  List<Question> questions;

  _QuizViewState(this.task, this.quiz, this.questions) : assert(task != null);

  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: FutureBuilder<Task>(
              future: this.task,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                  final task = snapshot.data;
                  return SurveyKit(
                    onResult: (SurveyResult result) async {
                      questions.sort((a, b) => a.number.compareTo(b.number));
                      await globals.dataStorage.createUserQuiz(UserQuiz(globals.currentUser.id, quiz.id, true));
                      int counter = 0;
                      int newPoints = 0;
                      for (var stepResult in result.results) {
                        QuestionResult<dynamic> questionResult = stepResult.results[0];
                        if (questionResult.result != null) {
                          Question question = questions[counter];
                          bool correct = false;
                          if (["DA", "NE"].contains(question.answer)) {
                            if (questionResult.result == BooleanResult.POSITIVE && question.answer == "DA") {
                              correct = true;
                              newPoints += 3;
                            } else if (questionResult.result == BooleanResult.NEGATIVE && question.answer == "NE") {
                              correct = true;
                              newPoints += 3;
                            } else {
                              correct = false;
                            }
                          } else {
                            if (questionResult.result == question.answer) {
                              correct = true;
                              newPoints += 3;
                            } else {
                              correct = false;
                            }
                          }
                          await globals.dataStorage
                              .createUserQuestion(UserQuestion(globals.currentUser.id, question.id, correct));
                          counter++;
                        }
                      }
                      await globals.dataStorage
                          .updateUserPoints(globals.currentUser, globals.currentUser.points + newPoints);
                      return showDialog(
                          context: buildContext,
                          builder: (_) => NetworkGiffyDialog(
                                key: Key("Network"),
                                image: Image.network(
                                  "https://cdn.dribbble.com/users/911625/screenshots/6116493/viking.gif",
                                  fit: BoxFit.cover,
                                ),
                                entryAnimation: EntryAnimation.TOP_LEFT,
                                buttonOkText: Text("Ok"),
                                buttonCancelText: Text("Zapri"),
                                title: Text(
                                  'REZULTAT KVIZA',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                                ),
                                description: Text(
                                  "Pravilno ste odgovorili na ${newPoints ~/ 3} vprašanj (od ${questions.length}) in zbrali ${newPoints} novih točk!",
                                  textAlign: TextAlign.center,
                                ),
                                onOkButtonPressed: () {
                                  Navigator.of(buildContext)
                                      .pushReplacement(MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
                                },
                                onCancelButtonPressed: () {
                                  Navigator.of(buildContext)
                                      .pushReplacement(MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
                                },
                              ));
                    },
                    task: task,
                    themeData: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSwatch(
                        primarySwatch: Colors.cyan,
                      ).copyWith(
                        onPrimary: Colors.white,
                      ),
                      primaryColor: Colors.cyan,
                      backgroundColor: Colors.white,
                      appBarTheme: const AppBarTheme(
                        color: Colors.white,
                        iconTheme: IconThemeData(
                          color: Colors.cyan,
                        ),
                        textTheme: TextTheme(
                          button: TextStyle(
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      iconTheme: const IconThemeData(
                        color: Colors.cyan,
                      ),
                      outlinedButtonTheme: OutlinedButtonThemeData(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            Size(150.0, 60.0),
                          ),
                          side: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> state) {
                              if (state.contains(MaterialState.disabled)) {
                                return BorderSide(
                                  color: Colors.grey,
                                );
                              }
                              return BorderSide(
                                color: Colors.cyan,
                              );
                            },
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          textStyle: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> state) {
                              if (state.contains(MaterialState.disabled)) {
                                return Theme.of(context).textTheme.button?.copyWith(
                                      color: Colors.grey,
                                    );
                              }
                              return Theme.of(context).textTheme.button?.copyWith(
                                    color: Colors.cyan,
                                  );
                            },
                          ),
                        ),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            Theme.of(context).textTheme.button?.copyWith(
                                  color: Colors.cyan,
                                ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return CircularProgressIndicator.adaptive();
              },
            ),
          ),
        ),
      ),
    );
  }
}
