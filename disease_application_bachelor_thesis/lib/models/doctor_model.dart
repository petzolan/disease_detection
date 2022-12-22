import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String? id;
  final String email;
   List<Object> createdSymptomsIDs;
   List<Object> createdDiseasesIDs;
   List<Object> createdAdvicesIDs;

  Doctor(
      {this.id,
      required this.email,
      required this.createdSymptomsIDs,
      required this.createdDiseasesIDs,
      required this.createdAdvicesIDs});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'created_symptoms': createdSymptomsIDs,
      'created_diseases': createdDiseasesIDs,
      'created_advices': createdAdvicesIDs
    };
  }

  Doctor.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        email = doc.data()!["email"],
        createdSymptomsIDs = doc.data()!["created_symptoms"].cast<String>(),
        createdDiseasesIDs = doc.data()!["created_diseases"].cast<String>(),
        createdAdvicesIDs = doc.data()!["created_advices"].cast<String>();
}
