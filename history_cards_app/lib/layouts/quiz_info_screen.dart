import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:history_cards_app/globals.dart' as globals;
import 'package:history_cards_app/layouts/quiz_home_screen.dart';
import 'package:history_cards_app/layouts/quiz_list_data.dart';
import 'package:history_cards_app/layouts/quiz_view.dart';
import 'package:history_cards_app/models/Question.dart';

import '../models/Quiz.dart';
import 'app_theme.dart';

class QuizInfoScreen extends StatefulWidget {
  final QuizListData quizElement;
  final Quiz quiz;

  QuizInfoScreen(this.quizElement, this.quiz);

  @override
  _QuizInfoScreenState createState() => _QuizInfoScreenState.quiz(quiz, quizElement);
}

class _QuizInfoScreenState extends State<QuizInfoScreen> with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  QuizListData quizElement;
  Quiz quiz;
  List<String> images = [];
  Image image;
  int imageIndex = 0;

  _QuizInfoScreenState();

  _QuizInfoScreenState.quiz(this.quiz, this.quizElement);

  Future<void> _ackAlert2(BuildContext context, QuizListData quiz) {
    if (globals.favouriteQuizzes.contains(quiz.titleTxt)) {
      return showDialog(
          context: context,
          builder: (_) => NetworkGiffyDialog(
                key: Key("Network"),
                image: Image.network(
                  "https://media1.giphy.com/media/7lyvQ60pEKBmE/200.gif",
                  fit: BoxFit.cover,
                ),
                entryAnimation: EntryAnimation.TOP_LEFT,
                buttonOkText: Text("Ok"),
                buttonCancelText: Text("Odstrani"),
                title: Text(
                  'PRILJUBLJENE',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                ),
                description: Text(
                  'Kviz ${quiz.titleTxt} je že med priljubljenimi! Če ga želite odstraniti kliknite Odstrani.',
                  textAlign: TextAlign.center,
                ),
                onOkButtonPressed: () {
                  Navigator.of(context).pop();
                },
                onCancelButtonPressed: () {
                  globals.favouriteQuizzes.remove(quiz.titleTxt);
                  Navigator.of(context).pop();
                },
              ));
    }
    return showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              key: Key("Network"),
              image: Image.network(
                "https://media1.giphy.com/media/7lyvQ60pEKBmE/200.gif",
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.TOP_LEFT,
              buttonOkText: Text("Ok"),
              buttonCancelText: Text("Prekliči"),
              title: Text(
                'PRILJUBLJENE',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'S klikom na Ok bo kviz ${quiz.titleTxt} dodan med priljubljene!',
                textAlign: TextAlign.center,
              ),
              onOkButtonPressed: () {
                globals.favouriteQuizzes.add(quiz.titleTxt);
                Navigator.of(context).pop();
              },
              onCancelButtonPressed: () {
                Navigator.of(context).pop();
              },
            ));
  }

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: animationController, curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });

    List<Question> questionList = await globals.dataStorage.getQuestionsForQuiz(quiz);
    for (Question question in questionList) {
      images.add(await globals.dataStorage.getDownloadURL(question.image));
    }

    image = quizElement.imagePath != null
        ? Image.network(quizElement.imagePath)
        : Image.network("https://viralsolutions.net/wp-content/uploads/2019/06/shutterstock_749036344.jpg");
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.width / 1.2) + 24.0;
    return Container(
      color: QuizInfoAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: image,
                  ),
                  onTap: () {
                    setState(() {
                      if (images.length > 1) {
                        imageIndex++;
                        image = images[imageIndex % images.length] != null
                            ? Image.network(images[imageIndex % images.length])
                            : Image.network(
                                "https://viralsolutions.net/wp-content/uploads/2019/06/shutterstock_749036344.jpg");
                      }
                    });
                  },
                )
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: QuizInfoAppTheme.nearlyWhite,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: QuizInfoAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight, maxHeight: tempHeight > infoHeight ? tempHeight : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0, left: 18, right: 16),
                            child: Text(
                              "${quizElement.titleTxt}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: QuizInfoAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${quizElement.subTxt.toString()}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 17,
                                    letterSpacing: 0.27,
                                    color: QuizInfoAppTheme.nearlyBlue,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        quizElement.rating.toInt().toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 17,
                                          letterSpacing: 0.27,
                                          color: QuizInfoAppTheme.grey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: QuizInfoAppTheme.nearlyBlue,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity1,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: <Widget>[
                                  getTimeBoxUI('Vprašanj', quizElement.perNight.toString()),
                                  getTimeBoxUI('Možnih točk', (quizElement.perNight * 3).toString()),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                child: Text(
                                  "\n${quiz.description}",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14,
                                    letterSpacing: 0.27,
                                    color: QuizInfoAppTheme.grey,
                                  ),
                                  maxLines: 8,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 48,
                                    height: 48,
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: QuizInfoAppTheme.nearlyWhite,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0),
                                          ),
                                          border: Border.all(color: QuizInfoAppTheme.grey.withOpacity(0.2)),
                                        ),
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.red,
                                          size: 28,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push<dynamic>(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) => QuizHomeScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      child: Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: QuizInfoAppTheme.nearlyBlue,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0),
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: QuizInfoAppTheme.nearlyBlue.withOpacity(0.5),
                                                offset: const Offset(1.1, 1.1),
                                                blurRadius: 10.0),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'ZAČNI REŠEVATI KVIZ',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                              color: QuizInfoAppTheme.nearlyWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        List<Question> questions = await globals.dataStorage.getQuestionsForQuiz(quiz);
                                        Navigator.push<dynamic>(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) =>
                                                  QuizView(globals.survey.surveyTaskFromJSON(quiz), quiz, questions)),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
                child: Card(
                  color: QuizInfoAppTheme.nearlyBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  elevation: 10.0,
                  child: InkWell(
                    child: Container(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          color: QuizInfoAppTheme.nearlyWhite,
                          size: 30,
                        ),
                      ),
                    ),
                    onTap: () {
                      _ackAlert2(context, quizElement);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: QuizInfoAppTheme.nearlyBlack,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: QuizInfoAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: QuizInfoAppTheme.grey.withOpacity(0.2), offset: const Offset(1.1, 1.1), blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: QuizInfoAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: QuizInfoAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
