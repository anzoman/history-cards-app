import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:history_cards_app/globals.dart' as globals;
import 'package:history_cards_app/layouts/navigation_home_screen.dart';
import 'package:history_cards_app/models/Question.dart';
import 'package:history_cards_app/models/Quiz.dart';
import 'package:image_picker/image_picker.dart';

class QuestionForm extends StatefulWidget {
  Quiz quiz;

  QuestionForm(this.quiz, {Key key}) : super(key: key);

  @override
  _QuestionFormState createState() => new _QuestionFormState(this.quiz);
}

class _QuestionFormState extends State<QuestionForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();
  Quiz quiz;
  List<String> questionTypes;
  String question;
  String answer;
  String selectedQuestionType;
  XFile image;

  _QuestionFormState(this.quiz) {
    questionTypes = ["DA/NE", "VPIS ODGOVORA", "IZBIRA ODGOVORA"];
    selectedQuestionType = questionTypes[0];
    question = "";
    answer = "";
    image = null;
  }

  Future<void> _ackAlert() {
    return showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              key: Key("Network"),
              image: Image.network(
                "https://thumbs.gfycat.com/EasygoingWastefulIridescentshark-small.gif",
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.BOTTOM,
              buttonOkText: Text("Ok"),
              buttonCancelText: Text("Prekliči"),
              title: Text(
                'KVIZ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Kviz je bil uspešno dodan!',
                textAlign: TextAlign.center,
              ),
              onOkButtonPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => NavigationHomeScreen(),
                ));
              },
              onCancelButtonPressed: () {
                Navigator.of(context).pop();
              },
            ));
  }

  Future<void> _ackAlert2() {
    return showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              key: Key("Network"),
              image: Image.network(
                "https://banner2.cleanpng.com/20190304/hxu/kisspng-emoji-discord-gif-logo-portable-network-graphics-cross-discord-emoji-5c7ce543567e23.6188659115516890273543.jpg",
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.BOTTOM,
              buttonOkText: Text("Ok"),
              buttonCancelText: Text("Nazaj"),
              title: Text(
                'KVIZ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Kviz žal ni bil uspešno dodan!',
                textAlign: TextAlign.center,
              ),
              onOkButtonPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => NavigationHomeScreen(),
                ));
              },
              onCancelButtonPressed: () {
                Navigator.of(context).pop();
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("USTVARI VPRAŠANJE"),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                children: <Widget>[
                  new Text(""),
                  new Text("Vpišite podatke za novo vprašanje: ", textAlign: TextAlign.center),
                  new Text(""),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.quiz),
                      hintText: 'Vpiši vprašanje',
                      labelText: 'Vpiši vprašanje',
                    ),
                    onChanged: (text) {
                      this.question = text;
                    },
                  ),
                  new Text(""),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: new RaisedButton(
                                disabledColor: Colors.cyan,
                                color: Colors.cyan,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                child: const Text('Zajemi sliko'),
                                padding: EdgeInsets.all(10),
                                onPressed: () async {
                                  this.image = await picker.pickImage(source: ImageSource.camera);
                                },
                              )),
                          new Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: new RaisedButton(
                                disabledColor: Colors.cyan,
                                color: Colors.cyan,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                child: const Text('Izberi sliko'),
                                padding: EdgeInsets.all(10),
                                onPressed: () async {
                                  this.image = await picker.pickImage(source: ImageSource.gallery);
                                },
                              ))
                        ],
                      )),
                  new Text(""),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.question_answer),
                      hintText: 'Vpiši pravilni odgovor',
                      labelText: 'Vpiši pravilni odgovor',
                    ),
                    onChanged: (text) {
                      this.answer = text;
                    },
                  ),
                  new Text(""),
                  new FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.question_answer_outlined),
                          labelText: 'Izberi vrsto vprašanja',
                        ),
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            value: selectedQuestionType,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                selectedQuestionType = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: questionTypes.map((String value) {
                              return new DropdownMenuItem(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  new Text(""),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: new RaisedButton(
                                disabledColor: Colors.green,
                                color: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                child: const Text('Zaključi'),
                                padding: EdgeInsets.all(10),
                                onPressed: () async {
                                  try {
                                    String imagePath = null;
                                    if (this.image != null) {
                                      imagePath = await globals.dataStorage.uploadImage(this.image.path);
                                    }
                                    Question question = Question(this.question, this.answer,
                                        globals.survey.questionIndex, imagePath, this.quiz.id);
                                    await globals.dataStorage.createQuestion(question);
                                    globals.survey.questionIndex++;

                                    if (this.selectedQuestionType == this.questionTypes[0]) {
                                      globals.survey.addBooleanAnswerFormatStep(question);
                                    } else {
                                      globals.survey.addTextAnswerFormatStep(question);
                                    }

                                    String jsonFilePath =
                                        await globals.dataStorage.uploadJSON(globals.survey.surveyTaskToJSON());
                                    this.quiz.survey = jsonFilePath;
                                    this.quiz = await globals.dataStorage.updateQuiz(this.quiz);

                                    _ackAlert();
                                  } catch (error) {
                                    _ackAlert2();
                                  }
                                },
                              )),
                          new Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: new RaisedButton(
                                disabledColor: Colors.green,
                                color: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                child: const Text('Novo vprašanje'),
                                padding: EdgeInsets.all(10),
                                onPressed: () async {
                                  try {
                                    String imagePath = null;
                                    if (this.image != null) {
                                      imagePath = await globals.dataStorage.uploadImage(this.image.path);
                                    }
                                    Question question = Question(this.question, this.answer,
                                        globals.survey.questionIndex, imagePath, this.quiz.id);
                                    await globals.dataStorage.createQuestion(question);
                                    globals.survey.questionIndex++;

                                    if (this.selectedQuestionType == questionTypes[0]) {
                                      globals.survey.addBooleanAnswerFormatStep(question);
                                    } else {
                                      globals.survey.addTextAnswerFormatStep(question);
                                    }

                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => QuestionForm(this.quiz),
                                    ));
                                  } catch (error) {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => QuestionForm(this.quiz),
                                    ));
                                  }
                                },
                              ))
                        ],
                      )),
                ],
              ))),
    );
  }
}
