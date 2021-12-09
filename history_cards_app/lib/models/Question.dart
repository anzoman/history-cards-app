class Question {
  String id;
  String question;
  String answer;
  int number;
  String image;
  String quizId;

  Question(this.question, this.answer, this.number, this.image, this.quizId);

  static Question fromJson(json) {
    return new Question(json['question'], json['answer'], json['number'], json['image'], json['quiz_id']);
  }
}
