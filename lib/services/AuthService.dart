import 'package:firebase_auth/firebase_auth.dart';
import 'package:judicoinapp/services/DatabaseService.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // user stream
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  // zaloguj email i haslem
  Future<FirebaseUser> logInEmailPasswd(email, password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // zarejestruj emailem i haslem
  Future<FirebaseUser> registerEmailPasswd(email, password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(0);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error singing out');
    }
  }
}
