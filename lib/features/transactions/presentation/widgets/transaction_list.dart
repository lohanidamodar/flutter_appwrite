import 'package:flutter/material.dart';
import 'package:flutter_appwrite/core/presentation/routes.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';
import 'package:flutter_appwrite/features/transactions/presentation/notifiers/transaction_state.dart';
import 'package:flutter_appwrite/features/transactions/presentation/widgets/transaction_list_item.dart';
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
        return TransactionListItem(transaction: transaction);
      },
    );
  }
}
