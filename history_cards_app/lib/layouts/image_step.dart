import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/steps/step.dart' as DefaultStep;
import 'package:survey_kit/src/views/widget/step_view.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:uuid/uuid.dart';

@JsonSerializable()
class ImageStep extends DefaultStep.Step {
  @JsonKey(defaultValue: false)
  final String url;

  ImageStep({
    StepIdentifier stepIdentifier,
    bool isOptional = false,
    String buttonText = 'Naprej',
    @required this.url,
  }) : super(
          isOptional: isOptional,
          buttonText: buttonText,
          stepIdentifier: stepIdentifier,
        );

  @override
  Widget createView({@required QuestionResult questionResult}) {
    return StepView(
        step: this,
        resultFunction: () => ImageStepResult(this.stepIdentifier, DateTime.now(), DateTime.now()),
        title: Text('Oglej si spodnjo sliko predmeta'),
        child: DetailScreen(this.url));
  }

  factory ImageStep.fromJson(Map<String, dynamic> json) => ImageStep(
      isOptional: json['isOptional'] as bool ?? false,
      buttonText: json['buttonText'] as String ?? 'Next',
      stepIdentifier: json['stepIdentifier'] == null
          ? null
          : StepIdentifier.fromJson(json['stepIdentifier'] as Map<String, dynamic>),
      url: json['url'] as String ?? '');

  Map<String, dynamic> toJson() => <String, dynamic>{
        'stepIdentifier': this.stepIdentifier,
        'isOptional': this.isOptional,
        'buttonText': this.buttonText,
        'url': this.url
      };
}

class ImageStepResult extends QuestionResult {
  ImageStepResult(
      Identifier id,
      DateTime startDate,
      DateTime endDate,
      ) : super(
    id: id,
    startDate: startDate,
    endDate: endDate,
    valueIdentifier: 'image',
    result: null,
  );
}

class DetailScreen extends StatelessWidget {
  String url;

  DetailScreen(this.url) : assert(url != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return FullScreenImage(
              url: this.url,
              tag: Uuid().v1(),
            );
          }));
        },
        child: Container(
          height: 300.0,
          width: 300.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.network(this.url).image,
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
        ));
  }
}

class FullScreenImage extends StatelessWidget {
  final String url;
  final String tag;

  const FullScreenImage({Key key, this.url, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: Image.network(this.url),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
