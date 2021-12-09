class User {
  String id;
  String username;
  String fullName;
  String email;
  String image;
  int points;
  int permission;

  User(this.username, this.fullName, this.email, this.image, this.points, this.permission);

  static User fromJson(json) {
    return new User(json['username'], json['full_name'], json['email'], json['image'], json['points'], json['permission']);
  }
}
