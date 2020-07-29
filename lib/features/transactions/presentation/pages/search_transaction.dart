import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';
import 'package:flutter_appwrite/features/transactions/presentation/notifiers/transaction_state.dart';
import 'package:flutter_appwrite/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryController = TextEditingController();
  Timer _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<TransactionState>(context, listen: false).query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions =
        Provider.of<TransactionState>(context).searchResults;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _queryController,
          decoration: InputDecoration(
            hintText: "Search transaction",
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: transactions == null
          ? Container()
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) => TransactionListItem(
                transaction: transactions[index],
              ),
            ),
    );
  }
}
