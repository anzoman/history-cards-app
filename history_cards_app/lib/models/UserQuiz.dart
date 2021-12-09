class UserQuiz {
  String id;
  String userId;
  String quizId;
  bool solved;

  UserQuiz(this.userId, this.quizId, this.solved);

  static UserQuiz fromJson(json) {
    return new UserQuiz(json['user_id'], json['quiz_id'], json['solved']);
  }
}
