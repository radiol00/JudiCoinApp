import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:judicoinapp/helpers/JudiCoinPalette.dart';
import 'package:judicoinapp/models/BudgetModel.dart';
import 'package:judicoinapp/views/AddChargeView.dart';
import 'package:judicoinapp/views/BudgetSummary.dart';
import 'package:judicoinapp/views/IncreaseBudgetView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class BudgetView extends StatefulWidget {
  final BudgetModel budget;
  final String uid;
  BudgetView({this.budget, this.uid});

  @override
  _BudgetViewState createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  bool showBudgetChargeSection = false;
  bool showIncreaseBudgetSection = false;
  bool devourTaps = false;
  int currentPage = 0;

  // controllers
  PageController _pageController = PageController();
  PageController _horizontalPageController = PageController();

  void gotoSummaryPage() async {
    setState(() {
      devourTaps = true;
    });
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration(milliseconds: 250));
    await _pageController.animateToPage(1,
        duration: Duration(seconds: 1), curve: Curves.ease);
    setState(() {
      showBudgetChargeSection = false;
      showIncreaseBudgetSection = false;
    });
    _pageController.jumpToPage(0);

    setState(() {
      devourTaps = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuerySnapshot charges = Provider.of<QuerySnapshot>(context);
    if (charges != null){
      setState(() {

      });
    }

    return IgnorePointer(
      ignoring: devourTaps,
      child: Scaffold(
        floatingActionButton: SpeedDial(
          overlayOpacity: 0,
          backgroundColor: JudiCoinPalette.primary,
          child: Icon(Icons.dehaze),
          children: [
            SpeedDialChild(
                onTap: () async {
                  if (!showBudgetChargeSection || _pageController.page != 0.0) {
                    setState(() {
                      devourTaps = true;
                      showBudgetChargeSection = true;
                    });

                    if (showIncreaseBudgetSection &&
                        _pageController.page == 0.0) {
                      _horizontalPageController.jumpToPage(0);
                      await _horizontalPageController.animateToPage(1,
                          duration: Duration(seconds: 1), curve: Curves.ease);
                      _horizontalPageController.jumpToPage(0);
                    } else {
                      _pageController.jumpToPage(1);
                      _pageController.animateToPage(0,
                          duration: Duration(seconds: 1), curve: Curves.ease);
                    }
                    setState(() {
                      devourTaps = false;
                      showIncreaseBudgetSection = false;
                    });
                  }
                },
                backgroundColor: currentPage == 0 && showBudgetChargeSection
                    ? JudiCoinPalette.lightSelection
                    : JudiCoinPalette.primaryAccent,
                label: 'Obciąż budżet',
                labelBackgroundColor:
                    currentPage == 0 && showBudgetChargeSection
                        ? JudiCoinPalette.lightSelection
                        : JudiCoinPalette.primaryAccent,
                child: Icon(
                  Icons.monetization_on,
                  color: JudiCoinPalette.primary,
                  size: 42.0,
                )),
            SpeedDialChild(
                onTap: () async {
                  if (!showIncreaseBudgetSection ||
                      _pageController.page != 0.0) {
                    setState(() {
                      devourTaps = true;
                      showIncreaseBudgetSection = true;
                    });

                    if (showBudgetChargeSection &&
                        _pageController.page == 0.0) {
                      _horizontalPageController.jumpToPage(1);
                      await _horizontalPageController.animateToPage(0,
                          duration: Duration(seconds: 1), curve: Curves.ease);
                    } else {
                      _pageController.jumpToPage(1);
                      _pageController.animateToPage(0,
                          duration: Duration(seconds: 1), curve: Curves.ease);
                    }
                    setState(() {
                      devourTaps = false;
                      showBudgetChargeSection = false;
                    });
                  }
                },
                backgroundColor: currentPage == 0 && showIncreaseBudgetSection
                    ? JudiCoinPalette.lightSelection
                    : JudiCoinPalette.primaryAccent,
                label: 'Powiększ budżet',
                labelBackgroundColor:
                    currentPage == 0 && showIncreaseBudgetSection
                        ? JudiCoinPalette.lightSelection
                        : JudiCoinPalette.primaryAccent,
                child: Icon(
                  Icons.add_circle,
                  color: JudiCoinPalette.primary,
                  size: 42.0,
                )),
          ],
        ),
        appBar: AppBar(
          title: Text('${widget.budget.name}'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: JudiCoinPalette.primary,
                        boxShadow: [
                          BoxShadow(
                              color: JudiCoinPalette.dark,
                              blurRadius: 15.0,
                              spreadRadius: -10.0)
                        ]),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Obecny stan budżetu',
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(widget.budget.state + widget.budget.increasedBy).toStringAsFixed(2)} PLN',
                          style: TextStyle(
                            fontSize: 42.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: PageView(
                  onPageChanged: (value) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      currentPage = value;
                    });
                  },
                  controller: _pageController,
                  pageSnapping: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    ...(!showBudgetChargeSection && !showIncreaseBudgetSection
                        ? []
                        : [
                            PageView(
                              controller: _horizontalPageController,
                              onPageChanged: (value) {
                                FocusScope.of(context).unfocus();
                              },
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...(!showIncreaseBudgetSection
                                    ? []
                                    : [
                                        IncreaseBudgetView(
                                          budget: widget.budget,
                                          gotoSummaryPage: gotoSummaryPage,
                                          uid: widget.uid,
                                        ),
                                      ]),
                                ...(!showBudgetChargeSection
                                    ? []
                                    : [
                                        AddChargeView(
                                          budget: widget.budget,
                                          gotoSummaryPage: gotoSummaryPage,
                                          uid: widget.uid,
                                        ),
                                      ]),
                              ],
                            )
                          ]),
                    BudgetSummary(
                      uid: widget.uid,
                      budget: widget.budget,
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
