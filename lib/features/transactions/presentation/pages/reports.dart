import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';
import 'package:flutter_appwrite/features/transactions/presentation/notifiers/transaction_state.dart';
import 'package:flutter_appwrite/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  DateTime startDate;
  DateTime endDate;
  DateTime today;
  int totalIncome = 0;
  int totalExpense = 0;
  bool loading = false;
  List<Transaction> transactions;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);

    startDate = Utils.firstDayOfWeek(today);
    endDate = today;

    _getTransactions();
  }

  startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 0, 0, 0);
  endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);

  _getTransactions() async {
    if (loading) return;
    setState(() {
      totalIncome = 0;
      totalExpense = 0;
      loading = true;
    });

    transactions = await Provider.of<TransactionState>(context, listen: false)
        .queryTransactions(from: startOfDay(startDate), to: endOfDay(endDate));
    if (transactions != null) {
      transactions.forEach((transaction) {
        if (transaction.transactionType == 2) {
          totalExpense += transaction.amount;
        } else if (transaction.transactionType == 1) {
          totalIncome += transaction.amount;
        }
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              DateFormat.yMMMd().format(startDate) +
                  " - " +
                  DateFormat.yMMMd().format(endDate),
            ),
            onTap: () async {
              List<DateTime> range = await DateRangePicker.showDatePicker(
                context: context,
                firstDate: DateTime(today.year - 5),
                lastDate: DateTime(today.year + 5),
                initialFirstDate: startDate,
                initialLastDate: endDate,
                initialDatePickerMode: DateRangePicker.DatePickerMode.day,
              );
              if (range != null) {
                startDate = range.first;
                endDate = range.last;
                _getTransactions();
              }
            },
          ),
          const SizedBox(height: 10.0),
          if (loading) CircularProgressIndicator(),
          if (!loading) ...[
            Row(
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text("Expense"),
                          Text("$totalExpense"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text("Income"),
                          Text("$totalIncome"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (transactions != null)
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: transactions.length,
                itemBuilder: (BuildContext context, int index) {
                  return TransactionListItem(
                    transaction: transactions[index],
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}
