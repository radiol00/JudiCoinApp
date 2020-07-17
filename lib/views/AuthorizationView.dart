import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:judicoinapp/helpers/JudiCoinPalette.dart';
import 'package:judicoinapp/services/AuthService.dart';
import 'package:judicoinapp/views/Loading.dart';

class AuthorizationView extends StatefulWidget {
  @override
  _AuthorizationViewState createState() => _AuthorizationViewState();
}

class _AuthorizationViewState extends State<AuthorizationView> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Login(
            goToPage: () {
              _pageController.animateToPage(1,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
          ),
          Register(goToPage: () {
            _pageController.animateToPage(0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          }),
        ],
      ),
    );
  }
}

class Login extends StatefulWidget {
  final Function goToPage;
  final AuthService _auth = AuthService();
  Login({this.goToPage});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  String error = '';

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return isLoading ? Loading() : Scaffold(
        body: Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Logowanie',
              style: TextStyle(
                fontSize: 40.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: email,
                      validator: (val) {
                        return val.isEmpty ? 'Email jest wymagany' : null;
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      decoration: JudiCoinPalette.deco.copyWith(hintText: 'Email'),
                    ),
                    SizedBox(height:5.0),
                    TextFormField(
                      initialValue: '',
                      validator: (val) {
                        return val.length < 6 ? 'Hasło musi zawierać 6 znaków' : null;
                      },
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      obscureText: true,
                      decoration: JudiCoinPalette.deco.copyWith(hintText: 'Hasło'),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: 60.0),
                      onPressed: () async {
                        setState(() {
                          error = '';
                        });
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          dynamic user = await widget._auth.logInEmailPasswd(email, password);
                          if (user == null) {
                            setState(() {
                              isLoading = false;
                              password = '';
                              error = 'Wystąpił błąd z logowaniem!';
                            });
                          }
                        }
                      },
                      color: JudiCoinPalette.primary,
                      child: Text(
                        'Zaloguj',
                        style: TextStyle(color: Colors.white, fontSize: 19.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FlatButton(
              onPressed: widget.goToPage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Nie masz konta? Zarejestruj się'),
                  Icon(
                    Icons.arrow_forward,
                    size: 30.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class Register extends StatefulWidget {
  final Function goToPage;
  final AuthService _auth = AuthService();
  Register({this.goToPage});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String error = '';

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    InputDecoration deco = InputDecoration(
      filled: true,
      border: InputBorder.none,
      fillColor: JudiCoinPalette.primaryAccent,
      focusedBorder: OutlineInputBorder(
          gapPadding: 0.0,
          borderSide: BorderSide(width: 2.0, color: JudiCoinPalette.primary)),
    );

    return isLoading ? Loading() : Scaffold(
        body: Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Rejestracja',
              style: TextStyle(
                fontSize: 40.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty ? 'Email jest wymagany' : null;
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      decoration: deco.copyWith(hintText: 'Email'),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      validator: (val) {
                        return val.length < 6 ? 'Hasło musi zawierać 6 znaków' : null;
                      },
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      obscureText: true,
                      decoration: deco.copyWith(hintText: 'Hasło'),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: 60.0),
                      onPressed: () async {
                        setState(() {
                          error = '';
                        });
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          dynamic user = await widget._auth
                              .registerEmailPasswd(email, password);
                          if (user == null) {
                            setState(() {
                              isLoading = false;
                              password = '';
                              error = 'Wystąpił błąd z rejestracją!';
                            });
                          }
                        }
                      },
                      color: JudiCoinPalette.primary,
                      child: Text(
                        'Zarejestruj',
                        style: TextStyle(color: Colors.white, fontSize: 19.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FlatButton(
              onPressed: widget.goToPage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.arrow_back,
                    size: 30.0,
                  ),
                  Text('Zaloguj się, jeśli masz już konto'),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
