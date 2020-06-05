import 'package:flutter/material.dart';
import 'package:flutter_appwrite/core/presentation/notifiers/providers.dart';
import 'package:flutter_appwrite/features/auth/presentation/pages/login.dart';
import 'package:flutter_appwrite/features/auth/presentation/pages/signup.dart';
import 'package:flutter_appwrite/features/general/presentation/pages/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            buttonColor: Colors.red,
            inputDecorationTheme:
                InputDecorationTheme(border: OutlineInputBorder()),
            buttonTheme: ButtonThemeData(
              height: 50.0,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            )),
        home: LoginPage(),
      ),
    );
  }
}
