import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  CollectionReference budgetsCollection;
  final String uid;
  DatabaseService({this.uid});

  Future addNewBudget(String name, double budget) async {
    userCollection
        .document(uid)
        .collection('budgets')
        .orderBy('budget', descending: true);
    return await userCollection.document(uid).collection('budgets').add({
      'currentState': budget,
      'budget': budget,
      'name': name,
      'creationDate': DateTime.now(),
      'increasedBy': 0.0,
    });
  }

  Future addNewCharge(String budget, double charge, String category) async {
    await userCollection
        .document(uid)
        .collection('budgets')
        .document(budget)
        .collection('charges')
        .add({
      'value': charge,
      'category': category,
      'date': DateTime.now(),
    });

    DocumentSnapshot currentState = await userCollection
        .document(uid)
        .collection('budgets')
        .document(budget)
        .get();
    double state = currentState.data['currentState'];

    return await userCollection
        .document(uid)
        .collection('budgets')
        .document(budget)
        .updateData({'currentState': state - charge});
  }

  Future deleteBudget(String budgetId) async {
    await userCollection
        .document(uid)
        .collection('budgets')
        .document(budgetId)
        .collection('charges')
        .getDocuments()
        .then((value) {
      for (DocumentSnapshot doc in value.documents) {
        doc.reference.delete();
      }
    });

    return await Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(userCollection
          .document(uid)
          .collection('budgets')
          .document(budgetId));
    });
  }

  Future addToExistingBudget(String budget, double increaseBy) async {
    DocumentSnapshot currentState = await userCollection
        .document(uid)
        .collection('budgets')
        .document(budget)
        .get();
    double state = currentState.data['increasedBy'];

    return await userCollection
        .document(uid)
        .collection('budgets')
        .document(budget)
        .updateData({'increasedBy': state + increaseBy});
  }

  Future deleteChargeOfBudget(
      String budget, String charge, double amount) async {
    DocumentSnapshot currentState = await userCollection
        .document(uid)
        .collection('budgets')
        .document(budget)
        .get();
    double state = currentState.data['currentState'];

    await userCollection
        .document(uid)
        .collection('budgets')
        .document(budget)
        .updateData({
      'currentState': state + amount,
    });

    return await Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(userCollection
          .document(uid)
          .collection('budgets')
          .document(budget)
          .collection('charges')
          .document(charge));
    });
  }

  Stream<QuerySnapshot> get budgets {
    return userCollection.document(uid).collection('budgets').snapshots();
  }
}
