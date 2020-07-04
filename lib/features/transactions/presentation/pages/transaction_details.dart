import 'package:flutter/material.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';
import 'package:intl/intl.dart';

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetails({Key key, this.transaction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(DateFormat.yMMMEd()
                        .format(transaction.transactionDate)),
                  ],
                ),
              ),
              Text(
                "${transaction.amount}",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          if (transaction.description != null &&
              transaction.description.isNotEmpty)
            Text(transaction.description),
        ],
      ),
    );
  }
}
