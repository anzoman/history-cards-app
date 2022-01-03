import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:history_cards_app/globals.dart' as globals;
import 'package:history_cards_app/layouts/navigation_home_screen.dart';
import 'package:history_cards_app/models/Question.dart';
import 'package:history_cards_app/models/Quiz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survey_kit/survey_kit.dart';

class QuestionForm extends StatefulWidget {
  Quiz quiz;

  QuestionForm(this.quiz, {Key key}) : super(key: key);

  @override
  _QuestionFormState createState() => new _QuestionFormState(this.quiz);
}

class _QuestionFormState extends State<QuestionForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  static List<String> choicesList;

  Quiz quiz;
  List<String> questionTypes;
  String question;
  String answer;
  String selectedQuestionType;
  XFile image;
  bool textChoicesVisible;

  _QuestionFormState(this.quiz) {
    questionTypes = ["DA/NE", "VPIS ODGOVORA", "IZBIRA ODGOVORA"];
    selectedQuestionType = questionTypes[0];
    question = "";
    answer = "";
    textChoicesVisible = false;
    choicesList = [null];
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

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          choicesList.insert(0, null);
        } else
          choicesList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _getChoices() {
    List<Widget> friendsTextFieldsList = [];
    for (int i = 0; i < choicesList.length; i++) {
      friendsTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: ChoicesTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveButton(i == choicesList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFieldsList;
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
                                if (selectedQuestionType == questionTypes[2]) {
                                  this.textChoicesVisible = true;
                                } else {
                                  this.textChoicesVisible = false;
                                }
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
                  new Text(""),
                  new Visibility(
                      visible: this.textChoicesVisible,
                      child: Text(
                        'Dodaj možne odgovore',
                      )),
                  new Visibility(visible: this.textChoicesVisible, child: Column(children: _getChoices())),
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
                                    } else if (this.selectedQuestionType == this.questionTypes[1]) {
                                      globals.survey.addTextAnswerFormatStep(question);
                                    } else {
                                      List<TextChoice> textChoices = [];
                                      for (String choice in _QuestionFormState.choicesList) {
                                        textChoices.add(new TextChoice(text: choice, value: choice));
                                      }
                                      globals.survey.addSingleChoiceAnswerFormatStep(question, textChoices);
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

                                    if (this.selectedQuestionType == this.questionTypes[0]) {
                                      globals.survey.addBooleanAnswerFormatStep(question);
                                    } else if (this.selectedQuestionType == this.questionTypes[1]) {
                                      globals.survey.addTextAnswerFormatStep(question);
                                    } else {
                                      List<TextChoice> textChoices = [];
                                      for (String choice in _QuestionFormState.choicesList) {
                                        textChoices.add(new TextChoice(text: choice, value: choice));
                                      }
                                      globals.survey.addSingleChoiceAnswerFormatStep(question, textChoices);
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

class ChoicesTextFields extends StatefulWidget {
  final int index;

  ChoicesTextFields(this.index);

  @override
  _ChoicesTextFieldsState createState() => _ChoicesTextFieldsState();
}

class _ChoicesTextFieldsState extends State<ChoicesTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = _QuestionFormState.choicesList[widget.index] ?? '';
    });
    return TextFormField(
      controller: _nameController,
      onChanged: (text) => _QuestionFormState.choicesList[widget.index] = text,
      decoration: InputDecoration(hintText: 'Dodaj nov možen odgovor', icon: Icon(Icons.view_day_outlined)),
      validator: (v) {
        if (v.trim().isEmpty) return 'Vpisati je treba nov možen odgovor';
        return null;
      },
    );
  }
}
