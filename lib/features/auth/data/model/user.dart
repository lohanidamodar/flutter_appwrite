class UserFields {
  static const String id = "\$id";
  static const String name = "name";
  static const String email = "email";
  static const String registrationDate = "registration";
  static const String roles = "roles";
}
class User {
  String id;
  String email;
  int registration;
  String name;
  List<String> roles;

  User({this.id, this.email, this.registration, this.name, this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json[UserFields.id];
    email = json[UserFields.email];
    registration = json[UserFields.registrationDate];
    name = json[UserFields.name];
    roles = json[UserFields.roles].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[UserFields.id] = this.id;
    data[UserFields.email] = this.email;
    data[UserFields.registrationDate] = this.registration;
    data[UserFields.name] = this.name;
    data[UserFields.roles] = this.roles;
    return data;
  }
}
