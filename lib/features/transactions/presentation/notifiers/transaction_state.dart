import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appwrite/core/res/app_constants.dart';
import 'package:flutter_appwrite/features/transactions/data/model/transaction.dart';

class TransactionState extends ChangeNotifier {
  final String collectionId = "5ecf0f487f580";
  Client client = Client();
  Database db;
  String _error;

  String get error => _error;

  TransactionState() {
    _init();
  }

  _init() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    db = Database(client);
  }

  Future<List<Transaction>> transactions() async {
    try {
      Response res = await db.listDocuments(collectionId: collectionId);
      if(res.statusCode == 200) {
        return List<Transaction>.from( res.data["documents"].map((tr) => Transaction.fromJson(tr)));
      }else{
        return null;
      }
    }catch(e) {
      print(e.message);
      return null;
    }
  }


  
}
