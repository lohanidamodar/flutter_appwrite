import 'package:flutter/material.dart';
import 'package:flutter_appwrite/core/presentation/routes.dart';
import 'package:flutter_appwrite/features/transactions/presentation/widgets/transaction_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budgeter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          )
        ],
      ),
      body: TransactionList(),
    );
  }
}
