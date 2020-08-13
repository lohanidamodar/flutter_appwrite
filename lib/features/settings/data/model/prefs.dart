import 'package:flutter_appwrite/features/settings/data/model/country.dart';
import 'package:flutter_appwrite/features/settings/data/model/currency.dart';

class Prefs {
  final Country country;
  final Currency currency;

  Prefs({this.country, this.currency});

  Prefs.fromJson(Map<String, dynamic> json)
      : country =
            json['country'] != null ? Country.fromJson(json['country']) : null,
        currency = json['currency'] != null
            ? Currency.fromJson(json['currency'])
            : null;
}
