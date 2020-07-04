import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appwrite/core/res/app_constants.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';

class TransactionState extends ChangeNotifier {
  final String collectionId = "5ecf0f487f580";
  Client client = Client();
  Database db;
  String _error;
  List<Transaction> _transactions;

  String get error => _error;
  List<Transaction> get transactions => _transactions;

  TransactionState() {
    _init();
  }

  _init() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    db = Database(client);
    _transactions = [];
    _getTransactions();
  }

  Future<void> _getTransactions() async {
    try {
      Response res = await db.listDocuments(collectionId: collectionId);
      if (res.statusCode == 200) {
        _transactions = List<Transaction>.from(
            res.data["documents"].map((tr) => Transaction.fromJson(tr)));
        notifyListeners();
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future addTransaction(Transaction transaction) async {
    try {
      Response res = await db.createDocument(
          collectionId: collectionId,
          data: transaction.toJson(),
          read: ["user:${transaction.userId}"],
          write: ["user:${transaction.userId}"]);
      transactions.add(Transaction.fromJson(res.data));
      notifyListeners();
      print(res.data);
    } catch (e) {
      print(e.message);
    }
  }

  Future updateTransaction(Transaction transaction) async {
    try {
      Response res = await db.updateDocument(
          collectionId: collectionId,
          documentId: transaction.id,
          data: transaction.toJson(),
          read: ["user:${transaction.userId}"],
          write: ["user:${transaction.userId}"]);
      Transaction updated = Transaction.fromJson(res.data);
      _transactions = List<Transaction>.from(
          _transactions.map((tran) => tran.id == updated.id ? updated : tran));
      notifyListeners();
    } catch (e) {
      print(e.message);
    }
  }
}
