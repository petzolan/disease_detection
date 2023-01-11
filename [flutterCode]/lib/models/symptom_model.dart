import 'package:cloud_firestore/cloud_firestore.dart';

class Symptom {
  final String id;
  String name;
  num defaultWeight;
  List<String> symptoms;

  Symptom({
    required this.id,
    required this.name,
    required this.defaultWeight,
    required this.symptoms,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'default_weight': defaultWeight,
      'proposed_symptoms': symptoms,
    };
  }

  Symptom.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        defaultWeight = doc.data()!["default_weight"],
        symptoms = doc.data()!["proposed_symptoms"].toList().cast<String>();
}
