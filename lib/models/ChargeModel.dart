import 'package:cloud_firestore/cloud_firestore.dart';

class ChargeModel {
  String category;
  double charge;
  Timestamp date;

  @override
  String toString(){
    return '$category $charge';
  }

  ChargeModel(Map map){
    category = map['category'];
    charge = map['value'];
    date = map['date'];
  }

  ChargeModel.fromModel(ChargeModel cm){
    category = cm.category;
    charge = cm.charge;
    date = cm.date;
  }

}