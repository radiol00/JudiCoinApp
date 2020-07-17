import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:judicoinapp/models/BudgetModel.dart';
import 'package:judicoinapp/helpers/JudiCoinPalette.dart';
import 'package:judicoinapp/services/DatabaseService.dart';

class IncreaseBudgetView extends StatefulWidget {
  final BudgetModel budget;
  final Function gotoSummaryPage;
  final String uid;
  IncreaseBudgetView({this.budget, this.gotoSummaryPage, this.uid});
  @override
  _IncreaseBudgetViewState createState() => _IncreaseBudgetViewState();
}

class _IncreaseBudgetViewState extends State<IncreaseBudgetView> {
  double increaseBy = 0.0;

  bool disableButton = false;

  final _key = GlobalKey<FormState>();
  final _moneyController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', rightSymbol: ' PLN');
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              textAlign: TextAlign.center,
              expands: false,
              onChanged: (value) {
                setState(() {
                  increaseBy = _moneyController.numberValue;
                });
              },
              validator: (value) {
                if (increaseBy == 0.0) {
                  return 'Podaj kwotę!';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              controller: _moneyController,
              decoration: JudiCoinPalette.deco.copyWith(
                  contentPadding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 8.0),
                  labelText: 'Podaj jaką kwotę dodać',
                  labelStyle: TextStyle(
                      letterSpacing: 1.0, fontSize: 18.0, color: Colors.black)),
            ),
            FlatButton(
                color: JudiCoinPalette.primary,
                disabledColor: JudiCoinPalette.primary,
                onPressed: disableButton
                    ? null
                    : () async {
                        if (_key.currentState.validate()) {
                          setState(() {
                            disableButton = true;
                          });
                          await DatabaseService(uid: widget.uid)
                              .addToExistingBudget(widget.budget.documentID,
                                  _moneyController.numberValue);
                          widget.budget.state += _moneyController.numberValue;
                          widget.gotoSummaryPage();
                        }
                      },
                child: Text(
                  'Dodaj',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
