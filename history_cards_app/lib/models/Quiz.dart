class Quiz {
  String id;
  String name;
  String description;
  String survey;
  String userId;

  Quiz(this.name, this.description, this.survey, this.userId);

  static Quiz fromJson(json) {
    return new Quiz(json['name'], json['description'], json['survey'], json['user_id']);
  }
}
