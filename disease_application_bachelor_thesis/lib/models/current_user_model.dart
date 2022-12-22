import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CurrentUser extends ChangeNotifier {
  late String _uid;
  late String _email;

  String get getUID => _uid;
  String get getEmail => _email;

  Future<String> onStartup() async {
    String value = 'error';

    try {
      User _firebaseUser = await FirebaseAuth.instance.currentUser!;
      
      if(_firebaseUser != null) {
        _uid = _firebaseUser.uid;
        _email = _firebaseUser.email!;
        value = 'success';
      }
    } catch (e) {
      print(e);
    }
    return value;
  }
}