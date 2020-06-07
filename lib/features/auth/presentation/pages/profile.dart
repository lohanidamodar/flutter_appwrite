import 'package:flutter/material.dart';
import 'package:flutter_appwrite/features/auth/presentation/notifiers/auth_state.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Consumer<AuthState>(
        builder: (context, state, child) {
          if (!state.isLoggedIn) return Container();
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Center(
                  child: Text(
                state.user.name ?? '',
                style: Theme.of(context).textTheme.headline4,
              )),
              const SizedBox(height: 10.0),
              Center(child: Text(state.user.email)),
              const SizedBox(height: 30.0),
              Center(
                child: RaisedButton(
                  onPressed: () async {
                    await state.logout();
                    Navigator.pop(context);
                  },
                  child: Text("Log out"),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
