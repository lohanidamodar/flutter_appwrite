import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appwrite/core/res/app_constants.dart';

class AuthState extends ChangeNotifier {
  Client client = Client();
  Account account;
  
  AuthState() {
    _init();
  }

  _init() {
    account = Account(client);
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    _checkIsLoggedIn();
  }

  _checkIsLoggedIn() async {
    try {
      var res = await account.get();
      print(res);
    } catch (e) {
      print(e.message);
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

  login(String email, String password) async {
    try {
      var result =
          await account.createSession(email: email, password: password);
      print(result);
    } catch (error) {
      print(error.message);
    }
  }
}
