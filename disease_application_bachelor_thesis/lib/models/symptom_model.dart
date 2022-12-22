import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disease_application_bachelor_thesis/models/body_part_model.dart';

class Symptom {
  final String? id;
  String name;
  num defaultWeight;
  List<String> symptoms;

  Symptom( {
    this.id,
    required this.name,
    required this.defaultWeight,
    required this.symptoms,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'default_weight': defaultWeight,
      'proposed_symptoms': List<String>.from(
        symptoms.map((x) => x),
      ),
    };
  }

  Symptom.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        defaultWeight = doc.data()!["default_weight"],
        symptoms = List<String>.from(
          doc.data()!["proposed_symptoms"].toList(),
        );

}
