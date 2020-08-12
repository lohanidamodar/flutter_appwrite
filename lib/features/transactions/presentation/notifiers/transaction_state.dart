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
  String _query;
  List<Transaction> _searchResults;

  String get error => _error;
  List<Transaction> get transactions => _transactions;
  List<Transaction> get searchResults => _searchResults;

  set query(String query) {
    _query = query;
    _searchTransaction();
  }

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

  Future<List<Transaction>> queryTransactions(
      {DateTime from, DateTime to}) async {
    try {
      Response res = await db.listDocuments(
        collectionId: collectionId,
        filters: [
          "transaction_date>=${from.millisecondsSinceEpoch}",
          "transaction_date<=${to.millisecondsSinceEpoch}",
        ],
        orderField: 'transaction_date',
        orderType: OrderType.desc,
      );
      if (res.statusCode == 200) {
        return List<Transaction>.from(
            res.data["documents"].map((tr) => Transaction.fromJson(tr)));
      }
      return null;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  //search uses full text search
  //https://www.w3resource.com/mysql/mysql-full-text-search-functions.php
  Future<void> _searchTransaction() async {
    try {
      Response res = await db.listDocuments(
          collectionId: collectionId,
          orderField: 'transaction_date',
          search: "$_query");
      if (res.statusCode == 200) {
        _searchResults = List<Transaction>.from(
            res.data["documents"].map((tr) => Transaction.fromJson(tr)));
        notifyListeners();
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> _getTransactions() async {
    try {
      Response res = await db.listDocuments(
        collectionId: collectionId,
        orderField: 'transaction_date',
        orderType: OrderType.desc,
      );
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

  Future deleteTransaction(Transaction transaction) async {
    try {
      await db.deleteDocument(
        collectionId: collectionId,
        documentId: transaction.id,
      );
      _transactions = List<Transaction>.from(
          _transactions.where((tran) => tran.id != transaction.id));
      notifyListeners();
    } catch (e) {
      print(e.message);
    }
  }
}
