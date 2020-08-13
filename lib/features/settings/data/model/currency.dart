class Currency {
  String symbol;
  String name;
  String symbolNative;
  int decimalDigits;
  double rounding;
  String code;
  String namePlural;

  Currency(
      {this.symbol,
      this.name,
      this.symbolNative,
      this.decimalDigits,
      this.rounding,
      this.code,
      this.namePlural});

  Currency.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    name = json['name'];
    symbolNative = json['symbolNative'];
    decimalDigits = json['decimalDigits'];
    rounding = json['rounding'] != null ? double.parse("${json['rounding']}") : null;
    code = json['code'];
    namePlural = json['namePlural'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this.symbol;
    data['name'] = this.name;
    data['symbolNative'] = this.symbolNative;
    data['decimalDigits'] = this.decimalDigits;
    data['rounding'] = this.rounding;
    data['code'] = this.code;
    data['namePlural'] = this.namePlural;
    return data;
  }
}
