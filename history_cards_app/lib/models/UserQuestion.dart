class UserQuestion {
  String id;
  String userId;
  String questionId;
  bool correct;

  UserQuestion(this.userId, this.questionId, this.correct);

  static UserQuestion fromJson(json) {
    return new UserQuestion(json['user_id'], json['question_id'], json['correct']);
  }
}
