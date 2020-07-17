import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judicoinapp/helpers/JudiCoinPalette.dart';
import 'package:judicoinapp/services/AuthService.dart';
import 'package:judicoinapp/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'package:judicoinapp/views/BudgetList.dart';
import 'package:judicoinapp/views/AddBudgetView.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService(uid: user.uid).budgets,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
              dynamic result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBudgetView(),));
              if (result != null){
                DatabaseService(uid: user.uid).addNewBudget(result['name'], result['budget']);
              }
          },
          elevation: 2.0,
          child: Icon(
            Icons.add,
            size: 40.0,
          ),
          backgroundColor: JudiCoinPalette.primary,
        ),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.backspace),
              onPressed: () async {
                await _auth.signOut();
              }),
          title: Text(
            'JudiCoin',
            style: TextStyle(
              fontSize: 30.0,
              letterSpacing: 2.0,
              fontFamily: 'Galindo',
            ),
          ),
          centerTitle: true,
        ),
        body: BudgetList(
          uid: user.uid,
        ),
      ),
    );
  }
}
