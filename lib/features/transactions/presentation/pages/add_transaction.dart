import 'package:flutter/material.dart';
import 'package:flutter_appwrite/features/auth/presentation/notifiers/auth_state.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';
import 'package:flutter_appwrite/features/transactions/presentation/notifiers/transaction_state.dart';
import 'package:provider/provider.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  DateTime today;
  DateTime _tdate;
  TextEditingController _titleController;
  TextEditingController _amountController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    _tdate = today;
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: "title"),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(hintText: "amount"),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(hintText: "description"),
          ),
          const SizedBox(height: 10.0),
          CalendarDatePicker(
            firstDate: DateTime(today.year - 5),
            lastDate: DateTime(today.year + 5),
            initialDate: _tdate,
            onDateChanged: (date) {
              setState(() {
                _tdate = date;
              });
            },
          ),
          Center(
            child: RaisedButton(
              child: Text("Save"),
              onPressed: () async {
                String userId =
                    Provider.of<AuthState>(context, listen: false).user.id;
                    try {
                      
                await Provider.of<TransactionState>(context, listen: false)
                    .addTransaction(Transaction(
                  title: _titleController.text,
                  amount: int.parse(_amountController.text),
                  description: _descriptionController.text,
                  transactionDate: _tdate,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  userId: userId,
                ));
                Navigator.pop(context);
                    }catch(e) {
                      
                    }
              },
            ),
          )
        ],
      ),
    );
  }
}
