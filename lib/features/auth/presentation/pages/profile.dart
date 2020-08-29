import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appwrite/features/auth/presentation/notifiers/auth_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

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
                child: InkWell(
                  onTap: () => _uploadPic(context),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: state.prefs?.profileURL != null
                        ? NetworkImage(state.prefs?.profileURL)
                        : null,
                  ),
                ),
              ),
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

  _uploadPic(BuildContext context) async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
    if (file != null) {
      final upfile = await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last);
      AuthState state = context.read<AuthState>();
      Response res = await state.storage.createFile(
          file: upfile, read: ["*"], write: ["user:${state.user.id}"]);
      if (res.statusCode == 201) {
        String id = res.data["\$id"];
        final preview = state.storage.getFilePreview(fileId: id);
        if (state.prefs.pic != null)
          state.storage.deleteFile(fileId: state.prefs.pic);
        state.updatePrefs({"pic": id, "profile_url": preview});
      }
    }
  }
}
