import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judicoinapp/helpers/JudiCoinPalette.dart';
import 'package:judicoinapp/models/BudgetModel.dart';
import 'package:judicoinapp/services/DatabaseService.dart';
import 'package:judicoinapp/views/BudgetView.dart';
import 'package:provider/provider.dart';
import 'package:judicoinapp/helpers/JudiCoinDateFormatter.dart';

class BudgetList extends StatefulWidget {
  final String uid;
  BudgetList({this.uid});

  @override
  _BudgetListState createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  List<DocumentSnapshot> budgets = List<DocumentSnapshot>();

  Future<bool> promptBudgetDelete() async {
    return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Text('Czy napewno chcesz usunać ten budżet?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Tak')),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Nie'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var snapshot = Provider.of<QuerySnapshot>(context);
    if (snapshot != null) {
      List<DocumentSnapshot> documents = snapshot.documents;
      documents.sort((DocumentSnapshot a, DocumentSnapshot b) {
        double A = a.data['budget'];
        double B = b.data['budget'];
        return A.compareTo(B);
      });
      setState(() {
        budgets = documents;
      });
    }

    return ListView.builder(
      itemCount: budgets.length,
      itemBuilder: (context, i) {
        BudgetModel budget = BudgetModel(
            {...budgets[i].data, 'documentID': budgets[i].documentID});
        return Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Dismissible(
            dismissThresholds: {DismissDirection.startToEnd: 0.5},
            confirmDismiss: (DismissDirection direction) async {
              return await promptBudgetDelete();
            },
            background: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: JudiCoinPalette.dark,
                  ),
                  BoxShadow(
                    color: JudiCoinPalette.primary,
                    spreadRadius: 0.0,
                    blurRadius: 10.0,
                  ),
                ],
              ),
//              color: JudiCoinPalette.primary,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20.0,
                  ),
                  Icon(Icons.delete),
                  Text('Usuń budżet')
                ],
              ),
            ),
            direction: DismissDirection.startToEnd,
            key: Key(budgets[i].hashCode.toString()),
            onDismissed: (direction) async {
              await DatabaseService(uid: widget.uid)
                  .deleteBudget(budgets[i].documentID);
            },
            child: RaisedButton(
              color: JudiCoinPalette.interest,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => StreamProvider.value(
                    value: DatabaseService(uid: widget.uid)
                        .userCollection
                        .document(widget.uid)
                        .collection('budgets')
                        .document(budgets[i].documentID)
                        .collection('charges')
                        .snapshots(),
                    child: BudgetView(
                      budget: budget,
                      uid: widget.uid,
                    ),
                  ),
                ));
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${budget.name}',
                              style: TextStyle(
                                fontSize: 15.0,
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                              '${formatDateTime(budget.creationDate.toDate().add(Duration(hours: 2)))}',
                              style: TextStyle(
                                fontSize: 15.0,
                              ))
                        ],
                      ),
                      Text(
                        '${(budget.state + budget.increasedBy).toStringAsFixed(2)} PLN',
                        style: TextStyle(fontSize: 38.0, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
