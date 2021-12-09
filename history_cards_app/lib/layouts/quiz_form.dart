import 'package:flutter/material.dart';
import 'package:history_cards_app/globals.dart' as globals;
import 'package:history_cards_app/layouts/question_form.dart';
import 'package:history_cards_app/models/Quiz.dart';

class QuizForm extends StatefulWidget {
  QuizForm({Key key}) : super(key: key);

  @override
  _QuizFormState createState() => new _QuizFormState();
}

class _QuizFormState extends State<QuizForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String name;
  String description;

  _QuizFormState() {
    name = "";
    description = "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("USTVARI KVIZ"),
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
                  new Text("Vpišite podatke za nov kviz: ", textAlign: TextAlign.center),
                  new Text(""),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.subtitles),
                      hintText: 'Vpiši ime kviza',
                      labelText: 'Vpiši ime kviza',
                    ),
                    onChanged: (text) {
                      this.name = text;
                    },
                  ),
                  new Text(""),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description),
                      hintText: 'Opiši svoj kviz',
                      labelText: 'Opiši svoj kviz',
                    ),
                    onChanged: (text) {
                      this.description = text;
                    },
                  ),
                  new Text(""),
                  new Container(
                    padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                    child: new RaisedButton(
                      disabledColor: Colors.green,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      child: const Text('Dodaj vprašanja'),
                      onPressed: () async {
                        Quiz quiz = Quiz(this.name, this.description, null, globals.currentUser.id);
                        quiz = await globals.dataStorage.createQuiz(quiz);
                        globals.survey.jsonSurveySteps = [];
                        globals.survey.questionIndex = 0;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => QuestionForm(quiz),
                        ));
                      },
                    ),
                  ),
                ],
              ))),
    );
  }
}
