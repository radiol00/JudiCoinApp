import 'package:flutter/material.dart';

class JudiCoinPalette {
  static Color primary = Color.fromRGBO(239, 98, 108, 1);
  static Color primaryAccent = Color.fromRGBO(243, 237, 226, 1);
  static Color secondary = Color.fromRGBO(232, 219, 197, 1);
  static Color interest = Color.fromRGBO(222, 107, 72, 1);
  static Color dark = Color.fromRGBO(45, 45, 52, 1);
  static Color selection = Color.fromRGBO(200, 72, 169, 1);
  static Color lightSelection = Color.fromRGBO(255, 137, 224, 1);

  static InputDecoration deco = InputDecoration(
    filled: true,
    border: InputBorder.none,
    fillColor: JudiCoinPalette.primaryAccent,
  );

  static Icon getIconByName(String name) {
    IconData i = Icons.attach_money;
    if (name == 'food')
      i = Icons.fastfood;
    else if (name == 'attractions')
      i = Icons.account_balance;
    else if (name == 'relax')
      i = Icons.airline_seat_legroom_extra;
    else if (name == 'transport') i = Icons.directions_car;

    return Icon(i);
  }
}
