import 'package:disease_application_bachelor_thesis/models/doctor_model.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_login/flutter_login.dart';

class AuthService {
  /* CREATE AN INSTANCE OF THE DATABASE */
  AuthService._();
  static AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> registration(SignupData pData) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: pData.name!,
        password: pData.password!,
      );
      
      Doctor d = Doctor(
        email: pData.name!,
        createdSymptomsIDs: [],
        createdDiseasesIDs: [],
        createdAdvicesIDs: [],
      );

      DatabaseService.instance.addNewDoctor(
        FirebaseAuth.instance.currentUser!.uid,
        d.toMap(),
      );
      
      print(FirebaseAuth.instance.currentUser);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> signIn(LoginData pData) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: pData.name,
        password: pData.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<String?> resetPassword(String pS, LoginData pData) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: pData.name)
        .catchError(
          (e) => print("error:" + e),
        );
    return "Success";
  }
}
