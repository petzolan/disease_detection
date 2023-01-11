import 'dart:math';

import 'package:disease_application_bachelor_thesis/models/advice_model.dart';
import 'package:disease_application_bachelor_thesis/models/body_part_model.dart';
import 'package:disease_application_bachelor_thesis/models/disease_model.dart';
import 'package:disease_application_bachelor_thesis/models/doctor_model.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:survey_kit/survey_kit.dart';

class ConvertService {
  /* CREATE AN INSTANCE OF THE DATABASE */
  ConvertService._();
  static ConvertService _instance = ConvertService._();
  static ConvertService get instance => _instance;

  // SYMPTOMS
  Future<List<MultiSelectItem<String>>> getAllSymptoms() async {
    var data = await DatabaseService.instance.retrieveSymptoms();
    List<MultiSelectItem<String>> symptoms = [];
    for (var element in data) {
      symptoms.add(
        MultiSelectItem(element.name, element.name),
      );
    }
    return symptoms;
  }

  List<MultiSelectItem<String>> convertSymptoms(List<String> pSymptoms) {
    List<MultiSelectItem<String>> symptoms = [];
    for (var element in pSymptoms) {
      symptoms.add(MultiSelectItem(
        element,
        capitalize(
          element.replaceAll("_", " "),
        ),
      ));
    }
    return symptoms;
  }

  addNewSymptomToDatabase(
    BuildContext context,
    String pName,
    int pDefaultWeight,
    List<String> pProposedSymptoms,
    List<String> pBodyParts,
  ) {
    String pID = _converStringToID(pName);
    if (!DatabaseService.instance.checkIfSymptomExists(pID)) {
      List<String> proposedSymptoms = [];

      for (var element in pProposedSymptoms) {
        proposedSymptoms.add(_converStringToID(element));
      }

      List<String> bodyParts = [];
      for (var element in pBodyParts) {
        print(element);
        bodyParts.add(_converStringToID(element));
      }

      DatabaseService.instance.addNewSymptom(
        _converStringToID(pName),
        Symptom(
          id: pName.replaceFirst(" ", "_").toLowerCase(),
          name: pName,
          symptoms: proposedSymptoms,
          defaultWeight: pDefaultWeight,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully added to database"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something didnt work there"),
        ),
      );
    }
  }

  // BODY PARTS
  Future<List<MultiSelectItem<String>>> getAllBodyParts() async {
    var data = await DatabaseService.instance.retrieveBodyParts();
    List<MultiSelectItem<String>> bodyParts = [];
    print(data);
    for (var element in data) {
      bodyParts.add(MultiSelectItem(element.name, element.name));
    }
    return bodyParts;
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  // DISEASES
  Future<List<MultiSelectItem<String>>> getAllDiseases() async {
    var data = await DatabaseService.instance.retrieveDisease();
    List<MultiSelectItem<String>> diseases = [];

    for (var element in data) {
      diseases.add(MultiSelectItem(element.name, element.name));
    }
    return diseases;
  }

  // GENERAL STUFF
  _converStringToID(String pString) {
    return pString.replaceAll(" ", "_").toLowerCase();
  }

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;

  addNewDiseaseToDatabase(
    BuildContext context,
    String pName,
    String pDescription,
    String pTreatment,
    List<String> selectedSymptoms,
  ) {
    String pID = _converStringToID(pName);
    if (!DatabaseService.instance.checkIfSymptomExists(pID)) {
      List<String> proposedSymptoms = [];

      for (var element in selectedSymptoms) {
        proposedSymptoms.add(_converStringToID(element));
      }
      final _random = new Random();

      DatabaseService.instance.addNewDisease(
        _converStringToID(pName),
        Disease(
          name: pName,
          description: pDescription,
          symptoms: {
            for (var element in proposedSymptoms)
              element: doubleInRange(
                _random,
                0.0,
                3.0,
              ),
          },
          occurrence_probability: doubleInRange(
            _random,
            0.0,
            1.0,
          ),
          treatment: pTreatment,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully added to database"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something didnt work there"),
        ),
      );
    }
  }

  addNewBodyPartToDatabase(
      BuildContext context, String pName, List<String> pSymptoms) {
    String pID = _converStringToID(pName);
    if (!DatabaseService.instance.checkIfBodyPartExists(pID)) {
      DatabaseService.instance.addNewBodyPart(
          _converStringToID(pName), BodyPart(name: pName, symptoms: pSymptoms));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully added to database"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something didnt work there"),
        ),
      );
    }
  }

  addNewAdviceToDatabase(
    BuildContext context,
    String pName,
    String pDescription,
    List<String> pSymptoms,
    List<String> pDiseases,
  ) {
    String pID = _converStringToID(pName);
    List<String> proposedSymptoms = [];

    for (var element in pSymptoms) {
      proposedSymptoms.add(_converStringToID(element));
    }

    List<String> diseases = [];
    for (var element in pDiseases) {
      diseases.add(_converStringToID(element));
    }

    DatabaseService.instance.addNewAdvice(
      _converStringToID(pName),
      Advice(
        id: pName.replaceFirst(" ", "_").toLowerCase(),
        name: pName,
        description: pDescription,
        symptoms: proposedSymptoms,
        diseases: diseases,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Successfully added to database"),
      ),
    );
  }

  // Convert To SurveyElement
  Future<List<TextChoice>> convertSymptomsToSurveyElement() async {
    List<Symptom> symptoms = await DatabaseService.instance.retrieveSymptoms();
    List<TextChoice> choices = [];
    for (Symptom sym in symptoms) {
      choices.add(TextChoice(text: sym.name, value: sym.name));
    }

    return choices;
  }

  // Convert Body Parts to QuestionElement

  convertBodyPartToQuestionElement() {}
}
