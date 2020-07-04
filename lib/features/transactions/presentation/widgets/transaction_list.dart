import 'package:flutter/material.dart';
import 'package:flutter_appwrite/core/presentation/routes.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';
import 'package:flutter_appwrite/features/transactions/presentation/notifiers/transaction_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions =
        Provider.of<TransactionState>(context).transactions;
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        Transaction transaction = transactions[index];
        return ListTile(
          leading: Icon(transaction.transactionType == 1
              ? Icons.account_balance_wallet
              : Icons.view_list),
          title: Text(transaction.title),
          subtitle:
              Text(DateFormat.yMMMEd().format(transaction.transactionDate)),
          trailing: Text(transaction.amount.toString()),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.transactionDetails,
                arguments: transaction);
          },
          onLongPress: () {
            Navigator.pushNamed(context, AppRoutes.editTransaction,
                arguments: transaction);
          },
        );
      },
    );
  }
}
