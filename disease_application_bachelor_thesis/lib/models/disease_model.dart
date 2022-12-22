import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';

class Disease {
  final String? id;
  String name;
  String description;
  Map<String, dynamic> symptoms;
  String treatment;
  num occurrence_probability;

  Disease({
    this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    required this.treatment,
    required this.occurrence_probability,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'symptoms': symptoms,
      'treatment': treatment,
      'occurrence_probability': occurrence_probability
    };
  }

  Disease.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        description = doc.data()!["description"],
        symptoms = doc.data()!["symptoms"],
        treatment = doc.data()!["treatment"],
        occurrence_probability = doc.data()!["occurrence_probability"];
}
