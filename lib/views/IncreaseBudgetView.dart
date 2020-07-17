import 'package:flutter/material.dart';
import 'package:judicoinapp/models/BudgetModel.dart';


class IncreaseBudgetView extends StatefulWidget {
  final BudgetModel budget;
  final Function gotoSummaryPage;
  final String uid;
  IncreaseBudgetView({this.budget, this.gotoSummaryPage, this.uid});
  @override
  _IncreaseBudgetViewState createState() => _IncreaseBudgetViewState();
}

class _IncreaseBudgetViewState extends State<IncreaseBudgetView> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('elo'),);
  }
}
