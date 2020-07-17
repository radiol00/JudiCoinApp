import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  String documentID;
  String name;
  double state;
  Timestamp creationDate;
  double startingState;

  BudgetModel(Map map){
    documentID = map['documentID'];
    name = map['name'];
    startingState = map['budget'];
    state = map['currentState'];
    creationDate = map['creationDate'];
  }
}