import 'package:flutter/material.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';
import 'package:flutter_appwrite/features/transactions/presentation/notifiers/transaction_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TransactionState>(context).transactions(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          List<Transaction> transactions = snapshot.data;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context,index)  {
              Transaction transaction = transactions[index];
              return ListTile(
                leading: Icon(transaction.transactionType == 1 ? Icons.account_balance_wallet : Icons.view_list),
                title: Text(transaction.title),
                subtitle: Text(DateFormat.yMMMEd().format(transaction.transactionDate)),
                trailing: Text(transaction.amount.toString()),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}