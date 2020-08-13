import 'package:flutter/material.dart';
import 'package:flutter_appwrite/features/auth/presentation/notifiers/auth_state.dart';
import 'package:flutter_appwrite/features/settings/data/model/prefs.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';
import 'package:flutter_appwrite/features/transactions/presentation/notifiers/transaction_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetails({Key key, this.transaction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text(
                            "Are you sure you want to delete this transaction?"),
                        title: Text("Confirm Delete"),
                        actions: <Widget>[
                          FlatButton(
                            textColor: Colors.black,
                            child: Text("Cancel"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          FlatButton(
                            child: Text("Delete"),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ));
              if (confirm ?? false) {
                await Provider.of<TransactionState>(context, listen: false)
                    .deleteTransaction(transaction);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            transaction.title,
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(DateFormat.yMMMEd().format(transaction.transactionDate)),
          const SizedBox(height: 10.0),
          Text(
            "${_getCurrency(context)} ${transaction.amount}",
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          if (transaction.description != null &&
              transaction.description.isNotEmpty)
            Text(transaction.description),
        ],
      ),
    );
  }

  String _getCurrency(BuildContext context) {
    Prefs prefs = context.watch<AuthState>().prefs;
    if (prefs == null) return null;
    return "${prefs.currency.symbol}.";
  }
}
