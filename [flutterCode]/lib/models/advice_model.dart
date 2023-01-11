import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disease_application_bachelor_thesis/models/disease_model.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';
import 'package:flutter/cupertino.dart';

class Advice {
  final String id;
  String name;
  String description;
  List<String> symptoms;
  List<String> diseases;

  Advice(
      {
      required this.id,
      required this.name,
      required this.description,
      required this.symptoms,
      required this.diseases});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'symptoms': symptoms,
      'diseases': symptoms,
    };
  }

  Advice.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        description = doc.data()!["description"],
        symptoms = doc.data()!["symptoms"].toList().cast<String>(),
        diseases = doc.data()!["diseases"].toList().cast<String>();
}
