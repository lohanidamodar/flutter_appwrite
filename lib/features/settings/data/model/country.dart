class Country {
  final String name;
  final String code;

  Country({this.name, this.code});

  Country.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        code = json['code'];

  toMap() => ({"name": name, "code": code});
}
