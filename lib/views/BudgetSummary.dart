import 'package:flutter/material.dart';
import 'package:judicoinapp/models/BudgetModel.dart';
import 'package:judicoinapp/models/ChargeModel.dart';
import 'package:judicoinapp/helpers/JudiCoinDateFormatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:judicoinapp/views/ChargeListPosition.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:judicoinapp/helpers/JudiCoinCurrencyFormatter.dart';

class BudgetSummary extends StatefulWidget {
  final String uid;

  const BudgetSummary({
    @required this.uid,
    this.budget,
  });

  final BudgetModel budget;

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
    Scrollable.ensureVisible(context,
        curve: Curves.easeInOut, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    QuerySnapshot charges = Provider.of<QuerySnapshot>(context);
    Map<dynamic, List<ChargeModel>> groupedCharges;
    List<ChargeModel> chargeModels;
    List<ChargeModel> chargesList = List<ChargeModel>();
    double chargeSum = 0.0;
    if (charges != null) {
      chargeModels = charges.documents
          .map((e) => ChargeModel({...e.data, 'id': e.documentID}))
          .toList();
      groupedCharges = groupBy(chargeModels, (obj) => obj.category);
      groupedCharges.forEach((key, value) {
        chargesList.add(value.reduce((value, element) {
          return ChargeModel({
            'category': value.category,
            'value': value.charge + element.charge
          });
        }));
      });
      chargeModels.forEach((element) {
        chargeSum += element.charge;
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
        chartValueStyle: defaultChartValueStyle.copyWith(fontSize: 15.0),
        chartRadius: 150.0,
        showLegends: false,
        colorList: pieChartColors,
        animationDuration: Duration.zero,
        dataMap: dataMap);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  '${formatDateTime(widget.budget.creationDate.toDate().add(Duration(hours: 2)))}',
                  style: TextStyle(fontSize: 18.0)),
              SizedBox(
                height: 10.0,
              ),
              Text('Kwota początkowa'),
              Text(
                  formatCurrencyNonSymbol(widget.budget.startingState) +
                      (widget.budget.increasedBy != 0.0
                          ? ' + ' +
                              formatCurrencyNonSymbol(widget.budget.increasedBy)
                          : '') +
                      ' PLN',
                  style: TextStyle(fontSize: 21.0)),
              SizedBox(
                height: 10.0,
              ),
              Text('Wydano'),
              Text(formatCurrency(chargeSum),
                  style: TextStyle(fontSize: 21.0)),
              ...(chargesList.length > 0
                  ? [chargesPieChart]
                  : [
                      Container(
                        height: 345.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text('Brak obciążeń!'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 70.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Obciąż ten budżet'),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      )
                    ])
            ],
          ),
        ),
        Flexible(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: chargesList.length,
            itemBuilder: (context, i) {
              return ChargeListPosition(
                budget: widget.budget,
                uid: widget.uid,
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
