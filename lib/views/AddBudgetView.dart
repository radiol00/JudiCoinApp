import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:judicoinapp/helpers/JudiCoinPalette.dart';

class AddBudgetView extends StatefulWidget {
  @override
  _AddBudgetViewState createState() => _AddBudgetViewState();
}

class _AddBudgetViewState extends State<AddBudgetView> {
  final _formKey = GlobalKey<FormState>();
  final controller = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', rightSymbol: ' PLN');

  String name;
  double budget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dodaj nowy budżet',
          style: TextStyle(fontSize: 25.0),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Nazwa budżetu'),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        validator: (val) {
                          val = val.trim();
                          if (val.isEmpty) {
                            return 'Podaj nazwę!';
                          }

                          if (val.length < 3) {
                            return 'Nazwa musi zawierać conajmniej 3 znaki!';
                          }

                          return null;
                        },
                        decoration: JudiCoinPalette.deco,
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text('Kwota początkowa'),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            budget = controller.numberValue;
                          });
                        },
                        controller: controller,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          double budget = controller.numberValue;
                          if (budget == 0.0) {
                            return 'Wartość wymagana!';
                          }

                          return null;
                        },
                        decoration: JudiCoinPalette.deco
                            .copyWith(hintText: 'Kwota startowa'),
                      ),
                      SizedBox(height: 30.0),
                      FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.of(context)
                                .pop({'name': name, 'budget': budget});
                          }
                        },
                        child: Text(
                          'Dodaj',
                          style: TextStyle(color: Colors.white, fontSize: 19.0),
                        ),
                        color: JudiCoinPalette.primary,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
