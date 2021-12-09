import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:history_cards_app/globals.dart' as globals;
import 'package:history_cards_app/layouts/list_app_theme.dart';
import 'package:history_cards_app/layouts/quiz_info_screen.dart';
import 'package:history_cards_app/layouts/quiz_list_data.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class QuizListView extends StatelessWidget {
  const QuizListView({Key key, this.quizData, this.animationController, this.animation, this.callback})
      : super(key: key);

  final VoidCallback callback;
  final QuizListData quizData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  Future<void> _ackAlert(BuildContext context, QuizListData kviz) {
    if (globals.favouriteQuizzes.contains(kviz.titleTxt)) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Priljubljene'),
            content: const Text('Kviz je že med priljubljenimi.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    globals.favouriteQuizzes.add(kviz.titleTxt);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Priljubljene'),
          content: const Text('Kviz je bil dodan med priljubljene!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _ackAlert2(BuildContext context, QuizListData kviz) {
    if (globals.favouriteQuizzes.contains(kviz.titleTxt)) {
      return showDialog(
          context: context,
          builder: (_) => NetworkGiffyDialog(
                key: Key("Network"),
                image: Image.network(
                  "https://i.pinimg.com/originals/1e/2d/27/1e2d27c1805ce48bdbe25c3bfd6eb4a8.gif",
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
                  'Kviz ${kviz.titleTxt} je že med priljubljenimi! Če ga želite odstraniti kliknite Odstrani.',
                  textAlign: TextAlign.center,
                ),
                onOkButtonPressed: () {
                  Navigator.of(context).pop();
                },
                onCancelButtonPressed: () {
                  globals.favouriteQuizzes.remove(kviz.titleTxt);
                  Navigator.of(context).pop();
                },
              ));
    }
    return showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              key: Key("Network"),
              image: Image.network(
                "https://i.pinimg.com/originals/1e/2d/27/1e2d27c1805ce48bdbe25c3bfd6eb4a8.gif",
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
                'S klikom na Ok bo kviz ${kviz.titleTxt} dodan med priljubljene!',
                textAlign: TextAlign.center,
              ),
              onOkButtonPressed: () {
                globals.favouriteQuizzes.add(kviz.titleTxt);
                Navigator.of(context).pop();
              },
              onCancelButtonPressed: () {
                Navigator.of(context).pop();
              },
            ));
  }

  void moveTo(context) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => QuizInfoScreen(quizData, quizData.quiz),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  callback();
                  moveTo(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: quizData.imagePath != null ? Image.network(quizData.imagePath) : Image.network("https://viralsolutions.net/wp-content/uploads/2019/06/shutterstock_749036344.jpg"),
                              // child: Image.memory(
                              //     quizData
                              //         .imagePath,
                              //     fit: BoxFit
                              //         .cover,
                              // ),
                            ),
                            Container(
                              color: CampAppTheme.buildLightTheme().backgroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              quizData.titleTxt,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  quizData.subTxt,
                                                  style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Icon(
                                                  FontAwesomeIcons.mapMarkerAlt,
                                                  size: 12,
                                                  color: CampAppTheme.buildLightTheme().primaryColor,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${quizData.dist}',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Row(
                                                children: <Widget>[
                                                  SmoothStarRating(
                                                    allowHalfRating: true,
                                                    spacing: 1,
                                                    starCount: 5,
                                                    rating: quizData.rating,
                                                    size: 20,
                                                    color: CampAppTheme.buildLightTheme().primaryColor,
                                                    borderColor: CampAppTheme.buildLightTheme().primaryColor,
                                                  ),
                                                  Text(
                                                    '   Mnenj: ${quizData.reviews.toString()}',
                                                    style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16, top: 8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${quizData.perNight}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Text(
                                          'vprašanj',
                                          style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              onTap: () {
                                _ackAlert2(context, quizData);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: CampAppTheme.buildLightTheme().primaryColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
