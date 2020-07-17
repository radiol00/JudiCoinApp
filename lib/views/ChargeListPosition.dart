import 'package:flutter/material.dart';
import 'package:judicoinapp/models/ChargeModel.dart';
import 'package:judicoinapp/helpers/JudiCoinDateFormatter.dart';
import 'package:judicoinapp/services/DatabaseService.dart';
import 'package:judicoinapp/models/BudgetModel.dart';

class ChargeListPosition extends StatefulWidget {
  final String category;
  final Color color;
  final List<ChargeModel> chargeGroup;
  final double charge;
  final Function scrollToMe;
  final bool amILast;
  final String uid;
  final BudgetModel budget;

  ChargeListPosition({
    @required this.uid,
    @required this.category,
    @required this.color,
    @required this.charge,
    @required this.chargeGroup,
    @required this.scrollToMe,
    @required this.amILast,
    @required this.budget,
  });

  @override
  _ChargeListPositionState createState() => _ChargeListPositionState();
}

class _ChargeListPositionState extends State<ChargeListPosition> {
  bool unRolled = false;
  bool visibleContent = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              visibleContent = false;
              unRolled = !unRolled;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Stack(
                      children: [
                        Text(
                          widget.category,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Center(
                          child: Text('${widget.charge.toStringAsFixed(2)} PLN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          onEnd: () {
            if (unRolled) {
              setState(() {
                visibleContent = true;
              });
              widget.scrollToMe(context);
            }
          },
          curve: Curves.easeInOut,
          height: unRolled ? 50.0 * widget.chargeGroup.length : 0,
          duration: widget.amILast
              ? Duration(milliseconds: 20)
              : Duration(milliseconds: 200),
          child: visibleContent
              ? Column(
                  children: widget.chargeGroup
                      .map((charge) => Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: Icon(
                                    Icons.delete,
                                  ),
                                ),
                              ),
                              Dismissible(
                                dismissThresholds: {
                                  DismissDirection.startToEnd: 0.5
                                },
                                direction: DismissDirection.startToEnd,
                                key: Key(charge.toString()),
                                onDismissed: (direction) async {
                                  await DatabaseService(uid: widget.uid).deleteChargeOfBudget(widget.budget.documentID, charge.chargeID, charge.charge);
                                  widget.budget.state += charge.charge;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: widget.color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 75.0, vertical: 5.0),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          '${formatDateTime(charge.date.toDate().add(Duration(hours: 2)))}',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      Text(
                                        '${charge.charge.toStringAsFixed(2)} PLN',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                )
              : null,
        ),
      ],
    );
  }
}
