import 'package:flutter/material.dart';
import 'package:judicoinapp/models/BudgetModel.dart';
import 'package:judicoinapp/models/ChargeModel.dart';
import 'package:judicoinapp/helpers/JudiCoinDateFormatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judicoinapp/views/ChargeListPosition.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:pie_chart/pie_chart.dart';

class BudgetSummary extends StatefulWidget {
  const BudgetSummary({
    this.budget,
    this.chargesList,
  });

  final BudgetModel budget;
  final List<ChargeModel> chargesList;

  @override
  _BudgetSummaryState createState() => _BudgetSummaryState();
}

class _BudgetSummaryState extends State<BudgetSummary> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToMe(BuildContext context) {
    Scrollable.ensureVisible(context, curve: Curves.easeInOut, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    QuerySnapshot charges = Provider.of<QuerySnapshot>(context);
    Map<dynamic, List<ChargeModel>> groupedCharges;
    List<ChargeModel> chargeModels;
    List<ChargeModel> chargesList = List<ChargeModel>();
    if (charges != null) {
      chargeModels = charges.documents.map((e) => ChargeModel(e.data)).toList();
      groupedCharges = groupBy(chargeModels, (obj) => obj.category);
      groupedCharges.forEach((key, value) {
        chargesList.add(value.reduce((value, element) {
          return ChargeModel({
            'category': value.category,
            'value': value.charge + element.charge
          });
        }));
      });
    }

    final pieChartColors = [
      Color.fromRGBO(170, 69, 134, 1),
      Color.fromRGBO(198, 202, 237, 1),
      Color.fromRGBO(4, 138, 129, 1),
      Color.fromRGBO(199, 203, 133, 1),
      Color.fromRGBO(133, 67, 141, 1),
    ];

    Map<String, double> dataMap = Map.fromIterable(chargesList,
        key: (e) => e.category, value: (e) => e.charge);

    final chargesPieChart = PieChart(
        chartRadius: 150.0,
        showLegends: false,
        colorList: pieChartColors,
        animationDuration: Duration.zero,
        dataMap: dataMap);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Data utworzenia'),
              Text(
                  '${formatDateTime(widget.budget.creationDate.toDate().add(Duration(hours: 2)))}',
                  style: TextStyle(fontSize: 18.0)),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Kwota początkowa'),
                      Text(
                          '${widget.budget.startingState.toStringAsFixed(2)} PLN',
                          style: TextStyle(fontSize: 21.0)),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text('Wydano'),
                      Text(
                          '${(widget.budget.startingState - widget.budget.state).toStringAsFixed(2)} PLN',
                          style: TextStyle(fontSize: 21.0)),
                    ],
                  )
                ],
              ),
              ...(chargesList.length > 0 ? [chargesPieChart] : [])
            ],
          ),
        ),
        Flexible(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: chargesList.length,
            itemBuilder: (context, i) {
              return ChargeListPosition(
                color: pieChartColors[i],
                category: chargesList[i].category,
                charge: chargesList[i].charge,
                chargeGroup: groupedCharges[chargesList[i].category],
                scrollToMe: scrollToMe,
                amILast: i == chargesList.length - 1 ? true : false,
              );
            },
          ),
        )
      ],
    );
  }
}
