import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';

class BodyPart {
  final String? id;
  String name;
  List<String> symptoms;

  BodyPart({this.id, required this.name, required this.symptoms});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symptoms': List<String>.from(
        symptoms.map((x) => x),
      )
    };
  }

  BodyPart.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        symptoms = List<String>.from(
          doc.data()!["symptoms"].toList(),
        );
}
