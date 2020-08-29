import 'package:flutter_appwrite/features/settings/data/model/country.dart';
import 'package:flutter_appwrite/features/settings/data/model/currency.dart';

class Prefs {
  final Country country;
  final Currency currency;
  final String profileURL;
  final String pic;

  Prefs({this.country, this.currency, this.profileURL, this.pic});

  Prefs.fromJson(Map<String, dynamic> json)
      : pic = json['pic'],
        profileURL = json['profile_url'],
        country =
            json['country'] != null ? Country.fromJson(json['country']) : null,
        currency = json['currency'] != null
            ? Currency.fromJson(json['currency'])
            : null;
}
