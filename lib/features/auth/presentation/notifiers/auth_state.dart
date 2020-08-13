import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appwrite/core/res/app_constants.dart';
import 'package:flutter_appwrite/features/auth/data/model/user.dart';
import 'package:flutter_appwrite/features/settings/data/model/country.dart';
import 'package:flutter_appwrite/features/settings/data/model/currency.dart';
import 'package:flutter_appwrite/features/settings/data/model/prefs.dart';

class AuthState extends ChangeNotifier {
  Client client = Client();
  Account account;
  bool _isLoggedIn;
  User _user;
  String _error;
  bool _settingsLoaded;
  Locale locale;
  Prefs _prefs;
  List<Currency> _currencies;
  List<Country> _countries;

  bool get isLoggedIn => _isLoggedIn;
  User get user => _user;
  String get error => _error;
  Prefs get prefs => _prefs;
  List get countries => _countries;
  List<Currency> get currencies => _currencies;

  AuthState() {
    _init();
  }

  _init() {
    _isLoggedIn = false;
    _user = null;
    account = Account(client);
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    locale = Locale(client);
    _settingsLoaded = false;
    _getUserPrefs();
    _checkIsLoggedIn();
  }

  _checkIsLoggedIn() async {
    try {
      _user = await _getAccount();
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print(e.message);
    }
  }

  Future loadSettings() async {
    if (_settingsLoaded) return;
    if (_currencies == null) await _getCurrencies();
    if (_prefs == null) await _getUserPrefs();
    if (_countries == null) await _getCountries();
    _settingsLoaded = true;
    notifyListeners();
  }

  Future updatePrefs(Map<String, dynamic> prefs) async {
    try {
      Response<dynamic> res = await account.updatePrefs(prefs: prefs);
      if (res.statusCode == 200) {
        _prefs = Prefs.fromJson(res.data);
        notifyListeners();
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  Future _getUserPrefs() async {
    try {
      Response<dynamic> res = await account.getPrefs();
      if (res.statusCode == 200) {
        _prefs = Prefs.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  Future _getCurrencies() async {
    try {
      Response<dynamic> res = await locale.getCurrencies();
      if (res.statusCode == 200) {
        _currencies =
            List<Currency>.from(res.data.map((da) => Currency.fromJson(da)));
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  Future _getCountries() async {
    try {
      Response<dynamic> res = await locale.getCountries();
      if (res.statusCode == 200) {
        _countries = [];
        (res.data as Map<String, dynamic>).forEach((key, value) {
          _countries.add(Country(code: key, name: value));
        });
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<User> _getAccount() async {
    try {
      Response<dynamic> res = await account.get();
      if (res.statusCode == 200) {
        return User.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  createAccount(String name, String email, String password) async {
    try {
      var result =
          await account.create(name: name, email: email, password: password);
      print(result);
    } catch (error) {
      print(error.message);
    }
  }

  logout() async {
    try {
      Response res = await account.deleteSession(sessionId: 'current');
      print(res.statusCode);
      _isLoggedIn = false;
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  login(String email, String password) async {
    try {
      Response result =
          await account.createSession(email: email, password: password);
      if (result.statusCode == 201) {
        _isLoggedIn = true;
        _user = await _getAccount();
        notifyListeners();
      }
    } catch (error) {
      print(error.message);
    }
  }
}
