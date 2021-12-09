import 'dart:convert';

import 'package:history_cards_app/layouts/image_step.dart';
import 'package:history_cards_app/models/Question.dart';
import 'package:history_cards_app/models/Quiz.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:history_cards_app/globals.dart' as globals;

class Survey {
  List<Map<String, dynamic>> jsonSurveySteps = [];
  int questionIndex = 0;

  void addImageStep(Question question) {
    if (question.image != null) {
      jsonSurveySteps.add({"type": "image", "url": question.image});
    }
  }

  void addBooleanAnswerFormatStep(Question question) {
    addImageStep(question);
    jsonSurveySteps.add({
      "type": "question",
      "title": question.question,
      "buttonText": "Naprej",
      "answerFormat": {"type": "boolean", "positiveAnswer": "DA", "negativeAnswer": "NE"}
    });
  }

  void addSingleChoiceAnswerFormatStep(Question question, List<TextChoice> textChoices) {
    addImageStep(question);
    jsonSurveySteps.add({
      "type": "question",
      "title": question.question,
      "buttonText": "Naprej",
      "answerFormat": {"type": "singleChoice", "textChoices": textChoices}
    });
  }

  void addTextAnswerFormatStep(Question question) {
    addImageStep(question);
    jsonSurveySteps.add({
      "type": "question",
      "title": question.question,
      "buttonText": "Naprej",
      "answerFormat": {"type": "text"}
    });
  }

  Map<String, dynamic> surveyTaskToJSON() {
    return {"steps": jsonSurveySteps};
  }

  Future<Task> surveyTaskFromJSON(Quiz quiz) async {
    try {
      List<Step> surveySteps = [];
      surveySteps.add(InstructionStep(
        title: quiz.name,
        text: quiz.description,
        buttonText: 'Začni reševati!',
      ));

      Map<String, dynamic> jsonTask = json.decode(await globals.dataStorage.downloadJSON(quiz.survey));
      for (Map<String, dynamic> jsonStep in jsonTask['steps']) {
        if (jsonStep['type'] == "image") {
          surveySteps.add(ImageStep(url: await globals.dataStorage.getDownloadURL(jsonStep['url'])));
        } else if (jsonStep['type'] == "question") {
          if (jsonStep['answerFormat']['type'] == "boolean") {
            surveySteps.add(QuestionStep(
                title: jsonStep['title'],
                buttonText: jsonStep['buttonText'],
                answerFormat: BooleanAnswerFormat(
                  positiveAnswer: jsonStep['answerFormat']['positiveAnswer'],
                  negativeAnswer: jsonStep['answerFormat']['negativeAnswer'],
                )));
          } else if (jsonStep['answerFormat']['type'] == "text") {
            surveySteps.add(QuestionStep(
              title: jsonStep['title'],
              buttonText: jsonStep['buttonText'],
              answerFormat: TextAnswerFormat(
                hint: "Sem vpiši odgovor",
                maxLines: 5,
                validationRegEx: "^(?!\s*\$).+",
              ),
            ));
          } else if (jsonStep['answerFormat']['type'] == "text") {
            surveySteps.add(QuestionStep(
              title: jsonStep['title'],
              buttonText: jsonStep['buttonText'],
              answerFormat: SingleChoiceAnswerFormat(
                textChoices: jsonStep['answerFormat']['textChoices'],
              ),
            ));
          } else {
            throw Exception("Wrong json answerFormat: $jsonStep['answerFormat']");
          }
        } else {
          throw Exception("Wrong json step type: $jsonStep['type']");
        }
      }

      surveySteps.add(CompletionStep(
        stepIdentifier: StepIdentifier(id: '123'),
        text: 'Hvala za reševanje kviza!',
        title: 'Zaključek!',
        buttonText: 'Oddaj kviz',
      ));

      NavigableTask task = NavigableTask(
        id: TaskIdentifier(),
        steps: surveySteps,
      );
      return Future.value(task);
    } catch (error) {
      throw Exception("Failed to get survey task from JSON: $error");
    }
  }
}
