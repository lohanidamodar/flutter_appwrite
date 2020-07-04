class Transaction {
  String id;
  String title;
  String description;
  String userId;
  int transactionType;
  int amount;
  DateTime transactionDate;
  DateTime createdAt;
  DateTime updatedAt;

  Transaction(
      {this.id,
      this.title,
      this.description,
      this.userId,
      this.transactionType,
      this.amount,
      this.transactionDate,
      this.createdAt,
      this.updatedAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['\$id'];
    title = json['title'];
    description = json['description'];
    userId = json['user_id'];
    transactionType = json['transaction_type'];
    amount = json['amount'];
    transactionDate =
        DateTime.fromMillisecondsSinceEpoch(json['transaction_date']);
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at']);
    updatedAt = DateTime.fromMillisecondsSinceEpoch(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['transaction_type'] = this.transactionType;
    data['amount'] = this.amount;
    data['transaction_date'] = this.transactionDate.millisecondsSinceEpoch;
    data['created_at'] = this.createdAt.millisecondsSinceEpoch;
    data['updated_at'] = this.updatedAt.millisecondsSinceEpoch;
    return data;
  }
}
