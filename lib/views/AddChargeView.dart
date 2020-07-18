import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:judicoinapp/helpers/JudiCoinPalette.dart';
import 'package:judicoinapp/models/BudgetModel.dart';
import 'package:judicoinapp/services/DatabaseService.dart';

class AddChargeView extends StatefulWidget {
  final BudgetModel budget;
  final Function gotoSummaryPage;
  final String uid;
  AddChargeView({this.budget, this.gotoSummaryPage, this.uid});

  final Animatable<Color> backgroundFlash = TweenSequence([
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
          begin: Color.fromRGBO(255, 0, 0, 0),
          end: Color.fromRGBO(255, 0, 0, 0.3)),
    ),
    TweenSequenceItem(
        weight: 1,
        tween: ColorTween(
            begin: Color.fromRGBO(255, 0, 0, 0.3),
            end: Color.fromRGBO(255, 0, 0, 0)))
  ]);

  @override
  _AddChargeViewState createState() => _AddChargeViewState();
}

class _AddChargeViewState extends State<AddChargeView>
    with SingleTickerProviderStateMixin {
  int pickedCategoryIndex = -1;
  double charge = 0.0;
  final _key = GlobalKey<FormState>();
  List<Map> categories = List<Map>();

  bool disableButton = false;

  final _moneyController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', rightSymbol: ' PLN');
  AnimationController _animationController;

  void initState() {
    // TODO: implement initState
    categories.add({'category': 'Jedzenie', 'icon': 'food'});
    categories.add({'category': 'Transport', 'icon': 'transport'});
    categories.add({'category': 'Atrakcje', 'icon': 'attractions'});
    categories.add({'category': 'Relaks', 'icon': 'relax'});
    categories.add({'category': 'Inne', 'icon': 'other'});

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  final focusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    _moneyController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  focusNode: focusNode,
                  onFieldSubmitted: disableButton
                      ? null
                      : (value) async {
                          if (_key.currentState.validate() &&
                              pickedCategoryIndex != -1) {
                            setState(() {
                              disableButton = true;
                            });
                            await DatabaseService(uid: widget.uid).addNewCharge(
                                widget.budget.documentID,
                                _moneyController.numberValue,
                                categories[pickedCategoryIndex]['category']);
                            widget.budget.state -= _moneyController.numberValue;
                            widget.gotoSummaryPage();
                          } else if (pickedCategoryIndex == -1) {
                            FocusScope.of(context).requestFocus(focusNode);
                            await _animationController.forward();
                            _animationController.reset();
                          } else {
                            FocusScope.of(context).requestFocus(focusNode);
                          }
                        },
                  textAlign: TextAlign.center,
                  expands: false,
                  onChanged: (value) {
                    setState(() {
                      charge = _moneyController.numberValue;
                    });
                  },
                  validator: (value) {
                    if (charge == 0.0) {
                      return 'Podaj kwotę!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: _moneyController,
                  decoration: JudiCoinPalette.deco.copyWith(
                      contentPadding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 8.0),
                      labelText: 'Podaj kwotę obciążającą',
                      labelStyle: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 18.0,
                          color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                color: widget.backgroundFlash.evaluate(
                    AlwaysStoppedAnimation(_animationController.value)),
                height: 155.0,
                child: GridView.count(
                  crossAxisCount: 2,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      categories.length,
                      (index) => Container(
                            margin: EdgeInsets.all(3.0),
                            child: RaisedButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {
                                setState(() {
                                  pickedCategoryIndex = index;
                                });
                              },
                              color: index == pickedCategoryIndex
                                  ? JudiCoinPalette.selection
                                  : JudiCoinPalette.interest,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    JudiCoinPalette.getIconByName(
                                        categories[index]['icon']),
                                    Text(
                                      '${categories[index]['category']}',
                                      style: TextStyle(
                                          letterSpacing: 1.0,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                ),
              );
            },
          ),
        ),
        FlatButton(
            color: JudiCoinPalette.primary,
            disabledColor: JudiCoinPalette.primary,
            onPressed: disableButton
                ? null
                : () async {
                    if (_key.currentState.validate() &&
                        pickedCategoryIndex != -1) {
                      setState(() {
                        disableButton = true;
                      });
                      await DatabaseService(uid: widget.uid).addNewCharge(
                          widget.budget.documentID,
                          _moneyController.numberValue,
                          categories[pickedCategoryIndex]['category']);
                      widget.budget.state -= _moneyController.numberValue;
                      widget.gotoSummaryPage();
                    } else if (pickedCategoryIndex == -1) {
                      await _animationController.forward();
                      _animationController.reset();
                    }
                  },
            child: Text(
              'Obciąż',
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}
