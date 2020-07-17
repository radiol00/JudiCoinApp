import 'package:flutter_money_formatter/flutter_money_formatter.dart';

String formatCurrency(double currency){

  return FlutterMoneyFormatter(amount: currency, settings: MoneyFormatterSettings(symbol: 'PLN', decimalSeparator: ',', thousandSeparator: '.')).output.symbolOnRight;
}

String formatCurrencyNonSymbol(double currency){
  return FlutterMoneyFormatter(amount: currency, settings: MoneyFormatterSettings(symbol: 'PLN', decimalSeparator: ',', thousandSeparator: '.')).output.nonSymbol;
}