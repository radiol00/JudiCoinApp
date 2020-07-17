import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:judicoinapp/services/AuthService.dart';
import 'package:judicoinapp/views/AuthGate.dart';
import 'package:judicoinapp/helpers/JudiCoinPalette.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RootWidget(),
    theme: ThemeData(
        scaffoldBackgroundColor: JudiCoinPalette.secondary,
        appBarTheme: AppBarTheme(
          color: JudiCoinPalette.primary,
          elevation: 0.0,
        )),
  ));
}

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: AuthGate(),
    );
  }
}
