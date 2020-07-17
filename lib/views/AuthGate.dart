import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judicoinapp/views/AuthorizationView.dart';
import 'package:judicoinapp/views/Home.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    if (user == null) {
      return AuthorizationView();
    } else {
      return Home();
    }
  }
}
